//
//  OptionViewController.swift
//  agents
//
//  Created by Michael Rommel on 19.01.18.
//  Copyright © 2018 Michael Rommel. All rights reserved.
//

import UIKit

class OptionViewController: UITableViewController {

	let menuItems: [MenuItem] = [
		MenuItem(title: "Dummy", segue: nil),
		MenuItem(title: "Simlation", segue: "goToSimlation")
	]

	override func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
		return nil
	}
}

// MARK: UITableViewDataSource

extension OptionViewController {

	override func numberOfSections(in tableView: UITableView) -> Int {
		return 1
	}

	override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return menuItems.count
	}
}

// MARK: UITableViewDelegate

extension OptionViewController {

	override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

		let cell = tableView.dequeueReusableCell(withIdentifier: "TextCell", for: indexPath)
		let menuItem = menuItems[indexPath.row]
		cell.textLabel?.text = "\(menuItem.title)"

		return cell
	}

	override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		let menuItem = menuItems[indexPath.row]

		if let segue = menuItem.segue {
			self.performSegue(withIdentifier: segue, sender: self)
		}
	}
}
