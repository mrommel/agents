//
//  BirthRate.swift
//  agents
//
//  Created by Michael Rommel on 09.09.18.
//  Copyright © 2018 Michael Rommel. All rights reserved.
//

import Foundation

// https://en.wikipedia.org/wiki/Birth_rate

// Factors generally associated with increased fertility include
// * religiosity,
// * intention to have children, and
// * maternal support.

// Factors generally associated with decreased fertility include
// * wealth,
// * education,
// * female labor participation,
// * urban residence,
// * intelligence,
// * increased female age and (to a lesser degree) increased male age.
class BirthRate: Simulation {

	init() {
		super.init(name: "BirthRate", summary: "BirthRate desc", category: .core, value: 0.6) // 0..<10
	}

	override func setup(with simulation: GlobalSimulation) {

		self.add(simulation: simulation.religiosity, formula: "0.7*x") // the more religious, the higher the birth rate
		self.add(simulation: simulation.health, formula: "(x-0.5)^0.7") // good health increases the birth rate
		self.add(simulation: simulation.lifeSpan, formula: "(x-0.5)^0.7") // lifespan reduces the birth rate (the older the people, the lower the relative timeframe when women can get pregnant

		simulation.simulations.append(self)
	}
}
