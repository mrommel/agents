//
//  MortalityRate.swift
//  agents
//
//  Created by Michael Rommel on 14.09.18.
//  Copyright © 2018 Michael Rommel. All rights reserved.
//

import Foundation

// https://en.wikipedia.org/wiki/Mortality_rate
class MortalityRate: Simulation {

    init() {
        super.init(name: "MortalityRate", summary: "MortalityRate desc", category: .core, value: 0.5) // 0..<10
    }

    override func setup(with global: GlobalSimulation) {

        self.add(simulation: StaticProperty(value: 0.5)) // keep self value
        self.add(simulation: global.simulations.health, formula: "-0.3*x")
        self.add(simulation: global.simulations.foodPrice, formula: "0.5*x") // foodsecurity reduces mortality

        global.simulations.add(simulation: self)
    }
}
