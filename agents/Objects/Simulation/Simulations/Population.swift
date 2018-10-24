//
//  Population.swift
//  agents
//
//  Created by Michael Rommel on 27.09.18.
//  Copyright © 2018 Michael Rommel. All rights reserved.
//

import Foundation

class Population: Simulation {

	init() {
		super.init(name: "Population", summary: "", category: .core, value: 1000.0)
	}

	override func setup(with global: GlobalSimulation) {
		self.add(simulation: global.simulations.population, formula: "x") // keep self value
		self.add(simulation: global.simulations.birthRate, formula: "0.02*x*v")
		self.add(simulation: global.simulations.mortalityRate, formula: "-0.02*x*v")

		global.simulations.add(simulation: self)
	}

	override func valueText() -> String {
		return "\(self.value().format(with: ".0")) People"
	}
}
