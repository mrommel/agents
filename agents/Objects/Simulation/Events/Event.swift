//
//  Event.swift
//  agents
//
//  Created by Michael Rommel on 10.10.18.
//  Copyright © 2018 Michael Rommel. All rights reserved.
//

import Foundation

class Event: Property {

	init(name: String, description: String, category: Category) {

		super.init(name: name, description: description, category: category, value: 0.0)
	}

	func grudges(for simulation: Simulation?) -> [Grudge] {

		assertionFailure("Subclasses need to implement this method")

		return []
	}
}
