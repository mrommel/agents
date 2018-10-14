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
	var foodPrice: FoodPrice

	var grossDomesticProduct: GrossDomesticProduct

	var crimeRate: CrimeRate
	var povertyRate: Poverty
	var unemployment: Unemployment
	var education: Education

	var properties: [Property] = []

	// Policies
	var primarySchools: PrimarySchools
	var sewage: Sewage

	var policies: [Policy] = []

	// Events

	var earthQuakeEvent: Earthquake
	var monumentVandalizedEvent: MonumentVandalized

	var events: [Event] = []

	// Groups

	var conservatives: Conservatives

	var groups: [Group] = []

	// Effects

	var effects: [Effect] = []

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

		self.foodPrice = FoodPrice()
		self.properties.append(self.foodPrice)

		self.grossDomesticProduct = GrossDomesticProduct()
		self.properties.append(self.grossDomesticProduct)

		self.crimeRate = CrimeRate()
		self.properties.append(self.crimeRate)

		self.povertyRate = Poverty()
		self.properties.append(self.povertyRate)

		self.unemployment = Unemployment()
		self.properties.append(self.unemployment)

		self.education = Education()
		self.properties.append(self.education)

		// policies
		self.primarySchools = PrimarySchools()
		self.policies.append(self.primarySchools)

		self.sewage = Sewage()
		self.policies.append(self.sewage)

		// events
		self.earthQuakeEvent = Earthquake()
		self.events.append(self.earthQuakeEvent)

		self.monumentVandalizedEvent = MonumentVandalized()
		self.events.append(self.monumentVandalizedEvent)

		// groups
		self.conservatives = Conservatives()
		self.groups.append(self.conservatives)

		// setup impacts
		self.population.setup(with: self)

		self.grossDomesticProduct.setup(with: self)

		self.unemployment.setup(with: self)
		self.education.setup(with: self)

		// birth rate impacts
		self.birthRate.add(property: self.religiosity, formula: "0.7*x") // the more religious, the higher the birth rate
		self.birthRate.add(property: self.health, formula: "(x-0.5)^0.7") // good health increases the birth rate
		self.birthRate.add(property: self.lifeSpan, formula: "(x-0.5)^0.7") // lifespan reduces the birth rate (the older the people, the lower the relative timeframe when women can get pregnant

		// mortality rate impacts
		self.mortalityRate.add(property: StaticProperty(value: 0.5)) // keep self value
		self.mortalityRate.add(property: self.health, formula: "-0.3*x")
		self.mortalityRate.add(property: self.foodPrice, formula: "0.5*x") // foodsecurity reduces mortality

		// foodSecurity impacts
		self.foodPrice.add(property: StaticProperty(value: 0.2)) // keep self value
		// different sources of food, stable surplus

		// lifespan
		self.lifeSpan.add(property: StaticProperty(value: 0.4)) // keep self value
		self.lifeSpan.add(property: self.health, formula: "0.2*x") // health increases lifespan
		self.lifeSpan.add(property: self.grossDomesticProduct, formula: "0.2*(7.02*ln(x*60000)+6.9)*0.01") // more gdp, more life span - https://en.wikipedia.org/wiki/Life_expectancy#/media/File:LifeExpectancy_GDPperCapita.png

		// health impacts
		self.health.add(property: StaticProperty(value: 0.7)) // keep self value
		self.health.add(property: self.lifeSpan, formula: "0.2*ln(x)") // lifespan decreases health

		// crime rate
		self.crimeRate.setup(with: self)

		// rest
		self.religiosity.add(property: StaticProperty(value: 0.8)) // TODO: remove
		self.happiness.add(property: StaticProperty(value: 0.8)) // TODO: remove

		self.earthQuakeEvent.add(property: RandomProperty(minimum: 0.01, maximum: 0.03)) //
		self.monumentVandalizedEvent.add(property: self.crimeRate)
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

		for group in self.groups {
			group.calculate()
		}

		// find event
		let maxScore = self.events.max(by: { $0.value() < $1.value() })?.value() ?? 0
		let allEventsWithMaxScore = self.events.filter { $0.value() == maxScore }
		print("Best score: \(maxScore) => \(allEventsWithMaxScore.count) items")

		if !allEventsWithMaxScore.isEmpty {

			let eventThatTriggered = allEventsWithMaxScore.randomItem()
			self.effects.append(contentsOf: eventThatTriggered.effects(for: self))

			DispatchQueue.main.async {
				// Update the UI
				self.delegate?.simulationTriggered(by: eventThatTriggered)
			}
		}

		for effect in self.effects {
			effect.calculate()
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

		for group in self.groups {
			group.push()
		}

		for effect in self.effects {
			effect.push()
		}

		// filter grudges that are too small
		print("- before filtering \(self.effects) effects")
		self.effects = self.effects.filter { abs($0.value()) > 0.01 }
		print("- after filtering \(self.effects) effects")
	}
}
