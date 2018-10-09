//
//  SimulationViewModel.swift
//  agents
//
//  Created by Michael Rommel on 07.10.18.
//  Copyright © 2018 Michael Rommel. All rights reserved.
//

import UIKit
import Rswift

struct MenuPropertyItem {
	let property: Property?
}

struct MenuPolicyItem {
	let policy: Policy?
}

class PropertyTableViewCell: UITableViewCell {

	static let identifier = "PropertyTableViewCell"

	@IBOutlet var titleLabel: UILabel!
	@IBOutlet var valueLabel: UILabel!
}

class PolicyTableViewCell: UITableViewCell {

	static let identifier = "PolicyTableViewCell"

	@IBOutlet var titleLabel: UILabel!
	@IBOutlet var valueField: UITextField!
}

class SimulationViewModel {

	let screenTitle: String
	let simulation: Simulation = Simulation()

	var menuItems: [MenuPropertyItem] = []
	var policyItems: [MenuPolicyItem] = []
	var selectedPolicy: MenuPolicyItem?

	var iteration = 0

	init() {
		self.screenTitle = R.string.localizable.simulationTitle()

		for property in self.simulation.properties {
			self.menuItems.append(MenuPropertyItem(property: property))
		}

		for policy in self.simulation.policies {
			self.policyItems.append(MenuPolicyItem(policy: policy))
		}
	}

	func iterateSimulation() {
		self.simulation.iterate()
		self.iteration += 1
	}

	func selectedPolicySelectionName(at row: Int) -> String {

		if let policy = self.selectedPolicy?.policy {
			return policy.selections[row].name
		}

		return "???"
	}
}
