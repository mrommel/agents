//
//  HexPoint.swift
//  agents
//
//  Created by Michael Rommel on 31.01.18.
//  Copyright © 2018 Michael Rommel. All rights reserved.
//

import Foundation

class HexPoint {
	let x: Int
	let y: Int
	
	init(x: Int, y: Int) {
		self.x = x
		self.y = y
	}
}

class HexCube {
	
	let q: Int
	let r: Int
	let s: Int
	
	init(q: Int, r: Int, s: Int) {
		self.q = q
		self.r = r
		self.s = s
	}
	
	init(q: Int, s: Int) {
		self.q = q
		self.s = s
		self.r = -q - s
	}
	
	convenience init(hex: HexPoint) {
		self.init(q: hex.x - (hex.y + (hex.y&1)) / 2, s: hex.y)
	}
	
	func distance(to cube: HexCube) -> Int {
		return max(abs(self.q - cube.q), abs(self.r - cube.r), abs(self.s - cube.s))
	}
}

func + (left: HexCube, right: HexCube) -> HexCube {
	return HexCube(q: left.q + right.q, r: left.r + right.r, s: left.s + right.s)
}

extension HexDirection {
	
	var cubeDirection: HexCube {
		switch self {
		case .north:
			return HexCube(q: 0, r: +1, s: -1)
		case .northeast:
			return HexCube(q: +1, r: 0, s: -1)
		case .southeast:
			return HexCube(q: +1, r: -1, s: 0)
		case .south:
			return HexCube(q: 0, r: -1, s: +1)
		case .southwest:
			return HexCube(q: -1, r: 0, s: +1)
		case .northwest:
			return HexCube(q: -1, r: +1, s: 0)
		}
	}
	
	var axialDirectionEven: HexPoint {
		switch self {
		case .north:
			return HexPoint(x: 0, y: -1)
		case .northeast:
			return HexPoint(x: +1, y: 0)
		case .southeast:
			return HexPoint(x: +1, y: +1)
		case .south:
			return HexPoint(x: 0, y: +1)
		case .southwest:
			return HexPoint(x: -1, y: +1)
		case .northwest:
			return HexPoint(x: -1, y: 0)
		}
	}
	
	var axialDirectionOdd: HexPoint {
		switch self {
		case .north:
			return HexPoint(x: 0, y: -1)
		case .northeast:
			return HexPoint(x: +1, y: -1)
		case .southeast:
			return HexPoint(x: +1, y: 0)
		case .south:
			return HexPoint(x: 0, y: +1)
		case .southwest:
			return HexPoint(x: -1, y: 0)
		case .northwest:
			return HexPoint(x: -1, y: -1)
		}
	}
}

func + (left: HexPoint, right: HexPoint) -> HexPoint {
	return HexPoint(x: left.x + right.x, y: left.y + right.y)
}

func - (left: HexPoint, right: HexPoint) -> HexPoint {
	return HexPoint(x: left.x - right.x, y: left.y - right.y)
}

func * (point: HexPoint, scalar: HexPoint) -> HexPoint {
	return HexPoint(x: point.x * scalar.x, y: point.y * scalar.y)
}

func / (point: HexPoint, scalar: HexPoint) -> HexPoint {
	return HexPoint(x: point.x / scalar.x, y: point.y / scalar.y)
}

func lerp(a: Double, b: Double, t: Double) -> Double {
	//return a + (b - a) * t
	return a * (1.0 - t) + b * t
}

func lerp(a: Int, b: Int, t: Double) -> Double {
	//return Double(a) + Double(b - a) * t
	return Double(a) * (1.0 - t) + Double(b) * t
}

extension HexPoint {
	
	convenience init(cube: HexCube) {
		self.init(x: cube.q + (cube.s + (cube.s&1)) / 2, y: cube.s)
	}
	
	/*func neighbor(in direction: HexDirection) -> HexPoint {
		let parity = self.x & 1
		return self + (parity == 1 ? direction.axialDirectionOdd : direction.axialDirectionEven)
	}*/
	func neighbor(in direction: HexDirection) -> HexPoint {
		let cubeNeighbor = HexCube(hex: self) + direction.cubeDirection
		return HexPoint(cube: cubeNeighbor)
	}
	
	func neighbors() -> [HexPoint] {
		
		var neighboring = [HexPoint]()
		
		neighboring.append(self.neighbor(in: .north))
		neighboring.append(self.neighbor(in: .northeast))
		neighboring.append(self.neighbor(in: .southeast))
		neighboring.append(self.neighbor(in: .south))
		neighboring.append(self.neighbor(in: .southwest))
		neighboring.append(self.neighbor(in: .northwest))
		
		return neighboring
	}
	
	func distance(to hex: HexPoint) -> Int {
		let selfCube = HexCube(hex: self)
		let hexCube = HexCube(hex: hex)
		return selfCube.distance(to: hexCube)
	}
	
	// returns the direction of the neighbor (or nil when this is not a neighbor)
	func direction(towards hex: HexPoint) -> HexDirection? {
		
		for direction in HexDirection.all {
			if self.neighbor(in: direction) == hex {
				return direction
			}
		}
		
		return nil
	}
}

extension HexPoint: Hashable, Equatable {
	
	var hashValue: Int {
		return self.x << 16 + self.y
	}
}

// If an object is Hashable, it's also Equatable. To conform
// to the requirements of the Equatable protocol, you need
// to implement the == operation (which returns true if two objects
// are the same, and false if they aren't)
func == (first: HexPoint, second: HexPoint) -> Bool {
	return first.x == second.x && first.y == second.y
}

extension HexPoint: CustomStringConvertible {
	
	public var description: String {
		return "HexPoint(\(self.x), \(self.y))"
		
	}
}

extension HexCube {
	
	///
	/// double value constructor
	/// values are rounded
	///
	convenience init(dq: Double, dr: Double, ds: Double) {
		
		var rq: Int = lround(dq)
		var rr: Int = lround(dr)
		var rs: Int = lround(ds)
		
		let q_diff = abs(Double(rq) - dq)
		let r_diff = abs(Double(rr) - dr)
		let s_diff = abs(Double(rs) - ds)
		
		if q_diff > r_diff && q_diff > s_diff {
			rq = -rr - rs
		} else if r_diff > s_diff {
			rr = -rq - rs
		} else {
			rs = -rq - rr
		}
		
		self.init(q: rq, r: rr, s: rs)
	}
	
	func line(to target: HexCube) -> [HexCube] {
		let length = self.distance(to: target)
		var result: [HexCube] = []
		
		for i in 0..<(length + 1) {
			let t = (1.0 / Double(length)) * Double(i)
			let c = HexCube(dq: lerp(a: Double(self.q) + 1e-6, b: Double(target.q) + 1e-6, t: t),
							dr: lerp(a: Double(self.r) + 1e-6, b: Double(target.r) + 1e-6, t: t),
							ds: lerp(a: Double(self.s) + 1e-6, b: Double(target.s) + 1e-6, t: t))
			result.append(c)
		}
		
		return result
	}
}

extension HexCube: CustomStringConvertible {
	
	public var description: String {
		return "HexCube(\(self.q), \(self.r), \(self.s))"
	}
}
