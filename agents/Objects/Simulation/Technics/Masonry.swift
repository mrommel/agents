//
//  Masonry.swift
//  agents
//
//  Created by Michael Rommel on 23.10.18.
//  Copyright © 2018 Michael Rommel. All rights reserved.
//

import Foundation

class Masonry: Technic {

	init() {
		super.init(name: "Masonry",
				   era: .ancient,
				   propability: 0.01)
	}

	override func setup(with global: GlobalSimulation) {
		self.add(requirement: global.technics.mining)

		super.setup(with: global)
	}
}
