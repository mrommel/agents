//
//  SimulationViewController.swift
//  agents
//
//  Created by Michael Rommel on 03.09.18.
//  Copyright © 2018 Michael Rommel. All rights reserved.
//

import UIKit

struct MenuPropertyItem {
	let property: Property?
}

class SimulationViewController: UITableViewController {

	let simulation: Simulation = Simulation()

	var menuItems: [MenuPropertyItem] = []

	override func viewDidLoad() {
		self.title = "Simulation"

		self.simulation.delegate = self

		self.menuItems.append(MenuPropertyItem(property: simulation.population))
		self.menuItems.append(MenuPropertyItem(property: simulation.happiness))
		self.menuItems.append(MenuPropertyItem(property: simulation.religiosity))
		self.menuItems.append(MenuPropertyItem(property: simulation.birthRate))
	}

	override func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
		return nil
	}
}

extension SimulationViewController {

	override func numberOfSections(in tableView: UITableView) -> Int {
		return 2
	}

	override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

		switch section {
		case 0:
			return 1
		default:
			return menuItems.count
		}
	}
}

// MARK: UITableViewDelegate

extension SimulationViewController {

	override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

		let cell = tableView.dequeueReusableCell(withIdentifier: "TextCell", for: indexPath)

		switch indexPath.section {
		case 0:
			cell.textLabel?.text = "Iterate"
		default:
			let menuItem = menuItems[indexPath.row]
			if let property = menuItem.property {
				cell.textLabel?.text = "\(property.name)"
				cell.detailTextLabel?.text = "\(property.value())"
			}
		}

		return cell
	}

	override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

		switch indexPath.section {
		case 0:
			self.simulation.iterate()
		default: break
		}
	}
}

// MARK: SimulationDelegate

extension SimulationViewController: SimulationDelegate {

	func iterationComplete() {
		self.tableView.reloadData()
	}
}
