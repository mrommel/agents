//
//  Unemployment.swift
//  agents
//
//  Created by Michael Rommel on 13.10.18.
//  Copyright © 2018 Michael Rommel. All rights reserved.
//

import Foundation

class Unemployment: Property {

	init() {

		super.init(name: "Unemployment",
				   summary: "This is a count of the percentage of your population who recently sought employment. This statistic generally omits the long-term unemployed, such as those whose benefits ran out, or gave up finding work entirely. Unemployment tends to hardest hit the poor, young, rural residents, and other marginalized members of society.",
				   category: .economy,
				   value: 0.4)
	}

	override func setup(with simulation: Simulation) {
		
		self.add(property: simulation.grossDomesticProduct, formula: "0-(0.95*x)")
	}
}
