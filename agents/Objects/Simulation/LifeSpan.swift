//
//  LifeSpan.swift
//  agents
//
//  Created by Michael Rommel on 27.09.18.
//  Copyright © 2018 Michael Rommel. All rights reserved.
//

import Foundation

extension Double {

	func between(from: Double, to: Double) -> Bool {
		return from <= self && self <= to
	}
}

class LifeSpan: Property {

	init() {
		super.init(name: "LifeSpan", description: "", category: .core, value: 0.4)
	}

	func nameForValue() -> String {
		if self.value().between(from: 0, to: 0.333) {
			return "Low"
		} else if self.value().between(from: 0.333, to: 0.666) {
			return "Medium"
		} else {
			return "High"
		}

	}

	override func valueText() -> String {
		return "\(self.nameForValue()) (\(self.value().format(with: ".2")))"
	}
}
