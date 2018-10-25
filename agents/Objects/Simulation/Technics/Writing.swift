//
//  Writing.swift
//  agents
//
//  Created by Michael Rommel on 23.10.18.
//  Copyright © 2018 Michael Rommel. All rights reserved.
//

import Foundation

class Writing: Technic {

	init() {
		super.init(name: "Writing",
				   era: .ancient,
				   propability: 0.01)
	}

	override func setup(with simulation: GlobalSimulation) {
		self.add(requirement: simulation.technics.pottery)

		super.setup(with: simulation)
	}
}
