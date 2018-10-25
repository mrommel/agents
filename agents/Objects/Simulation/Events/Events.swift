//
//  Events.swift
//  agents
//
//  Created by Michael Rommel on 24.10.18.
//  Copyright © 2018 Michael Rommel. All rights reserved.
//

import Foundation

class Events {

	var earthQuakeEvent: Earthquake
	var monumentVandalizedEvent: MonumentVandalized
	var ministerialScandal: MinisterialScandal

	fileprivate var events: [Event] = []

	init() {
		self.earthQuakeEvent = Earthquake()
		self.monumentVandalizedEvent = MonumentVandalized()
		self.ministerialScandal = MinisterialScandal()
	}

	func setup(with global: GlobalSimulation) {

		self.earthQuakeEvent.setup(with: global)
		self.monumentVandalizedEvent.setup(with: global)
		self.ministerialScandal.setup(with: global)
	}

	func add(event: Event) {

		self.events.append(event)
	}

	func calculate() {

		self.events.forEach { $0.calculate() }
	}

	func push() {

		self.events.forEach { $0.push() }
	}

	func findBestEvent(with global: GlobalSimulation) -> Event? {

		let maxScore = self.events.max(by: { $0.value() < $1.value() })?.value() ?? 0
		let allEventsWithMaxScore = self.events.filter { $0.value() == maxScore }
		//print("Best score: \(maxScore) => \(allEventsWithMaxScore.count) items")

		if !allEventsWithMaxScore.isEmpty {

			let eventThatTriggered = allEventsWithMaxScore.randomItem()
			let newEffects = eventThatTriggered.effects(for: global)
			newEffects.forEach { $0.calculate() }
			global.effects.add(effects: newEffects)

			return eventThatTriggered
		}

		return nil
	}
}
