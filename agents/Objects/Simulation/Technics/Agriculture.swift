//
//  Agriculture.swift
//  agents
//
//  Created by Michael Rommel on 23.10.18.
//  Copyright © 2018 Michael Rommel. All rights reserved.
//

import Foundation

class Agriculture: Technic {

    init() {
        super.init(name: "Agriculture", era: .ancient, propability: 1.0, invented: true)
    }

    override func setup(with simulation: GlobalSimulation) {
        // NOOP
        super.setup(with: simulation)
    }
}
