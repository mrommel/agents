//
//  Earthquake.swift
//  agents
//
//  Created by Michael Rommel on 10.10.18.
//  Copyright © 2018 Michael Rommel. All rights reserved.
//

import Foundation

class Earthquake: Event {

	init() {
		super.init(name: "Earthquake", description: "An Earthquake happend", category: .core)
	}

	override func grudges(for simulation: Simulation?) -> [Grudge] {

		let grudgeOnHealth = Grudge(name: "Earthquake", description: "Earthquake", value: 0.9, decay: 0.7)
		simulation?.health.add(property: grudgeOnHealth, formula: "0.1*x", delay: 1)

		return [grudgeOnHealth]
	}
}
