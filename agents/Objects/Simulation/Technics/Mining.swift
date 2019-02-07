//
//  Mining.swift
//  agents
//
//  Created by Michael Rommel on 23.10.18.
//  Copyright © 2018 Michael Rommel. All rights reserved.
//

import Foundation

class Mining: Technic {

    init() {
        super.init(name: "Mining", era: .ancient, propability: 0.01)
    }

    override func setup(with global: GlobalSimulation) {

        self.propability = global.tileInfo.mineralsPropability

        self.add(requirement: global.technics.agriculture)

        super.setup(with: global)
    }
}
