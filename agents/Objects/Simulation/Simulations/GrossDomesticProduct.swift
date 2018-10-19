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
		super.init(name: "Gross Domestic Product",
				   summary: "The Gross Domestic product of your country. This is defined as The total market value of all the goods and services produced within the nation in a year. This is a good general-purpose measure of the strength of your economy, and the nations overall wealth. One of the contributing factors is the global economic cycle, which tends to be cyclical, and is beyond your control.",
				   category: .economy,
				   value: 0.001)
	}

	override func setup(with simulation: Simulation) {

		self.add(property: StaticProperty(value: 0.001)) // TODO: remove

		simulation.properties.append(self)
	}

	override func valueText() -> String {
		return "\((self.value() * 60000).format(with: ".0")) / capita"
	}
}
