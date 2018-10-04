//
//  GrossDomesticProduct.swift
//  agents
//
//  Created by Michael Rommel on 28.09.18.
//  Copyright © 2018 Michael Rommel. All rights reserved.
//

import Foundation

class GrossDomesticProduct: Property {

	init() {
		super.init(name: "Gross Domestic Product", description: "", category: .core, value: 0.001)
	}

	override func valueText() -> String {
		return "\((self.value() * 60000).format(with: ".0")) / capita"
	}
}
