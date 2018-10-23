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
		super.init(name: "Wheel", era: .ancient, propability: 0.1)
	}

	override func setup(with simulation: GlobalSimulation) {
		self.add(requirement: simulation.technics.animalHusbandry)
		self.add(requirement: simulation.technics.archery)
	}
}
