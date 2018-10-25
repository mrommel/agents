//
//  BronzeWorking.swift
//  agents
//
//  Created by Michael Rommel on 23.10.18.
//  Copyright © 2018 Michael Rommel. All rights reserved.
//

import Foundation

class BronzeWorking: Technic {

	init() {
		super.init(name: "Bronze working", era: .ancient, propability: 0.001)
	}

	override func setup(with global: GlobalSimulation) {

		self.propability = global.tileInfo.mineralsPropability

		self.add(requirement: global.technics.mining)

		super.setup(with: global)
	}
}
