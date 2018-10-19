//
//  MortalityRate.swift
//  agents
//
//  Created by Michael Rommel on 14.09.18.
//  Copyright © 2018 Michael Rommel. All rights reserved.
//

import Foundation

// https://en.wikipedia.org/wiki/Mortality_rate
class MortalityRate: Property {

	init() {
		super.init(name: "MortalityRate", summary: "MortalityRate desc", category: .core, value: 0.5) // 0..<10
	}

	override func setup(with simulation: Simulation) {

		self.add(property: StaticProperty(value: 0.5)) // keep self value
		self.add(property: simulation.health, formula: "-0.3*x")
		self.add(property: simulation.foodPrice, formula: "0.5*x") // foodsecurity reduces mortality

		simulation.properties.append(self)
	}
}
