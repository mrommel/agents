//
//  Wheel.swift
//  agents
//
//  Created by Michael Rommel on 23.10.18.
//  Copyright © 2018 Michael Rommel. All rights reserved.
//

import Foundation

class Wheel: Technic {

	init() {
		super.init(name: "Wheel", era: .ancient, propability: 0.001)
	}

	override func setup(with simulation: GlobalSimulation) {

		// TODO: change propability based on plains adjacent to the tile

		self.add(requirement: simulation.technics.animalHusbandry)
		self.add(requirement: simulation.technics.archery)

		super.setup(with: simulation)
	}
}
