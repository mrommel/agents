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
		super.init(name: "Earthquake",
				   summary: "An Earthquake happend",
				   category: .core)
	}

	override func effects(for simulation: Simulation?) -> [Effect] {

		let effectOnHealth = Effect(name: "Earthquake effect on Health", value: 0.9, decay: 0.7)
		simulation?.health.add(property: effectOnHealth, formula: "-0.1*x", delay: 1)

		let decayEffect = Effect(name: "Earthquake decay", value: -1.0, decay: 0.9) //
		simulation?.earthQuakeEvent.add(property: decayEffect)

		return [effectOnHealth, decayEffect]
	}
}
