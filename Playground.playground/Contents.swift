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
		array = .init(repeating: initialValue, count: rows * columns)
	}

	public subscript(column: Int, row: Int) -> T {
		get {
			precondition(column < columns, "Column \(column) Index is out of range. Array<T>(columns: \(columns), rows:\(rows))")
			precondition(row < rows, "Row \(row) Index is out of range. Array<T>(columns: \(columns), rows:\(rows))")
			return array[row * columns + column]
		}
		set {
			precondition(column < columns, "Column \(column) Index is out of range. Array<T>(columns: \(columns), rows:\(rows))")
			precondition(row < rows, "Row \(row) Index is out of range. Array<T>(columns: \(columns), rows:\(rows))")
			array[row * columns + column] = newValue
		}
	}
}

class HexOrientation {

	let f0, f1, f2, f3: Double
	let b0, b1, b2, b3: Double
	let startAngle: Double // in multiples of 60°

	init(f0: Double, f1: Double, f2: Double, f3: Double, b0: Double, b1: Double, b2: Double, b3: Double, startAngle: Double) {

		self.f0 = f0
		self.f1 = f1
		self.f2 = f2
		self.f3 = f3
		self.b0 = b0
		self.b1 = b1
		self.b2 = b2
		self.b3 = b3
		self.startAngle = startAngle
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
			return HexCube(q: 0, r: 1, s: -1)
		case .northeast:
			return HexCube(q: 1, r: 0, s: -1)
		case .southeast:
			return HexCube(q: 1, r: -1, s: 0)
		case .south:
			return HexCube(q: 0, r: -1, s: 1)
		case .southwest:
			return HexCube(q: -1, r: 0, s: 1)
		case .northwest:
			return HexCube(q: -1, r: 1, s: 0)
		}
	}

	var axialDirectionEven: HexPoint {
		switch self {
		case .north:
			return HexPoint(x: 0, y: -1)
		case .northeast:
			return HexPoint(x: 1, y: 0)
		case .southeast:
			return HexPoint(x: 1, y: 1)
		case .south:
			return HexPoint(x: 0, y: 1)
		case .southwest:
			return HexPoint(x: -1, y: 1)
		case .northwest:
			return HexPoint(x: -1, y: 0)
		}
	}

	var axialDirectionOdd: HexPoint {
		switch self {
		case .north:
			return HexPoint(x: 0, y: -1)
		case .northeast:
			return HexPoint(x: 1, y: -1)
		case .southeast:
			return HexPoint(x: 1, y: 0)
		case .south:
			return HexPoint(x: 0, y: 1)
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

func lerp(minimum: Double, maximum: Double, weight: Double) -> Double {
	return minimum * (1.0 - weight) + maximum * weight
}

func lerp(minimum: Int, maximum: Int, weight: Double) -> Double {
	return Double(minimum) * (1.0 - weight) + Double(maximum) * weight
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
	convenience init(qDouble: Double, rDouble: Double, sDouble: Double) {

		var qRounded: Int = lround(qDouble)
		var rRounded: Int = lround(rDouble)
		var sRounded: Int = lround(sDouble)

		let qDiff = abs(Double(qRounded) - qDouble)
		let rDiff = abs(Double(rRounded) - rDouble)
		let sDiff = abs(Double(sRounded) - sDouble)

		if qDiff > rDiff && qDiff > sDiff {
			qRounded = -rRounded - sRounded
		} else if rDiff > sDiff {
			rRounded = -qRounded - sRounded
		} else {
			sRounded = -qRounded - rRounded
		}

		self.init(q: qRounded, r: rRounded, s: sRounded)
	}

	func line(to target: HexCube) -> [HexCube] {
		let length = self.distance(to: target)
		var result: [HexCube] = []

		for index in 0..<(length + 1) {
			let weigth = (1.0 / Double(length)) * Double(index)
			let cube = HexCube(qDouble: lerp(minimum: Double(self.q) + 1e-6, maximum: Double(target.q) + 1e-6, weight: weigth),
				rDouble: lerp(minimum: Double(self.r) + 1e-6, maximum: Double(target.r) + 1e-6, weight: weigth),
				sDouble: lerp(minimum: Double(self.s) + 1e-6, maximum: Double(target.s) + 1e-6, weight: weigth))
			result.append(cube)
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

	init() {
		layout = HexLayout(orientation: HexOrientation.flat, size: CGSize(width: 24, height: 18), origin: CGPoint.zero)
	}

	func screenAngle(from: HexPoint, towards: HexPoint) -> Int {

		let fromScreenPoint = self.toScreen(hex: from)
		let towardsScreenPoint = self.toScreen(hex: towards)

		let deltax = towardsScreenPoint.x - fromScreenPoint.x
		let deltay = towardsScreenPoint.y - fromScreenPoint.y

		return Int(atan2(deltax, deltay) * (180.0 / CGFloat(Double.pi)))
	}

	func degreesToDirection(degrees: Int) -> HexDirection {

		var degrees = degrees
		if (degrees < 0) {
			degrees += 360
		}

		if 30 < degrees && degrees <= 90 {
			return .northeast
		} else if 90 < degrees && degrees <= 150 {
			return .southeast
		} else if 150 < degrees && degrees <= 210 {
			return .south
		} else if 210 < degrees && degrees <= 270 {
			return .southwest
		} else if 270 < degrees && degrees <= 330 {
			return .northwest
		} else {
			return .north
		}
	}

	func screenDirection(from: HexPoint, towards: HexPoint) -> HexDirection {

		let angle = self.screenAngle(from: from, towards: towards)
		return degreesToDirection(degrees: angle)
	}

	func toScreen(cube: HexCube) -> CGPoint {

		let orientationMatrix = self.layout.orientation
		let x = (orientationMatrix.f0 * Double(cube.q) + orientationMatrix.f1 * Double(cube.r)) * Double(self.layout.size.width)
		let y = (orientationMatrix.f2 * Double(cube.q) + orientationMatrix.f3 * Double(cube.r)) * Double(self.layout.size.height)
		return CGPoint(x: x + Double(self.layout.origin.x), y: y + Double(self.layout.origin.y))
	}

	func toScreen(hex: HexPoint) -> CGPoint {

		return toScreen(cube: HexCube(hex: hex))
	}

	func toHexCube(screen: CGPoint) -> HexCube {

		let orientationMatrix = self.layout.orientation
		let point = CGPoint(x: (Double(screen.x) - Double(layout.origin.x)) / Double(layout.size.width),
			y: (Double(screen.y) - Double(layout.origin.y)) / Double(layout.size.height))
		let q = orientationMatrix.b0 * Double(point.x) + orientationMatrix.b1 * Double(point.y)
		let r = orientationMatrix.b2 * Double(point.x) + orientationMatrix.b3 * Double(point.y)
		return HexCube(qDouble: q, rDouble: r, sDouble: -q - r)
	}
}

print("---")
let cube = HexCube(q: 0, r: 0, s: 0)
/*let cube_n = HexCube(q: 0, r: 5, s: -5)
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
*/
