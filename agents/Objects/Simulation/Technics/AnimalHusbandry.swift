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
		super.init(name: "Animal husbandry", era: .ancient, propability: 0.001)
	}

	override func setup(with global: GlobalSimulation) {

		// TODO: change propability based on animals that exist on the tile

		self.add(requirement: global.technics.agriculture)

		super.setup(with: global)
	}
}
