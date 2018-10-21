//
//  Group.swift
//  agents
//
//  Created by Michael Rommel on 14.10.18.
//  Copyright © 2018 Michael Rommel. All rights reserved.
//

import Foundation

class Group {

	var name: String
	var summary: String

	var mood: Simulation
	var frequency: Simulation

	init(name: String, summary: String, moodValue: Double, frequencyValue: Double) {

		self.name = name
		self.summary = summary

		self.mood = Simulation(name: "\(self.name) mood", summary: "", category: .groups, value: moodValue)
		self.frequency = Simulation(name: "\(self.name) freq", summary: "", category: .groups, value: frequencyValue)
	}

	func calculate() {

		self.mood.calculate()
		self.frequency.calculate()
	}

	func push() {

		self.mood.push()
		self.frequency.push()
	}

	func setup(with simulation: GlobalSimulation) {
		assertionFailure("Subclasses need to implement this method")
	}
}
