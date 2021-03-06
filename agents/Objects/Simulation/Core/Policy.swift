//
//  Policy.swift
//  agents
//
//  Created by Michael Rommel on 01.10.18.
//  Copyright © 2018 Michael Rommel. All rights reserved.
//

import Foundation

class PolicySelection {

	let name: String
	let description: String
	let value: Double
	var enabled: Bool

	init(name: String, description: String, value: Double, enabled: Bool = false) {
		self.name = name
		self.description = description
		self.value = value
		self.enabled = enabled
	}
}

/// a Policy is a Property that can be modified by he user
class Policy: Simulation {

	let selections: [PolicySelection]
	var selectionIndex: Int

	init(name: String, summary: String, category: Category, selections: [PolicySelection], initialSelection: PolicySelection) {

		self.selections = selections

		// can't use self.selection = initialSelection as we did not call the constructor yet
		guard let selectedIndex = selections.firstIndex(where: { $0 === initialSelection }) else {
			assert(false, "Could not find \(initialSelection.name) in the list of possible policy selections")
		}

		self.selectionIndex = selectedIndex

		super.init(name: name, summary: summary, category: category, value: initialSelection.value)
	}

	override func add(simulation: Simulation, formula: String = "x", delay: Int = 0) {
		assert(false, "Policies can't have external impact")
	}

	override func add(simulationRelation: SimulationRelation) {
		assert(false, "Policies can't have external impact")
	}

	/// we need to override the Property behavior
	/// the new value is defined by the user selection
	override func calculate() {

		self.stashedValue = self.selection.value
	}

	var selection: PolicySelection {
		set {
			guard let selectedIndex = selections.firstIndex(where: { $0 === newValue }) else {
				assert(false, "Could not find \(newValue.name) in the list of possible policy selections")
			}

			self.selectionIndex = selectedIndex
		}
		get {
			return self.selections[self.selectionIndex]

		}
	}

	/// change selection
	///
	/// - Parameter index: new selected index
	func select(at index: Int) {
		self.selectionIndex = index
	}

	override func setup(with global: GlobalSimulation) {

		global.policies.add(policy: self)
	}
}
