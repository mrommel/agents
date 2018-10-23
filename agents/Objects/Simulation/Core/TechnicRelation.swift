//
//  TechnicRelation.swift
//  agents
//
//  Created by Michael Rommel on 22.10.18.
//  Copyright © 2018 Michael Rommel. All rights reserved.
//

import Foundation

class TechnicRelation {

	let technic: Technic
	let formula: String
	let delay: Int

	init(technic: Technic, formula: String, delay: Int = 0) {
		self.technic = technic
		self.formula = formula
		self.delay = 0
	}
}
