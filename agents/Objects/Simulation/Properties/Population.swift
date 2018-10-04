//
//  Population.swift
//  agents
//
//  Created by Michael Rommel on 27.09.18.
//  Copyright © 2018 Michael Rommel. All rights reserved.
//

import Foundation

class Population: Property {

	init() {
		super.init(name: "Population", description: "", category: .core, value: 1000.0)
	}

	override func valueText() -> String {
		return "\(self.value().format(with: ".0")) People"
	}
}
