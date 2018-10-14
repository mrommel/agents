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

	var mood: Property
	var frequency: Property

	init(name: String, summary: String, moodValue: Double, frequencyValue: Double) {

		self.name = name
		self.summary = summary

		self.mood = Property(name: "\(self.name) mood", summary: "", category: .groups, value: moodValue)
		self.frequency = Property(name: "\(self.name) freq", summary: "", category: .groups, value: frequencyValue)
	}

	func calculate() {

		self.mood.calculate()
		self.frequency.calculate()
	}

	func push() {

		self.mood.push()
		self.frequency.push()
	}
}
