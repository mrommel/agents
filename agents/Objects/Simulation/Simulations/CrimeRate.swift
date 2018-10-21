//
//  CrimeRate.swift
//  agents
//
//  Created by Michael Rommel on 13.10.18.
//  Copyright © 2018 Michael Rommel. All rights reserved.
//

import Foundation

class CrimeRate: Property {

	init() {

		super.init(name: "Crime",
				   summary: "An indicator of the level of general non violent crime in your nation. This includes crimes such as car crime, burglary etc., but also covers fraud and other similar crimes.",
				   category: .lawOrder,
				   value: 0.6)
	}

	override func setup(with simulation: GlobalSimulation) {

		self.add(property: simulation.unemployment, formula: "0.17*(x^5)")
		self.add(property: simulation.povertyRate, formula: "0.41*(x^2)", delay: 4)
		self.add(property: simulation.education, formula: "-0.12*(x^6)")

		simulation.properties.append(self)
	}
}
