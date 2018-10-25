//
//  Sailing.swift
//  agents
//
//  Created by Michael Rommel on 23.10.18.
//  Copyright © 2018 Michael Rommel. All rights reserved.
//

import Foundation

class Sailing: Technic {

	init() {
		super.init(name: "Sailing", era: .ancient, propability: 0.001)
	}

	override func setup(with simulation: GlobalSimulation) {

		// TODO: change propability based on adjanced sea tiles

		self.add(requirement: simulation.technics.pottery)

		super.setup(with: simulation)
	}
}
