//
//  Poverty.swift
//  agents
//
//  Created by Michael Rommel on 13.10.18.
//  Copyright © 2018 Michael Rommel. All rights reserved.
//

import Foundation

class Poverty: Property {

	init() {

		super.init(name: "Poverty",
				   summary: "The poverty threshold or poverty line is the minimum level of income deemed adequate in a particular country to meet the basic needs of human survival, including food, clothing, shelter, and healthcare.",
				   category: .welfare,
				   value: 0.64)
	}

	override func setup(with simulation: GlobalSimulation) {

		// TODO add inputs

		simulation.properties.append(self)
	}
}
