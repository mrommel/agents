//
//  MortalityRate.swift
//  agents
//
//  Created by Michael Rommel on 14.09.18.
//  Copyright © 2018 Michael Rommel. All rights reserved.
//

import Foundation

// https://en.wikipedia.org/wiki/Mortality_rate
class MortalityRate: Property {

	init() {
		super.init(name: "MortalityRate", description: "MortalityRate desc", category: .core, value: 0.5) // 0..<10
	}
}
