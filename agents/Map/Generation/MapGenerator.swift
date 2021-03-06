//
//  MapProvider.swift
//  agents
//
//  Created by Michael Rommel on 04.03.18.
//  Copyright © 2018 Michael Rommel. All rights reserved.
//

import Foundation

enum ClimateZoneOption {

	case earth

	case polarOnly
	case subpolarOnly
	case temperateOnly
	case subtropicOnly
	case tropicOnly
}

class MapGeneratorOptions {

	let mapSize: MapSize
	let climateZoneOption: ClimateZoneOption
	let waterPercentage: Float
	let rivers: Int

	required public init(withSize size: MapSize, zone: ClimateZoneOption, waterPercentage: Float, rivers: Int) {

		self.mapSize = size
		self.climateZoneOption = zone
		self.waterPercentage = waterPercentage
		self.rivers = rivers
	}
}

public typealias CompletionHandler = (Float) -> Void

class MapGenerator {

	let width: Int
	let height: Int

	let terrain: Array2D<Terrain>
	let zones: Array2D<ClimateZone>
	let distanceToCoast: Array2D<Int>
	var springLocations: [HexPoint]

	var completionHandler: CompletionHandler?

	/**
	creates a new grid generator for a map of `width`x`height` dimension
	
	- Parameter width: width of the resulting map
	- Parameter height: height of the resulting map
	*/
	required public init(width: Int, height: Int) {

		self.width = width
		self.height = height

		// prepare terrain, distanceToCoast and zones
		self.terrain = Array2D<Terrain>(columns: self.width, rows: self.height)
		self.distanceToCoast = Array2D<Int>(columns: self.width, rows: self.height)
		self.zones = Array2D<ClimateZone>(columns: self.width, rows: self.height)
		self.springLocations = []
	}

	func generate(with options: MapGeneratorOptions) -> TileHexMap? {

		// prepare result value
		let grid = TileHexMap(width: self.width, height: self.height)

		// 0st step: height and moisture map
		let heightMap = HeightMap(width: width, height: height)
		let moistureMap = HeightMap(width: width, height: height)

		if let completionHandler = self.completionHandler {
			completionHandler(0.2)
		}

		// 1st step: land / water
		self.fillFromElevation(withWaterPercentage: options.waterPercentage, on: heightMap)

		if let completionHandler = self.completionHandler {
			completionHandler(0.4)
		}

		// 2nd step: climate
		switch options.climateZoneOption {
		case .earth:
			self.setClimateZones()
		case .polarOnly:
			self.setClimateZones(with: .polar)
		case .subpolarOnly:
			self.setClimateZones(with: .subpolar)
		case .temperateOnly:
			self.setClimateZones(with: .temperate)
		case .subtropicOnly:
			self.setClimateZones(with: .subtropic)
		case .tropicOnly:
			self.setClimateZones(with: .tropic)
		}

		if let completionHandler = self.completionHandler {
			completionHandler(0.45)
		}

		// 2.1nd step: refine climate based on cost distance
		self.prepareDistanceToCoast()
		self.refineClimate()

		if let completionHandler = self.completionHandler {
			completionHandler(0.5)
		}

		// 3rd step: refine terrain
		self.refineTerrain(on: grid, with: heightMap, and: moistureMap)

		if let completionHandler = self.completionHandler {
			completionHandler(0.8)
		}

		// 4th step: rivers
		self.identifySpringLocations(on: heightMap)
		let rivers = self.add(rivers: options.rivers, on: heightMap)
		self.put(rivers: rivers, onto: grid)

		if let completionHandler = self.completionHandler {
			completionHandler(1.0)
		}

		return grid
	}

	// MARK: 1st step methods

	func waterOrLandFrom(elevation: Float, waterLevel: Float) -> Terrain {

		if elevation < waterLevel {
			return Terrain.water
		}

		return Terrain.ground
	}

	func fillFromElevation(withWaterPercentage waterPercentage: Float, on heightMap: HeightMap) {

		let waterLevel = heightMap.findWaterLevel(forWaterPercentage: waterPercentage)

		for x in 0..<width {
			for y in 0..<height {
				guard let height = heightMap[x, y] else {
					continue
				}

				let terrainType = self.waterOrLandFrom(elevation: height, waterLevel: waterLevel)

				if terrainType == Terrain.water {
					self.terrain[x, y] = Terrain.ocean
				} else {
					self.terrain[x, y] = Terrain.grass
				}
			}
		}
	}

	// MARK: 2nd step methods

