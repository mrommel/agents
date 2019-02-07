//
//  Poverty.swift
//  agents
//
//  Created by Michael Rommel on 13.10.18.
//  Copyright © 2018 Michael Rommel. All rights reserved.
//

import Foundation

class Poverty: Simulation {

    init() {

        super.init(name: "Poverty",
            summary: "The poverty threshold or poverty line is the minimum level of income deemed adequate in a particular country to meet the basic needs of human survival, including food, clothing, shelter, and healthcare.",
            category: .welfare,
            value: 0.64)
    }

    override func setup(with global: GlobalSimulation) {

        // TODO add inputs

        global.simulations.add(simulation: self)
    }
}
