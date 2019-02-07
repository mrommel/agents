//
//  MonumentVandalized.swift
//  agents
//
//  Created by Michael Rommel on 13.10.18.
//  Copyright © 2018 Michael Rommel. All rights reserved.
//

import Foundation

class MonumentVandalized: Event {

    init() {
        super.init(name: "MonumentVandalized",
            summary: "Vandalism on our streets has reached new heights today when a gang of young thugs defaced our scared (sic) war memorial. It seems that crime has got completely out of control and no place is safe from the thugs and the vandals. Conservative voters are likely to be especially disappointed that things have got this bad.",
            category: .core)
    }

    override func effects(for global: GlobalSimulation?) -> [Effect] {

        let effectOnConservatives = Effect(name: "MonumentVandalized effect on Conservatives", value: -0.44, decay: 0.800)
        global?.groups.conservatives.mood.add(simulation: effectOnConservatives, formula: "-0.1*x", delay: 1)

        let decayEffect = Effect(name: "MonumentVandalized decay", value: -0.9, decay: 0.98) //
        global?.events.monumentVandalizedEvent.add(simulation: decayEffect)

        return [effectOnConservatives, decayEffect]
    }

    override func setup(with global: GlobalSimulation) {

        self.add(simulation: RandomProperty(minimum: 0.01, maximum: 0.2))
        self.add(simulation: global.simulations.crimeRate, formula: "0.3*x")

        global.events.add(event: self)
    }
}
