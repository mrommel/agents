//
//  Groups.swift
//  agents
//
//  Created by Michael Rommel on 24.10.18.
//  Copyright © 2018 Michael Rommel. All rights reserved.
//

import Foundation

class Groups {

	var all: All
	var conservatives: Conservatives
	var poor: Poor
	var religious: Religious

	fileprivate var groups: [Group] = []

	init() {

		self.all = All()
		self.conservatives = Conservatives()
		self.poor = Poor()
		self.religious = Religious()
	}

	func setup(with global: GlobalSimulation) {

		self.all.setup(with: global)
		self.conservatives.setup(with: global)
		self.poor.setup(with: global)
		self.religious.setup(with: global)
	}

	func add(group: Group) {

		self.groups.append(group)
	}

	func calculate() {

		self.groups.forEach { $0.calculate() }
	}

	func push() {

		self.groups.forEach { $0.push() }
	}
}
