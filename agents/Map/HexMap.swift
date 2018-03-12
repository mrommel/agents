//
//  Map.swift
//  agents
//
//  Created by Michael Rommel on 23.01.18.
//  Copyright © 2018 Michael Rommel. All rights reserved.
//

import Foundation

class HexMap<T: Equatable> {
	
	var tiles: Array2D<T>
	
	init(width: Int, height: Int) {
		self.tiles = Array2D<T>(columns: width, rows: height)
	}
	
	func valid(point: HexPoint) -> Bool {
		return 0 <= point.x && point.x < self.tiles.columns &&
			0 <= point.y && point.y < self.tiles.rows
	}
	
	func valid(x: Int, y: Int) -> Bool {
		return 0 <= x && x < self.tiles.columns &&
			0 <= y && y < self.tiles.rows
	}
	
	func tile(at point: HexPoint) -> T? {
		if !self.valid(x: point.x, y: point.y) {
			return nil
		}
		
		return self.tiles[point.x, point.y]
	}
	
	func tile(x: Int, y: Int) -> T? {
		if !self.valid(x: x, y: y) {
			return nil
		}
		
		return self.tiles[x, y]
	}
	
	func set(tile: T, at hex: HexPoint) {
		self.tiles[hex.x, hex.y] = tile
	}
}

class TileHexMap: HexMap<Tile> {
	
	override init(width: Int, height: Int) {
		super.init(width: width, height: height)
		
		for x in 0..<width {
			for y in 0..<height {
				let pt = HexPoint(x: x, y: y)
				self.set(tile: Tile(at: pt, with: .ocean), at: pt)
			}
		}
	}
	
	// own properties
	var rivers: [River] = []
	
	/// MARK: caldera
	
	func calderaSouth(at hex: HexPoint) -> Bool {
		return hex.y == self.tiles.rows - 1
	}
	
	func calderaEast(at hex: HexPoint) -> Bool {
		return hex.x == self.tiles.columns - 1
	}
	
	func caldera(at hex: HexPoint) -> String? {
		let calderaIsSouth = self.calderaSouth(at: hex)
		let calderaIsEast = self.calderaEast(at: hex)
		
		if calderaIsSouth || calderaIsEast {
			return calderaIsSouth && calderaIsEast ? "hex_board" : calderaIsSouth ? "hex_board_south" : hex.y % 2 == 1 ? "hex_board_east" : "hex_board_southeast"
		}
		
		if hex.x == 0 && hex.y % 2 == 1  {
			return "hex_board_west"
		}
		
		return nil
	}
	
	/// MARK: terrain
	
	func set(terrain: Terrain, at hex: HexPoint) {
		if let tile = self.tile(at: hex) {
			tile.terrain = terrain
		}
	}
	
	/// MARK: features
	
	func set(feature: Feature, at hex: HexPoint) {
		if let tile = self.tile(at: hex) {
			tile.set(feature: feature)
		}
	}
	
	func remove(feature: Feature, at hex: HexPoint) {
		if let tile = self.tile(at: hex) {
			tile.remove(feature: feature)
		}
	}
	
	/// MARK: continent
	
	func set(continent: Continent?, at hex: HexPoint) {
		if let tile = self.tile(at: hex) {
			tile.continent = continent
		}
	}
	
	/// MARK: building
	
	func set(building: Building, at hex: HexPoint) {
		if let tile = self.tile(at: hex) {
			tile.building = building
		}
	}
	
	// MARK: river
	func flows(at position: HexPoint) -> [FlowDirection] {
		
		// check bounds
		guard self.valid(point: position) else {
			return []
		}
		
		let tile = self.tiles[position]
		if let flows = tile?.flows {
			return flows
		}
		
		return []
	}
	
	public func add(river: River) {
		
		self.rivers.append(river)
		
		for riverPoint in river.points {
			
			// check bounds
			guard self.valid(point: riverPoint.point) else {
				continue
			}
			
			let tile = self.tiles[riverPoint.point]
			do {
				try tile?.set(river: river, with: riverPoint.flowDirection)
			} catch {
				print("something weird happend")
			}
		}
	}
}

extension TileHexMap: PathfinderDataSource {
	
	func walkableAdjacentTilesCoords(forTileCoord coord: HexPoint) -> [HexPoint] {
		
		var walkableCoords = [HexPoint]()
		
		for direction in HexDirection.all {
			let neighbor = coord.neighbor(in: direction)
			if self.valid(point: neighbor) /*&& self.tile(at: neighbor)?.terrain == .grass*/ {
				walkableCoords.append(neighbor)
			}
		}
		
		return walkableCoords
	}
	
	func costToMove(fromTileCoord: HexPoint, toAdjacentTileCoord toTileCoord: HexPoint) -> Int {
		return 1
	}
}
