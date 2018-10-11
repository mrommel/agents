//
//  Grudge.swift
//  agents
//
//  Created by Michael Rommel on 11.10.18.
//  Copyright © 2018 Michael Rommel. All rights reserved.
//

import Foundation

class Grudge: Property {

	private var decay: Double = 0.9

	init(name: String, description: String, value: Double, decay: Double = 0.9) {

		self.decay = decay

		super.init(name: name, description: description, category: .grudge, value: value)
	}
}
