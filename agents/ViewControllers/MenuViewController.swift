//
//  MenuViewController.swift
//  agents
//
//  Created by Michael Rommel on 18.01.18.
//  Copyright © 2018 Michael Rommel. All rights reserved.
//

import UIKit

class MenuViewController: UITableViewController {
	
	let menuItems = ["Game", "Options"]
}

extension MenuViewController {
	
	override func numberOfSections(in tableView: UITableView) -> Int {
		return 1
	}
	
	override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return menuItems.count
	}
	
	override func tableView(_ tableView: UITableView,
							cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		
		// Mit dequeueReusableCell werden Zellen gemäß der im Storyboard definierten Prototypen erzeugt
		let cell = tableView.dequeueReusableCell(withIdentifier: "TextCell", for: indexPath)
		
		// Dafür wird der Abschnitts- und Zeilenindex in einem IndexPath-Objekt übergeben
		let menuItem = menuItems[indexPath.row]
		
		// Zelle konfigurieren
		cell.textLabel?.text = "\(menuItem)"
		
		return cell
	}
	
	override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		self.performSegue(withIdentifier: "goToGame", sender: self)
	}
}
