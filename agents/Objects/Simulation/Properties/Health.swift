//
//  Health.swift
//  agents
//
//  Created by Michael Rommel on 14.09.18.
//  Copyright © 2018 Michael Rommel. All rights reserved.
//

import Foundation

class Health: Property {

	init() {
		super.init(name: "Health", description: "A general indicator for the health of your citizens that measures not just raw lifespan, but also fitness and the general wellbeing of people.", category: .core, value: 0.7)
	}
}
