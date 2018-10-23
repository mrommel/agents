//
//  Pottery.swift
//  agents
//
//  Created by Michael Rommel on 23.10.18.
//  Copyright © 2018 Michael Rommel. All rights reserved.
//

import Foundation

class Pottery: Technic {

	init() {
		super.init(name: "Pottery", era: .ancient, propability: 0.1)
	}

	override func setup(with simulation: GlobalSimulation) {
		self.add(requirement: simulation.technics.agriculture)
	}
}
