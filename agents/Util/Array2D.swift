//
//  Array2D.swift
//  agents
//
//  Created by Michael Rommel on 25.01.18.
//  Copyright © 2018 Michael Rommel. All rights reserved.
//

import Foundation

public class Array2D<T: Equatable> {
	public let columns: Int
	public let rows: Int
	fileprivate var array: Array<T?> = Array<T?>()

	public init(columns: Int, rows: Int) {
		self.columns = columns
		self.rows = rows
		self.array = Array<T?>(repeating: nil, count: rows * columns)
	}

	public subscript(column: Int, row: Int) -> T? {
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

extension Array2D where T: Comparable {

	var minimum: T {
		get {
			var mn: T = self[0, 0]!

			for x in 0..<self.columns {
				for y in 0..<self.rows {
					if mn > self[x, y]! {
						mn = self[x, y]!
					}
				}
			}

			return mn
		}
	}

	var maximum: T {
		get {
			var mx: T = self[0, 0]!

			for x in 0..<self.columns {
				for y in 0..<self.rows {
					if mx < self[x, y]! {
						mx = self[x, y]!
					}
				}
			}

			return mx
		}
	}
}

// MARK: fill methods

extension Array2D {

	func fill(with value: T) {
		for x in 0..<self.columns {
			for y in 0..<self.rows {
				self[x, y] = value
			}
		}
	}

	func fill(with function: (Int, Int) -> T) {
		for x in 0..<self.columns {
			for y in 0..<self.rows {
				self[x, y] = function(x, y)
			}
		}
	}
}

// MARK: grid method

extension Array2D {

	subscript(gridPoint: HexPoint) -> T? {
		get {
			return array[(gridPoint.y * columns) + gridPoint.x]
		}
		set(newValue) {
			array[(gridPoint.y * columns) + gridPoint.x] = newValue
		}
	}
}
