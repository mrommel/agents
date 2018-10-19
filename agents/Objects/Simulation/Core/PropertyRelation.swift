//
//  PropertyRelation.swift
//  agents
//
//  Created by Michael Rommel on 09.09.18.
//  Copyright © 2018 Michael Rommel. All rights reserved.
//

import Foundation

class PropertyRelation {
	let property: Property
	let formula: String
	let delay: Int

	init(property: Property, formula: String, delay: Int = 0) {
		self.property = property
		self.formula = formula
		self.delay = 0
	}
}
