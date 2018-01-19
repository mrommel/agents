//
//  MenuViewController.swift
//  agents
//
//  Created by Michael Rommel on 18.01.18.
//  Copyright © 2018 Michael Rommel. All rights reserved.
//

import UIKit

struct MenuItem {
	let title: String
	let segue: String
}

class MenuViewController: UITableViewController {
	
	let menuItems: [MenuItem] = [
		MenuItem(title: "Game", segue: "goToGame"),
		MenuItem(title: "Options", segue: "goToOptions")
	]
}

// MARK: UITableViewDataSource

extension MenuViewController {
	
	override func numberOfSections(in tableView: UITableView) -> Int {
		return 1
	}
	
	override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return menuItems.count
	}
}

// MARK: UITableViewDelegate

extension MenuViewController {
	
	override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		
		let cell = tableView.dequeueReusableCell(withIdentifier: "TextCell", for: indexPath)
		let menuItem = menuItems[indexPath.row]
		cell.textLabel?.text = "\(menuItem.title)"
		
		return cell
	}
	
	override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		let menuItem = menuItems[indexPath.row]
		self.performSegue(withIdentifier: menuItem.segue, sender: self)
	}
}
