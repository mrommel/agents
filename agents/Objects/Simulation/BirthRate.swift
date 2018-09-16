//
//  BirthRate.swift
//  agents
//
//  Created by Michael Rommel on 09.09.18.
//  Copyright © 2018 Michael Rommel. All rights reserved.
//

import Foundation

// https://en.wikipedia.org/wiki/Birth_rate

// Factors generally associated with increased fertility include
// * religiosity,
// * intention to have children, and
// * maternal support.

// Factors generally associated with decreased fertility include
// * wealth,
// * education,
// * female labor participation,
// * urban residence,
// * intelligence,
// * increased female age and (to a lesser degree) increased male age.
class BirthRate: Property {

	init() {
		super.init(name: "BirthRate", description: "BirthRate desc", category: .core, value: 0.6) // 0..<10
	}
}
