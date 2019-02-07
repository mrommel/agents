//
//  Sewage.swift
//  agents
//
//  Created by Michael Rommel on 10.10.18.
//  Copyright © 2018 Michael Rommel. All rights reserved.
//

import Foundation

/// https://en.wikipedia.org/wiki/History_of_water_supply_and_sanitation
class Sewage: Policy {

    init() {

        let noSewageSelection = PolicySelection(name: "No Sewage", description: "No Sewage", value: 0.0, enabled: true)
        let middleStreetSewageSelection = PolicySelection(name: "Middel Street", description: "Sewage in the middle of the street to nearby rivers", value: 0.1, enabled: true)
        let sewageFarmsSelection = PolicySelection(name: "Sewage Farms", description: "", value: 0.7, enabled: false)
        let waterTreatmentSelection = PolicySelection(name: "Water Treatment", description: "Sewage in the middle of the street", value: 0.9, enabled: false)

        super.init(name: "Sewage",
            summary: "Sewage description",
            category: .core,
            selections: [noSewageSelection, middleStreetSewageSelection, sewageFarmsSelection, waterTreatmentSelection],
            initialSelection: noSewageSelection)
    }
}
