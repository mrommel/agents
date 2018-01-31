//: Playground - noun: a place where people can play

import UIKit
import SceneKit

public struct Array2D<T> {
	public let columns: Int
	public let rows: Int
	fileprivate var array: [T]
	
	public init(columns: Int, rows: Int, initialValue: T) {
		self.columns = columns
		self.rows = rows
		array = .init(repeating: initialValue, count: rows*columns)
	}
	
	public subscript(column: Int, row: Int) -> T {
		get {
			precondition(column < columns, "Column \(column) Index is out of range. Array<T>(columns: \(columns), rows:\(rows))")
			precondition(row < rows, "Row \(row) Index is out of range. Array<T>(columns: \(columns), rows:\(rows))")
			return array[row*columns + column]
		}
		set {
			precondition(column < columns, "Column \(column) Index is out of range. Array<T>(columns: \(columns), rows:\(rows))")
			precondition(row < rows, "Row \(row) Index is out of range. Array<T>(columns: \(columns), rows:\(rows))")
			array[row*columns + column] = newValue
		}
	}
}

class HexOrientation {
	
	let f0, f1, f2, f3: Double
	let b0, b1, b2, b3: Double
	let start_angle: Double // in multiples of 60°
	
	init(f0: Double, f1: Double, f2: Double, f3: Double, b0: Double, b1: Double, b2: Double, b3: Double, start_angle: Double) {
		
		self.f0 = f0
		self.f1 = f1
		self.f2 = f2
		self.f3 = f3
		self.b0 = b0
		self.b1 = b1
		self.b2 = b2
		self.b3 = b3
		self.start_angle = start_angle
	}
	
	static let flat = HexOrientation(f0: 3.0 / 2.0, f1: 0, f2: sqrt(3.0) / 2.0, f3: sqrt(3.0), b0: 2.0 / 3.0, b1: 0.0, b2: -1.0 / 3.0, b3: sqrt(3.0) / 3.0, start_angle: 0.0)
}

struct HexLayout {
	
	let orientation: HexOrientation
	let size: CGSize
	let origin: CGPoint

	// grid tpye: even-q
}

enum HexDirection {
	case north
	case northeast
	case southeast
	case south
	case southwest
	case northwest
}

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
	
	func neighbor(in direction: HexDirection) -> HexPoint {
		let parity = self.x & 1
		return self + (parity == 1 ? direction.axialDirectionOdd : direction.axialDirectionEven)
	}
	
	func distance(to hex: HexPoint) -> Int {
		let selfCube = HexCube(hex: self)
		let hexCube = HexCube(hex: hex)
		return selfCube.distance(to: hexCube)
	}
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

class HexMap<T> {
	
	let tiles: Array2D<T>
	
	init(width: Int, height: Int, initialValue: T) {
		self.tiles = Array2D<T>(columns: width, rows: height, initialValue: initialValue)
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
}

class Tile {
	let terrain: String
	
	init(terrain: String) {
		self.terrain = terrain
	}
}

class HexMapDisplay {
	
	let layout: HexLayout
	//var offsetX: Int = 0
	//var offsetY: Int = 0
	
	init() {
		layout = HexLayout(orientation: HexOrientation.flat, size: CGSize(width: 30, height: 30), origin: CGPoint.zero)
	}
	
	func toScreen(cube: HexCube) -> CGPoint {
		let m = self.layout.orientation
		let x = (m.f0 * Double(cube.q) + m.f1 * Double(cube.r)) * Double(self.layout.size.width)
		let y = (m.f2 * Double(cube.q) + m.f3 * Double(cube.r)) * Double(self.layout.size.height)
		return CGPoint(x: x + Double(self.layout.origin.x), y: y + Double(self.layout.origin.y))
	}
	
	func toHexCube(screen: CGPoint) -> HexCube {
		let m = self.layout.orientation
		let pt = CGPoint(x: (Double(screen.x) - Double(layout.origin.x)) / Double(layout.size.width),
						 y: (Double(screen.y) - Double(layout.origin.y)) / Double(layout.size.height))
		let q = m.b0 * Double(pt.x) + m.b1 * Double(pt.y)
		let r = m.b2 * Double(pt.x) + m.b3 * Double(pt.y)
		return HexCube(dq: q, dr: r, ds: -q - r)
	}
}

print("---")
let cube = HexCube(q: 0, r: 0, s: 0)
let cube_n = HexCube(q: 0, r: 5, s: -5)
let cube_nw = HexCube(q: -5, r: 5, s: 0)
let cube_nw2 = HexCube(q: -2, r: 3, s: -1)

print("north distance: \(cube.distance(to: cube_n))")
print("north west distance: \(cube.distance(to: cube_nw))")
print("north west distance2: \(cube.distance(to: cube_nw2))")

let target = HexCube(q: 3, r: 1, s: -4)
let line = cube.line(to: target)
print("line: \(line)")

let map = HexMap<Tile>(width: 5, height: 5, initialValue: Tile(terrain: "ocean"))
print("tile: \(map.tile(x: 1, y: 1)!.terrain)")



