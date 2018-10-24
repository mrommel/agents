//
//  Masonry.swift
//  agents
//
//  Created by Michael Rommel on 23.10.18.
//  Copyright © 2018 Michael Rommel. All rights reserved.
//

import Foundation

class Masonry: Technic {

	init() {
		super.init(name: "Masonry", era: .ancient, propability: 0.1)
	}

	override func setup(with simulation: GlobalSimulation) {
		self.add(requirement: simulation.technics.mining)

		super.setup(with: simulation)
	}
}
