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

class PropertyTableViewCell: UITableViewCell {

	@IBOutlet var titleLabel: UILabel!
	@IBOutlet var valueLabel: UILabel!
}

class PolicyTableViewCell: UITableViewCell {

	@IBOutlet var titleLabel: UILabel!
	@IBOutlet var valueField: UITextField!
}

class SimulationViewController: UITableViewController {

	var policyPickerView: UIPickerView!
	var policyTextField: UITextField!

	let simulation: Simulation = Simulation()

	var menuItems: [MenuPropertyItem] = []
	var policyItems: [MenuPropertyItem] = []
	var iteration = 0

	override func viewDidLoad() {
		self.title = "Simulation"

		self.simulation.delegate = self

		self.menuItems.append(MenuPropertyItem(property: simulation.population))
		self.menuItems.append(MenuPropertyItem(property: simulation.happiness))
		self.menuItems.append(MenuPropertyItem(property: simulation.religiosity))
		self.menuItems.append(MenuPropertyItem(property: simulation.birthRate))
		self.menuItems.append(MenuPropertyItem(property: simulation.mortalityRate))
		self.menuItems.append(MenuPropertyItem(property: simulation.health))
		self.menuItems.append(MenuPropertyItem(property: simulation.foodSecurity))
		self.menuItems.append(MenuPropertyItem(property: simulation.lifeSpan))
		self.menuItems.append(MenuPropertyItem(property: simulation.grossDomesticProduct))

		self.policyItems.append(MenuPropertyItem(property: simulation.policy))
	}

	override func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
		return nil
	}
}

extension SimulationViewController {

	override func numberOfSections(in tableView: UITableView) -> Int {
		return 3
	}

	override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

		switch section {
		case 0:
			return 1
		case 1:
			return menuItems.count
		default:
			return policyItems.count
		}
	}
}

extension Double {
	func format(with format: String) -> String {
		return String(format: "%\(format)f", self)
	}
}

// MARK: UITableViewDelegate

extension SimulationViewController {

	override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

		switch indexPath.section {
		case 0:
			let cell = tableView.dequeueReusableCell(withIdentifier: "PropertyTableViewCell", for: indexPath) as! PropertyTableViewCell
			cell.textLabel?.text = "Iterate"
			cell.valueLabel?.text = "\(self.iteration)"
			return cell
		case 1:
			let menuItem = self.menuItems[indexPath.row]
			if let property = menuItem.property {
				let cell = tableView.dequeueReusableCell(withIdentifier: "PropertyTableViewCell", for: indexPath) as! PropertyTableViewCell
				cell.textLabel?.text = "\(property.name)"
				cell.valueLabel?.text = property.valueText()
				return cell
			}
		default:
			let menuItem = self.policyItems[indexPath.row]
			if let property = menuItem.property {
				let cell = tableView.dequeueReusableCell(withIdentifier: "PolicyTableViewCell", for: indexPath) as! PolicyTableViewCell
				cell.textLabel?.text = "\(property.name)"
				cell.valueField?.text = property.valueText()
				cell.valueField.delegate = self
				return cell
			}
		}

		return tableView.dequeueReusableCell(withIdentifier: "PropertyTableViewCell", for: indexPath) as! PropertyTableViewCell
	}

	override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

		switch indexPath.section {
		case 0:
			self.simulation.iterate()
			self.iteration += 1
			break
		case 1:
			break
		default:
			//setupPicker(for: )
			break
		}
	}

	func setupPicker(for textField: UITextField) {

		// UIPickerView
		let myPickerView = UIPickerView(frame:CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: 216))
		myPickerView.delegate = self
		myPickerView.dataSource = self
		myPickerView.backgroundColor = UIColor.white
		textField.inputView = myPickerView

		// ToolBar
		let toolBar = UIToolbar()
		toolBar.barStyle = .default
		toolBar.isTranslucent = true
		toolBar.tintColor = UIColor(red: 92/255, green: 216/255, blue: 255/255, alpha: 1)
		toolBar.sizeToFit()

		// Adding Button ToolBar
		let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(SimulationViewController.doneClick))
		doneButton.tag = 
		let spaceButton = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
		let cancelButton = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(SimulationViewController.cancelClick))
		toolBar.setItems([cancelButton, spaceButton, doneButton], animated: false)
		toolBar.isUserInteractionEnabled = true
		textField.inputAccessoryView = toolBar
	}

	@objc func doneClick() {
		//txt_pickUpData.resignFirstResponder()
	}
	@objc func cancelClick() {
		//txt_pickUpData.resignFirstResponder()
	}
}

// MARK: TextFieldDelegate

extension SimulationViewController: UITextFieldDelegate {

	func textFieldDidBeginEditing(_ textField: UITextField) {
		self.setupPicker(for: textField)
	}
}

// MARK: SimulationDelegate

extension SimulationViewController: SimulationDelegate {

	func iterationComplete() {
		self.tableView.reloadData()
	}
}

// MARK: UIPickerViewDelegate

extension SimulationViewController: UIPickerViewDelegate {

	func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
		return ["abc", "def"][row]
	}
}

// MARK: UIPickerViewDataSource

extension SimulationViewController: UIPickerViewDataSource {

	// The number of columns of data
	func numberOfComponents(in pickerView: UIPickerView) -> Int {
		return 1
	}

	// The number of rows of data
	func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
		return 2
	}
}
