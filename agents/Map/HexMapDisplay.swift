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
	//var offsetX: Int = 0
	//var offsetY: Int = 0
	
	init() {
		layout = HexLayout(orientation: HexOrientation.flat, size: CGSize(width: 24, height: 18), origin: CGPoint.zero)
	}
	
	func angle(from: HexPoint, towards: HexPoint) -> Int {
		let fromScreenPoint = self.toScreen(hex: from)
		let towardsScreenPoint = self.toScreen(hex: towards)
		
		return Int(atan2(towardsScreenPoint.x - fromScreenPoint.x, towardsScreenPoint.y - fromScreenPoint.y) * (180.0 / CGFloat(Double.pi)))
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
