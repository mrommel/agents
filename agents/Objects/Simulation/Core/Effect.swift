//
//  Grudge.swift
//  agents
//
//  Created by Michael Rommel on 11.10.18.
//  Copyright © 2018 Michael Rommel. All rights reserved.
//

import Foundation

class Effect: Simulation {

	private var decay: Double = 0.9

	init(name: String, value: Double, decay: Double = 0.9) {

		self.decay = decay

		super.init(name: name, summary: "", category: .effects, value: value)
	}

	override func calculate() {
		self.stashedValue = self.value() * self.decay
	}
}

extension Effect: CustomStringConvertible {

	var description : String {
		return "Effect: \(self.name) with \(self.value())"
	}
}
