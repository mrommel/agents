//
//  AnimalHusbandry.swift
//  agents
//
//  Created by Michael Rommel on 23.10.18.
//  Copyright © 2018 Michael Rommel. All rights reserved.
//

import Foundation

class AnimalHusbandry: Technic {

	init() {
		super.init(name: "Animal husbandry", era: .ancient, propability: 0.2)
	}

	override func setup(with simulation: GlobalSimulation) {
		self.add(requirement: simulation.technics.agriculture)

		super.setup(with: simulation)
	}
}
