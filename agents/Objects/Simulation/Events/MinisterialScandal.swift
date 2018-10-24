//
//  MinisterialScandal.swift
//  agents
//
//  Created by Michael Rommel on 19.10.18.
//  Copyright © 2018 Michael Rommel. All rights reserved.
//

import Foundation

class MinisterialScandal: Event {

	init() {
		super.init(name: "MinisterialScandal",
				   summary: "It might not be anything to do with your policies or your personal conduct, but the actions of your staff are going to reflect on you. One of your junior ministers has been found to have an 'improper' relationship with his secretary. Our more conservative citizens are bound to disapprove and this could make for a noticeable drop in our popularity.",
				   category: .core)
	}

	override func effects(for global: GlobalSimulation?) -> [Effect] {

		let effectOnAll = Effect(name: "MinisterialScandal effect on All", value: -0.10, decay: 0.740)
		global?.groups.all.mood.add(simulation: effectOnAll, formula: "x", delay: 1)

		let effectOnConservatives = Effect(name: "MinisterialScandal effect on Conservatives", value: -0.25, decay: 0.790)
		global?.groups.conservatives.mood.add(simulation: effectOnConservatives, formula: "x", delay: 1)

		let effectOnReligious = Effect(name: "MinisterialScandal effect on Religious", value: -0.2, decay: 0.700)
		global?.groups.religious.mood.add(simulation: effectOnReligious, formula: "-0.1*x", delay: 1)

		let decayEffect = Effect(name: "MinisterialScandal decay", value: -0.95, decay: 0.8) //
		global?.events.monumentVandalizedEvent.add(simulation: decayEffect)

		return [effectOnAll, effectOnConservatives, effectOnReligious, decayEffect]
	}

	override func setup(with global: GlobalSimulation) {

		self.add(simulation: RandomProperty(minimum: 0.01, maximum: 0.2))
		/*self.add(simulation: simulation.winning, formula: "0.7*x")*/

		global.events.add(event: self)
	}
}
