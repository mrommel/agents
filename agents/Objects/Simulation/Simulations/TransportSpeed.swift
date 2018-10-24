//
//  TransportSpeed.swift
//  agents
//
//  Created by Michael Rommel on 21.10.18.
//  Copyright © 2018 Michael Rommel. All rights reserved.
//

import Foundation

// https://en.wikipedia.org/wiki/Transport#History
// 0.1 - walking
// 0.3 - domestication
// - steam
// - car
// - electricity
// - flight
class TransportSpeed: Simulation {

	init() {

		super.init(name: "Transport Speed",
				   summary: "Speed that it takes to get from point A to B. Includes good and people travelles",
				   category: .economy,
				   value: 0.1)
	}

	override func setup(with global: GlobalSimulation) {

		self.add(technic: global.technics.masonry, formula: "0.1*x")

		global.simulations.add(simulation: self)
	}

	/*override func valueText() -> String {

	}*/
}
