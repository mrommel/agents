//
//  Simulation.swift
//  agents
//
//  Created by Michael Rommel on 04.09.18.
//  Copyright © 2018 Michael Rommel. All rights reserved.
//

import Foundation

protocol SimulationDelegate: class {
	func iterationComplete()
	func simulationTriggered(by event: Event?)
}

class Simulation {

	weak var delegate: SimulationDelegate?

	// Values / Properties
	var population: Population

	var birthRate: BirthRate
	var mortalityRate: MortalityRate
	var health: Health
	var lifeSpan: LifeSpan

	var religiosity: Religiosity

	var happiness: Happiness
	var foodSecurity: FoodSecurity

	var grossDomesticProduct: GrossDomesticProduct

	var properties: [Property] = []

	// Policies
	var primarySchools: PrimarySchools
	var sewage: Sewage

	var policies: [Policy] = []

	// Events

	var earthQuake: Earthquake

	var events: [Event] = []

	// Grudges

	var grudges: [Grudge] = []

	init() {

		self.population = Population() // total number
		self.properties.append(self.population)

		self.birthRate = BirthRate() // 0..1
		self.properties.append(self.birthRate)
		self.mortalityRate = MortalityRate() // 0..1
		self.properties.append(self.mortalityRate)
		self.health = Health()
		self.properties.append(self.health)
		self.lifeSpan = LifeSpan()
		self.properties.append(self.lifeSpan)

		self.religiosity = Religiosity()
		self.properties.append(self.religiosity)
		self.happiness = Happiness()
		self.properties.append(self.happiness)

		self.foodSecurity = FoodSecurity()
		self.properties.append(self.foodSecurity)

		self.grossDomesticProduct = GrossDomesticProduct()
		self.properties.append(self.grossDomesticProduct)

		// policies
		self.primarySchools = PrimarySchools()
		self.policies.append(self.primarySchools)

		self.sewage = Sewage()
		self.policies.append(self.sewage)

		// events
		self.earthQuake = Earthquake()
		self.events.append(self.earthQuake)

		// population impacts
		self.population.add(property: self.population, formula: "x") // keep self value
		self.population.add(property: self.birthRate, formula: "0.02*x*v")
		self.population.add(property: self.mortalityRate, formula: "-0.02*x*v")

		// birth rate impacts
		self.birthRate.add(property: self.religiosity, formula: "0.7*x") // the more religious, the higher the birth rate
		self.birthRate.add(property: self.health, formula: "(x-0.5)^0.7") // good health increases the birth rate
		self.birthRate.add(property: self.lifeSpan, formula: "(x-0.5)^0.7") // lifespan reduces the birth rate (the older the people, the lower the relative timeframe when women can get pregnant

		// mortality rate impacts
		self.mortalityRate.add(property: StaticProperty(value: 0.5)) // keep self value
		self.mortalityRate.add(property: self.health, formula: "-0.3*x")
		self.mortalityRate.add(property: self.foodSecurity, formula: "0.5*x") // foodsecurity reduces mortality

		// foodSecurity impacts
		self.foodSecurity.add(property: StaticProperty(value: 0.4)) // keep self value
		// different sources of food, stable surplus

		// lifespan
		self.lifeSpan.add(property: StaticProperty(value: 0.4)) // keep self value
		self.lifeSpan.add(property: self.health, formula: "0.2*x") // health increases lifespan
		self.lifeSpan.add(property: self.grossDomesticProduct, formula: "0.2*(7.02*ln(x*60000)+6.9)*0.01") // more gdp, more life span - https://en.wikipedia.org/wiki/Life_expectancy#/media/File:LifeExpectancy_GDPperCapita.png

		// health impacts
		self.health.add(property: StaticProperty(value: 0.7)) // keep self value
		self.health.add(property: self.lifeSpan, formula: "0.2*ln(x)") // lifespan decreases health

		// rest
		self.religiosity.add(property: StaticProperty(value: 0.8)) // TODO: remove
		self.happiness.add(property: StaticProperty(value: 0.8)) // TODO: remove
		self.grossDomesticProduct.add(property: StaticProperty(value: 0.001)) // TODO: remove

		self.earthQuake.add(property: RandomProperty(minimum: 0.01, maximum: 0.03)) //
	}

	func iterate() {
		DispatchQueue.global(qos: .userInitiated).async {
			// perform expensive task
			self.doIterate()

			DispatchQueue.main.async {
				// Update the UI
				self.delegate?.iterationComplete()
			}
		}
	}

	private func doIterate() {

		// first we need to do the calculation
		for property in self.properties {
			property.calculate()
		}

		for policy in self.policies {
			policy.calculate()
		}

		for event in self.events {
			event.calculate()
		}

		// find event
		let maxScore = self.events.max(by: { $0.value() < $1.value() })?.value() ?? 0
		let allEventsWithMaxScore = self.events.filter { $0.value() == maxScore }
		print("Best score: \(maxScore) => \(allEventsWithMaxScore.count) items")

		if !allEventsWithMaxScore.isEmpty {

			let eventThatTriggered = allEventsWithMaxScore.randomItem()
			self.grudges.append(contentsOf: eventThatTriggered.grudges(for: self))

			DispatchQueue.main.async {
				// Update the UI
				self.delegate?.simulationTriggered(by: eventThatTriggered)
			}
		}

		for grudge in self.grudges {
			grudge.calculate()
		}

		// then we need to push the value
		for property in self.properties {
			property.push()
		}

		for policy in self.policies {
			policy.push()
		}

		for event in self.events {
			event.push()
		}

		for grudge in self.grudges {
			grudge.push()
		}
	}
}
