//
//  Conservatives.swift
//  agents
//
//  Created by Michael Rommel on 14.10.18.
//  Copyright © 2018 Michael Rommel. All rights reserved.
//

import Foundation

class Conservatives: Group {

	init() {

		super.init(name: "Conservatives",
				   summary: "Conservatives are believers in traditional family values, no sex before marriage, strong policies on law and order and are against the legalization of drugs. They are generally in favor of strong policies on law and order.",
				   moodValue: 0.6,
				   frequencyValue: 0.25)
	}

	override func setup(with simulation: GlobalSimulation) {

		simulation.groups.append(self)
	}
}