	func setClimateZones() {

		self.zones.fill(with: .temperate)

		for x in 0..<width {
			for y in 0..<height {

				let latitude = abs(Float(height / 2 - y)) / Float(height / 2)

				if latitude > 0.8 {
					self.zones[x, y] = .polar
				} else if latitude > 0.6 {
					self.zones[x, y] = .subpolar
				} else if latitude > 0.4 {
					self.zones[x, y] = .temperate
				} else if latitude > 0.2 {
					self.zones[x, y] = .subtropic
				} else {
					self.zones[x, y] = .tropic
				}
			}
		}

		return
	}

	func setClimateZones(with zone: ClimateZone) {

		self.zones.fill(with: zone)
	}

	/**
	this function assumes that the self.terrain is filled with Terrain.ocean or Terrain.grass only
	*/
	func refineClimate() {

		for x in 0..<width {
			for y in 0..<height {

				guard let distance = self.distanceToCoast[x, y] else {
					continue
				}

				if distance < 2 {
					self.zones[x, y] = self.zones[x, y]?.moderate
				}
			}
		}
	}

	func prepareDistanceToCoast() {

		self.distanceToCoast.fill(with: Int.max)

		var actionHappened: Bool = true
		while actionHappened {

			// reset
			actionHappened = false

			for x in 0..<width {
				for y in 0..<height {

					// this needs to be analyzed
					if self.distanceToCoast[x, y] == Int.max {

						// if field is ocean => no distance
						if self.terrain[x, y] == Terrain.ocean {
							self.distanceToCoast[x, y] = 0
							actionHappened = true
						} else {
							// check neighbors
							var distance = Int.max
							let point = HexPoint(x: x, y: y)
							for direction in HexDirection.all {

								let neighbor = point.neighbor(in: direction)
								if neighbor.x >= 0 && neighbor.x < self.width && neighbor.y >= 0 && neighbor.y < self.height {

									if self.distanceToCoast[x, y] != Int.max {
										distance = min(distance, self.distanceToCoast[x, y]! + 1)
									}
								}
							}

							if distance < Int.max {
								self.distanceToCoast[x, y] = distance
								actionHappened = true
							}
						}
					}
				}
			}
		}
	}

	// MARK: 3rd step methods

	func refineTerrain(on grid: TileHexMap?, with heightMap: HeightMap, and moistureMap: HeightMap) {

		for x in 0..<width {
			for y in 0..<height {
				let gridPoint = HexPoint(x: x, y: y)

				if self.terrain[x, y] == Terrain.ocean {

					if heightMap[x, y]! > 0.1 {
						grid?.set(terrain: .shore, at: gridPoint)
					} else {
						grid?.set(terrain: .ocean, at: gridPoint)
					}
				} else {

					let terrainVal = self.biome(elevation: heightMap[x, y]!, moisture: moistureMap[x, y]!, climate: self.zones[x, y]!)

					grid?.set(terrain: terrainVal, at: gridPoint)

					if moistureMap[x, y]! > 0.5 {

						switch terrainVal {
						case .grass:
							if self.zones[x, y]! == .subtropic {
								grid?.set(feature: .forestRain, at: gridPoint)
							} else {
								grid?.set(feature: .forestMixed, at: gridPoint)
							}
						case .desert:
							grid?.set(feature: .oasis, at: gridPoint)
						case .plain:
							if self.zones[x, y]! == .subtropic {
								grid?.set(feature: .forestRain, at: gridPoint)
							} else {
								grid?.set(feature: .forestRain, at: gridPoint)
							}
						case .tundra:
							grid?.set(feature: .forestPine, at: gridPoint)
						default:
							break
						}
					}

					if heightMap[x, y]! > 0.7 {
						grid?.set(feature: .hill, at: gridPoint)
					} else if heightMap[x, y]! > 0.85 {
						grid?.set(feature: .mountain, at: gridPoint)
					}
				}
			}
		}
	}

	// from http://www.redblobgames.com/maps/terrain-from-noise/
	func biome(elevation: Float, moisture: Float, climate: ClimateZone) -> Terrain {

		switch climate {
		case .polar:
			return .snow
		case .subpolar:
			return self.biomeForSubpolar(elevation: elevation, moisture: moisture)
		case .temperate:
			return self.biomeForTemperate(elevation: elevation, moisture: moisture)
		case .subtropic:
			return self.biomeForSubtropic(elevation: elevation, moisture: moisture)
		case .tropic:
			return self.biomeForTropic(elevation: elevation, moisture: moisture)
		}
	}

	func biomeForSubpolar(elevation: Float, moisture: Float) -> Terrain {

		if elevation > 0.6 {
			return .snow
		}

		return .tundra
	}

