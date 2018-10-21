//
//  PropertyRelation.swift
//  agents
//
//  Created by Michael Rommel on 09.09.18.
//  Copyright © 2018 Michael Rommel. All rights reserved.
//

import Foundation

class SimulationRelation {

	let simulation: Simulation
	let formula: String
	let delay: Int

	init(simulation: Simulation, formula: String, delay: Int = 0) {
		self.simulation = simulation
		self.formula = formula
		self.delay = 0
	}
}
