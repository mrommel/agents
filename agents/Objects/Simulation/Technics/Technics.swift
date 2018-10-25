//
//  Technics.swift
//  agents
//
//  Created by Michael Rommel on 21.10.18.
//  Copyright © 2018 Michael Rommel. All rights reserved.
//

import Foundation

// http://civilization.wikia.com/wiki/List_of_technologies_in_Civ5
class Technics {

	// era: ancient
	var agriculture: Agriculture
	var animalHusbandry: AnimalHusbandry
	var archery: Archery
	var bronzeWorking: BronzeWorking
	var calendar: Calendar
	var masonry: Masonry
	var mining: Mining
	var pottery: Pottery
	var sailing: Sailing
	var wheel: Wheel
	var trapping: Trapping
	var writing: Writing

	fileprivate var techs: [Technic] = []

	init() {

		// era: ancient
		self.agriculture = Agriculture()
		self.animalHusbandry = AnimalHusbandry()
		self.archery = Archery()
		self.bronzeWorking = BronzeWorking()
		self.calendar = Calendar()
		self.masonry = Masonry()
		self.mining = Mining()
		self.pottery = Pottery()
		self.sailing = Sailing()
		self.wheel = Wheel()
		self.trapping = Trapping()
		self.writing = Writing()
	}

	func setup(with global: GlobalSimulation) {

		// era: ancient
		self.agriculture.setup(with: global)
		self.animalHusbandry.setup(with: global)
		self.archery.setup(with: global)
		self.bronzeWorking.setup(with: global)
		self.calendar.setup(with: global)
		self.masonry.setup(with: global)
		self.mining.setup(with: global)
		self.pottery.setup(with: global)
		self.sailing.setup(with: global)
		self.wheel.setup(with: global)
		self.trapping.setup(with: global)
		self.writing.setup(with: global)
	}

	func add(technic: Technic) {

		self.techs.append(technic)
	}

	func numberOfInvented() -> Int {

		return self.techs.filter { $0.invented }.count
	}

	func evaluate() {

		self.techs.forEach { $0.evaluate() }
	}
}
