//
//  Religiosity.swift
//  agents
//
//  Created by Michael Rommel on 09.09.18.
//  Copyright © 2018 Michael Rommel. All rights reserved.
//

import Foundation

// https://en.wikipedia.org/wiki/Religiosity
class Religiosity: Simulation {

	init() {
		super.init(name: "Religiosity", summary: "Religiosity desc", category: .core, value: 0.8)
	}

	override func setup(with simulation: GlobalSimulation) {

		self.add(simulation: StaticProperty(value: 0.8)) // TODO: remove

		simulation.simulations.append(self)
	}
}
