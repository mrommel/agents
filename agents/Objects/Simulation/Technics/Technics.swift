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

	func setup(with simulation: GlobalSimulation) {

		self.agriculture.setup(with: simulation)
		self.animalHusbandry.setup(with: simulation)
		self.archery.setup(with: simulation)
		self.bronzeWorking.setup(with: simulation)
		self.calendar.setup(with: simulation)
		self.masonry.setup(with: simulation)
		self.mining.setup(with: simulation)
		self.pottery.setup(with: simulation)
		self.sailing.setup(with: simulation)
		self.wheel.setup(with: simulation)
		self.trapping.setup(with: simulation)
	}
}
