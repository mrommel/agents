//
//  Map.swift
//  agents
//
//  Created by Michael Rommel on 23.01.18.
//  Copyright © 2018 Michael Rommel. All rights reserved.
//

import Foundation

class HexMap<T> {
	
	var tiles: Array2D<T>
	
	init(width: Int, height: Int, initialValue: T) {
		self.tiles = Array2D<T>(columns: width, rows: height, initialValue: initialValue)
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
}

extension TileHexMap: PathfinderDataSource {
	
	func walkableAdjacentTilesCoords(forTileCoord coord: HexPoint) -> [HexPoint] {
		
		var walkableCoords = [HexPoint]()
		
		for direction in HexDirection.all {
			let neighbor = coord.neighbor(in: direction)
			if self.valid(point: neighbor) && self.tile(at: neighbor)?.terrain == .grass {
				walkableCoords.append(neighbor)
			}
		}
		
		return walkableCoords
	}
	
	func costToMove(fromTileCoord: HexPoint, toAdjacentTileCoord toTileCoord: HexPoint) -> Int {
		return 1
	}
}
