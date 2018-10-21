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

	override func setup(with simulation: GlobalSimulation) {
		self.add(simulation: simulation.population, formula: "x") // keep self value
		self.add(simulation: simulation.birthRate, formula: "0.02*x*v")
		self.add(simulation: simulation.mortalityRate, formula: "-0.02*x*v")

		simulation.simulations.append(self)
	}

	override func valueText() -> String {
		return "\(self.value().format(with: ".0")) People"
	}
}
