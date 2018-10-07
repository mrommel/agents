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

		self.menuItems.append(MenuPropertyItem(property: simulation.population))
		self.menuItems.append(MenuPropertyItem(property: simulation.happiness))
		self.menuItems.append(MenuPropertyItem(property: simulation.religiosity))
		self.menuItems.append(MenuPropertyItem(property: simulation.birthRate))
		self.menuItems.append(MenuPropertyItem(property: simulation.mortalityRate))
		self.menuItems.append(MenuPropertyItem(property: simulation.health))
		self.menuItems.append(MenuPropertyItem(property: simulation.foodSecurity))
		self.menuItems.append(MenuPropertyItem(property: simulation.lifeSpan))
		self.menuItems.append(MenuPropertyItem(property: simulation.grossDomesticProduct))

		self.policyItems.append(MenuPolicyItem(policy: simulation.policy0))
		self.policyItems.append(MenuPolicyItem(policy: simulation.policy1))
		self.policyItems.append(MenuPolicyItem(policy: simulation.policy2))
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
