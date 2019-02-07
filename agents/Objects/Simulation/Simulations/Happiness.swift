//
//  Happiness.swift
//  agents
//
//  Created by Michael Rommel on 13.09.18.
//  Copyright © 2018 Michael Rommel. All rights reserved.
//

import Foundation

class Happiness: Simulation {

    init() {
        super.init(name: "Happiness", summary: "Happiness desc", category: .core, value: 0.8) // in percent
    }

    override func setup(with global: GlobalSimulation) {

        self.add(simulation: StaticProperty(value: 0.8)) // TODO: remove

        global.simulations.add(simulation: self)
    }
}
