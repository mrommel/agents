//
//  Trapping.swift
//  agents
//
//  Created by Michael Rommel on 23.10.18.
//  Copyright © 2018 Michael Rommel. All rights reserved.
//

import Foundation

class Trapping: Technic {

	init() {
		super.init(name: "Trapping", era: .ancient, propability: 0.001)
	}

	override func setup(with simulation: GlobalSimulation) {

		// TODO: change propability based on forest that are adjacent to the tile

		self.add(requirement: simulation.technics.animalHusbandry)

		super.setup(with: simulation)
	}
}
