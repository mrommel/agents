//
//  Health.swift
//  agents
//
//  Created by Michael Rommel on 14.09.18.
//  Copyright © 2018 Michael Rommel. All rights reserved.
//

import Foundation

class Health: Simulation {

	init() {
		super.init(name: "Health",
				   summary: "A general indicator for the health of your citizens that measures not just raw lifespan, but also fitness and the general wellbeing of people.",
				   category: .core,
				   value: 0.7)
	}

	override func setup(with simulation: GlobalSimulation) {

		self.add(simulation: StaticProperty(value: 0.7)) // keep self value
		self.add(simulation: simulation.lifeSpan, formula: "0.2*ln(x)") // lifespan decreases health

		simulation.simulations.append(self)
	}
}
