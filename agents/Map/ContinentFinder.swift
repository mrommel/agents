//
//  ContinentFinder.swift
//  agents
//
//  Created by Michael Rommel on 02.02.18.
//  Copyright © 2018 Michael Rommel. All rights reserved.
//

import Foundation

class ContinentFinder {
		
	private var continentIdentifiers: Array2D<Int>
	
	init(width: Int, height: Int) {
		
		self.continentIdentifiers = Array2D<Int>(columns: width, rows: height)
		self.continentIdentifiers.fill(with: ContinentConstants.kNotAnalyzed)
	}
	
	func evaluated(value: Int) -> Bool {
		
		return value != ContinentConstants.kNotAnalyzed && value != ContinentConstants.kNoContinent
	}
	
	@discardableResult
	func execute(on map: TileHexMap) -> [Continent] {
		
		for x in 0..<self.continentIdentifiers.columns {
			for y in 0..<self.continentIdentifiers.rows {
				
				self.evaluate(x: x, y: y, on: map)
			}
		}
		
		var continents = [Continent]()
		
		for x in 0..<self.continentIdentifiers.columns {
			for y in 0..<self.continentIdentifiers.rows {
				
				let continentIdentifier = self.continentIdentifiers[x, y]
					
				if self.evaluated(value: continentIdentifier!) {
						
					var continent = continents.first(where: { $0.identifier == continentIdentifier })
						
					if continent == nil {
						continent = Continent(identifier: continentIdentifier!, name: "Continent \(continentIdentifier ?? -1)", on: map)
						continents.append(continent!)
					}
						
					map.set(continent: continent, at: HexPoint(x: x, y: y))
						
					continent?.add(point: HexPoint(x: x, y: y))
				}
			}
		}
		
		return continents
	}
	
	func evaluate(x: Int, y: Int, on map: TileHexMap) {
		
		let p0 = HexPoint(x: x, y: y)
		
		if map.tile(at: p0)?.terrain != .ocean {
			
			let p1 = p0.neighbor(in: .north)
			let p2 = p0.neighbor(in: .northwest)
			let p3 = p0.neighbor(in: .southwest)
			
			let c1 = map.valid(point: p1) ? self.continentIdentifiers[p1.x, p1.y] : ContinentConstants.kNotAnalyzed
			let c2 = map.valid(point: p2) ? self.continentIdentifiers[p2.x, p2.y] : ContinentConstants.kNotAnalyzed
			let c3 = map.valid(point: p3) ? self.continentIdentifiers[p3.x, p3.y] : ContinentConstants.kNotAnalyzed
			
			if self.evaluated(value: c1!) {
				self.continentIdentifiers[x, y] = c1
			} else if self.evaluated(value: c2!) {
				self.continentIdentifiers[x, y] = c2
			} else if self.evaluated(value: c3!) {
				self.continentIdentifiers[x, y] = c3
			} else {
				let freeIdentifier = self.firstFreeIdentifier()
				self.continentIdentifiers[x, y] = freeIdentifier
			}
			
			// handle continent joins
			if self.evaluated(value: c1!) && self.evaluated(value: c2!) && c1 != c2 {
				self.replace(oldIdentifier: c2!, withIdentifier: c1!)
			} else if self.evaluated(value: c2!) && self.evaluated(value: c3!) && c2 != c3 {
				self.replace(oldIdentifier: c2!, withIdentifier: c3!)
			} else if self.evaluated(value: c1!) && self.evaluated(value: c3!) && c1 != c3 {
				self.replace(oldIdentifier: c1!, withIdentifier: c3!)
			}
			
		} else {
			self.continentIdentifiers[x, y] = ContinentConstants.kNoContinent
		}
	}
	
	func firstFreeIdentifier() -> Int {
		
		var freeIdentifiers = BitArray(repeating: true, count: 256)
		
		for x in 0..<self.continentIdentifiers.columns {
			for y in 0..<self.continentIdentifiers.rows {
				
				if let c = self.continentIdentifiers[x, y] {
					if c >= 0 && c < 256 {
						freeIdentifiers[c] = false
					}
				}
			}
		}
		
		for i in 0..<256 {
			if freeIdentifiers[i] {
				return i
			}
		}
		
		return ContinentConstants.kNoContinent
	}
	
	func replace(oldIdentifier: Int, withIdentifier newIdentifier: Int) {
		
		for x in 0..<self.continentIdentifiers.columns {
			for y in 0..<self.continentIdentifiers.rows {
				
				if self.continentIdentifiers[x, y] == oldIdentifier {
					self.continentIdentifiers[x, y] = newIdentifier
				}
			}
		}
	}
}
