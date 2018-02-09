//
//  HexMapDisplay.swift
//  agents
//
//  Created by Michael Rommel on 31.01.18.
//  Copyright © 2018 Michael Rommel. All rights reserved.
//

import Foundation
import SpriteKit

class HexMapDisplay {
	
	let layout: HexLayout
	
	init() {
		layout = HexLayout(orientation: HexOrientation.flat, size: CGSize(width: 24, height: 18), origin: CGPoint.zero)
	}
	
	func screenAngle(from: HexPoint, towards: HexPoint) -> Int {
		
		let fromScreenPoint = self.toScreen(hex: from)
		let towardsScreenPoint = self.toScreen(hex: towards)
		
		let dx = towardsScreenPoint.x - fromScreenPoint.x
		let dy = towardsScreenPoint.y - fromScreenPoint.y
		
		return Int(atan2(dx, dy) * (180.0 / CGFloat(Double.pi)))
	}
	
	func degreesToDirection(degrees: Int) -> HexDirection {
		
		var degrees = degrees
		if (degrees < 0) {
			degrees = degrees + 360
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
		
		let m = self.layout.orientation
		let x = (m.f0 * Double(cube.q) + m.f1 * Double(cube.r)) * Double(self.layout.size.width)
		let y = (m.f2 * Double(cube.q) + m.f3 * Double(cube.r)) * Double(self.layout.size.height)
		return CGPoint(x: x + Double(self.layout.origin.x), y: y + Double(self.layout.origin.y))
	}
	
	func toScreen(hex: HexPoint) -> CGPoint {
		
		return toScreen(cube: HexCube(hex: hex))
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
