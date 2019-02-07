//
//  Earthquake.swift
//  agents
//
//  Created by Michael Rommel on 10.10.18.
//  Copyright © 2018 Michael Rommel. All rights reserved.
//

import Foundation

class Earthquake: Event {

    init() {
        super.init(name: "Earthquake",
            summary: "An Earthquake happend",
            category: .core)
    }

    override func effects(for global: GlobalSimulation?) -> [Effect] {

        let effectOnHealth = Effect(name: "Earthquake effect on Health", value: 0.9, decay: 0.7)
        global?.simulations.health.add(simulation: effectOnHealth, formula: "-0.1*x", delay: 1)

        let decayEffect = Effect(name: "Earthquake decay", value: -1.0, decay: 0.9) //
        global?.events.earthQuakeEvent.add(simulation: decayEffect)

        return [effectOnHealth, decayEffect]
    }

    override func setup(with global: GlobalSimulation) {

        self.add(simulation: RandomProperty(minimum: 0.01, maximum: 0.03)) //

        global.events.add(event: self)
    }
}
