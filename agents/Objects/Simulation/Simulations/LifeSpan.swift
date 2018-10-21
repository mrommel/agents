//
//  LifeSpan.swift
//  agents
//
//  Created by Michael Rommel on 27.09.18.
//  Copyright © 2018 Michael Rommel. All rights reserved.
//

import Foundation

/// LifeSpan
///
/// https://en.wikipedia.org/wiki/Life_expectancy
class LifeSpan: Property {

	let steps = ["0-10", "11-20", "21-30", "31-40", "41-50", "51-60", "61-70", "71-80", "81-90", "91-100"]

	init() {
		super.init(name: "LifeSpan", summary: "Life expectancy is a statistical measure of the average time an organism is expected to live, based on the year of its birth, its current age and other demographic factors including gender.", category: .core, value: 0.4)
	}

	override func setup(with simulation: GlobalSimulation) {

		// lifespan
		self.add(property: StaticProperty(value: 0.4)) // keep self value
		self.add(property: simulation.health, formula: "0.2*x") // health increases lifespan
		self.add(property: simulation.grossDomesticProduct, formula: "0.2*(7.02*ln(x*60000)+6.9)*0.01") // more gdp, more life span - https://en.wikipedia.org/wiki/Life_expectancy#/media/File:LifeExpectancy_GDPperCapita.png

		simulation.properties.append(self)
	}

	override func valueText() -> String {
		return "\(super.nameOfValue(from: self.steps)) (\(self.value().format(with: ".2")))"
	}
}
