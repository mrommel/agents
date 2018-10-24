//
//  All.swift
//  agents
//
//  Created by Michael Rommel on 19.10.18.
//  Copyright © 2018 Michael Rommel. All rights reserved.
//

import Foundation

class All: Group {

	init() {

		super.init(name: "All",
				   summary: "A general group representing the interests of society as a whole, with opinions not related to a particular age group, gender or occupation.",
				   moodValue: 0.0,
				   frequencyValue: 1.0)
	}

	override func setup(with global: GlobalSimulation) {

		global.groups.add(group: self)
	}
}
