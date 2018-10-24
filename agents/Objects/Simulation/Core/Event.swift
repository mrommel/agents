//
//  Event.swift
//  agents
//
//  Created by Michael Rommel on 10.10.18.
//  Copyright © 2018 Michael Rommel. All rights reserved.
//

import Foundation

class Event: Simulation {

	init(name: String, summary: String, category: Category) {

		super.init(name: name, summary: summary, category: category, value: 0.0)
	}

	func effects(for global: GlobalSimulation?) -> [Effect] {

		assertionFailure("Subclasses need to implement this method")

		return []
	}
}
