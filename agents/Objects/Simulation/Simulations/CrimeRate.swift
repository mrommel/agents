//
//  CrimeRate.swift
//  agents
//
//  Created by Michael Rommel on 13.10.18.
//  Copyright © 2018 Michael Rommel. All rights reserved.
//

import Foundation

class CrimeRate: Simulation {

	init() {

		super.init(name: "Crime",
				   summary: "An indicator of the level of general non violent crime in your nation. This includes crimes such as car crime, burglary etc., but also covers fraud and other similar crimes.",
				   category: .lawOrder,
				   value: 0.6)
	}

	override func setup(with global: GlobalSimulation) {

		self.add(simulation: global.simulations.unemployment, formula: "0.17*(x^5)")
		self.add(simulation: global.simulations.povertyRate, formula: "0.41*(x^2)", delay: 4)
		self.add(simulation: global.simulations.education, formula: "-0.12*(x^6)")

		global.simulations.add(simulation: self)
	}
}
