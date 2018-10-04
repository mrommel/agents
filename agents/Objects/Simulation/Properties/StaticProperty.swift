//
//  StaticProperty.swift
//  agents
//
//  Created by Michael Rommel on 13.09.18.
//  Copyright © 2018 Michael Rommel. All rights reserved.
//

import Foundation

class StaticProperty: Property {

	init(value: Double) {
		super.init(name: "static", description: "", category: .static, value: value)
	}
}
