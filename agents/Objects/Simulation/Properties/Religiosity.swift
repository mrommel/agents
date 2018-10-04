//
//  Religiosity.swift
//  agents
//
//  Created by Michael Rommel on 09.09.18.
//  Copyright © 2018 Michael Rommel. All rights reserved.
//

import Foundation

// https://en.wikipedia.org/wiki/Religiosity
class Religiosity: Property {

	init() {
		super.init(name: "Religiosity", description: "Religiosity desc", category: .core, value: 0.8)
	}
}
