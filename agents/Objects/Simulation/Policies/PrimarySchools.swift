//
//  PrimarySchools.swift
//  agents
//
//  Created by Michael Rommel on 09.10.18.
//  Copyright © 2018 Michael Rommel. All rights reserved.
//

import Foundation

class PrimarySchools: Policy {

	init() {
		let noSchoolSelection = PolicySelection(name: "No primary Schools", description: "No primary Schools", value: 0.0, enabled: true)
		let privatePrimarySchoolSelection = PolicySelection(name: "Private primary school attendance", description: "Private primary school attendance", value: 0.2, enabled: true)
		let compulsorySchooling2YearsSelection = PolicySelection(name: "2 Years compulsory school attendance", description: "abc2", value: 0.5, enabled: true)
		let compulsorySchooling4YearsSelection = PolicySelection(name: "4 Years compulsory school attendance", description: "abc2", value: 0.75, enabled: true)
		let compulsorySchooling6YearsSelection = PolicySelection(name: "6 Years compulsory school attendance", description: "abc2", value: 1.0, enabled: true)

		super.init(name: "Primary schooling",
				   summary: "Primary schooling description",
				   category: .core,
				   selections: [noSchoolSelection, privatePrimarySchoolSelection, compulsorySchooling2YearsSelection, compulsorySchooling4YearsSelection, compulsorySchooling6YearsSelection],
				   initialSelection: noSchoolSelection)
	}
}