	func biomeForTemperate(elevation: Float, moisture: Float) -> Terrain {

		if elevation > 0.9 {
			return .snow
		}

		if moisture < 0.5 {
			return .plain
		} else {
			return .grass
		}
	}

	func biomeForSubtropic(elevation: Float, moisture: Float) -> Terrain {

		if elevation > 0.9 {
			return .snow
		}

		if moisture < 0.2 {
			return .desert
		} else if moisture < 0.6 {
			return .plain
		} else {
			return .grass
		}
	}

	func biomeForTropic(elevation: Float, moisture: Float) -> Terrain {

		if elevation > 0.9 {
			return .snow
		}

		if moisture < 0.5 {
			return .desert
		} else {
			return .plain
		}
	}

	// MARK: 4th step methods - river

	func identifySpringLocations(on heightMap: HeightMap) {

		self.springLocations.removeAll()

		for x in 0..<width {
			for y in 0..<height {

				if let height = heightMap[x, y] {
					if height > 0.9 {
						let gridPoint = HexPoint(x: x, y: y)
						self.springLocations.append(gridPoint)
					}
				}
			}
		}
	}

	func add(rivers numberOfRivers: Int, on heightMap: HeightMap) -> [River] {

		let number = min(numberOfRivers, self.springLocations.count)

		// get a random excerpt of springLocations
		self.springLocations.shuffle()
		let selectedSprings = self.springLocations.choose(number)

		var rivers: [River] = []
		var unusedRiverNames = riverNames

		for spring in selectedSprings {

			let riverName = unusedRiverNames.chooseOne
			rivers.append(self.startRiver(with: riverName, at: spring, on: heightMap))
			let riverIndex = unusedRiverNames.index(where: { $0 == riverName })
			unusedRiverNames.remove(at: riverIndex!)
		}

		return rivers
	}

	func heightOf(corner: HexPointCorner, at gridPoint: HexPoint, on heightMap: HeightMap) -> Float {

		let adjacentPoints = gridPoint.adjacentPoints(of: corner)
		var amountOfPoints: Float = 0.0
		var height: Float = 0.0

		for adjacentPoint in adjacentPoints {
			// check if adjacentPoint is on map
			if adjacentPoint.x >= 0 && adjacentPoint.x < self.width && adjacentPoint.y >= 0 && adjacentPoint.y < self.height {
				amountOfPoints += 1.0
				if let heightValue = heightMap[adjacentPoint.x, adjacentPoint.y] {
					height += heightValue
				}
			}
		}

		if amountOfPoints > 0 {
			return height / amountOfPoints
		} else {
			return 0.0
		}
	}

	func startRiver(with name: String, at gridPoint: HexPoint, on heightMap: HeightMap) -> River {

		// get random corner
		let startCorner = randomGridPointCorner()
		let startGridPointWithCorner = HexPointWithCorner(with: gridPoint, andCorner: startCorner)

		let points = self.followRiver(at: startGridPointWithCorner, on: heightMap, depth: 30)

		let river = River(with: name, and: points)

		return river
	}

	func followRiver(at gridPointWithCorner: HexPointWithCorner, on heightMap: HeightMap, depth: Int) -> [HexPointWithCorner] {

		// cut recursion
		if depth <= 0 {
			return []
		}

		var lowestGridPointWithCorner: HexPointWithCorner = gridPointWithCorner
		var lowestValue: Float = Float.greatestFiniteMagnitude

		for corner in gridPointWithCorner.adjacentCorners() {

			// skip points outside the map
			if corner.point.x >= 0 && corner.point.x < self.width && corner.point.y >= 0 && corner.point.y < self.height {

				let heightOfCorner = self.heightOf(corner: corner.corner, at: corner.point, on: heightMap)

				if heightOfCorner < lowestValue {
					lowestValue = heightOfCorner
					lowestGridPointWithCorner = corner
				}
			}
		}

		var result: [HexPointWithCorner] = []

		if lowestValue < Float.greatestFiniteMagnitude {

			let targetTerrain = self.terrain[lowestGridPointWithCorner.point.x, lowestGridPointWithCorner.point.y]

			if targetTerrain != .ocean {

				// TODO: river sometimes get stuck and end in lakes

				result.append(lowestGridPointWithCorner)
				let newRiverTile = self.followRiver(at: lowestGridPointWithCorner, on: heightMap, depth: depth - 1)
				result.append(contentsOf: newRiverTile)
			}
		}

		return result
	}

	func put(rivers: [River], onto grid: TileHexMap?) {

		for river in rivers {
			grid?.add(river: river)
		}
	}
}
