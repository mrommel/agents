//
//  SimulationViewController.swift
//  agents
//
//  Created by Michael Rommel on 03.09.18.
//  Copyright © 2018 Michael Rommel. All rights reserved.
//

import UIKit
import Rswift

class SimulationViewController: UITableViewController {

	var policyPickerView: UIPickerView!
	var policyTextField: UITextField!
	var pickerView: UIPickerView?

	var viewModel: SimulationViewModel?

	override func viewDidLoad() {

		self.viewModel = SimulationViewModel()
		self.viewModel?.simulation.delegate = self

		self.title = self.viewModel?.screenTitle
	}

	override func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
		return nil
	}
}

// MARK: SimulationDelegate

extension SimulationViewController: SimulationDelegate {

	func iterationComplete() {
		self.tableView.reloadData()
	}

	func simulationTriggered(by event: Event?) {

		let alert = UIAlertController(title: R.string.localizable.simulationEvent(),
									  message: event?.summary,
									  preferredStyle: UIAlertController.Style.alert)

		alert.addAction(UIAlertAction(title: R.string.localizable.generalOkay(),
									  style: .default,
									  handler: { _ in
			// handle user clicked
		}))
		self.present(alert, animated: true, completion: nil)
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
			return self.viewModel?.menuItems.count ?? 0
		default:
			return self.viewModel?.policyItems.count ?? 0
		}
	}
}

// MARK: UITableViewDelegate

extension SimulationViewController {

	override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

		switch indexPath.section {
		case 0:
			if let cell = tableView.dequeueReusableCell(withIdentifier: PropertyTableViewCell.identifier, for: indexPath) as? PropertyTableViewCell {
				cell.textLabel?.text = R.string.localizable.simulationIterate()
				cell.valueLabel?.text = "\(self.viewModel?.iteration ?? 0)"
				return cell
			}
		case 1:
			let menuItem = self.viewModel?.menuItems[indexPath.row]
			if let property = menuItem?.property {
				if let cell = tableView.dequeueReusableCell(withIdentifier: PropertyTableViewCell.identifier, for: indexPath) as? PropertyTableViewCell {
					cell.textLabel?.text = "\(property.name)"
					cell.valueLabel?.text = property.valueText()
					return cell
				}
			}
		default:
			let menuItem = self.viewModel?.policyItems[indexPath.row]
			if let policy = menuItem?.policy {
				if let cell = tableView.dequeueReusableCell(withIdentifier: PolicyTableViewCell.identifier, for: indexPath) as? PolicyTableViewCell {
					cell.textLabel?.text = "\(policy.name)"
					cell.valueField?.text = policy.selection.name
					cell.valueField.tag = indexPath.row
					cell.valueField.delegate = self
					return cell
				}
			}
		}

		return tableView.dequeueReusableCell(withIdentifier: PropertyTableViewCell.identifier, for: indexPath) as! PropertyTableViewCell
	}

	override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

		switch indexPath.section {
		case 0:
			self.viewModel?.iterateSimulation()
		case 1:
			// todo
			break
		default:
			if let cell = tableView.cellForRow(at: indexPath) as? PolicyTableViewCell {
				setupPicker(for: cell.valueField)
			}
		}
	}

	func setupPicker(for textField: UITextField?) {

		self.viewModel?.selectedPolicy = self.viewModel?.policyItems[textField?.tag ?? 0]

		// UIPickerView
		self.pickerView = UIPickerView(frame:CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: 216))
		self.pickerView?.delegate = self
		self.pickerView?.dataSource = self
		self.pickerView?.backgroundColor = UIColor.white
		if let policy = self.viewModel?.selectedPolicy?.policy {
			self.pickerView?.selectRow(policy.selectionIndex, inComponent: 0, animated: true) // pre-select
		}
		textField?.inputView = self.pickerView

		// ToolBar
		let toolBar = UIToolbar()
		toolBar.barStyle = .default
		toolBar.isTranslucent = true
		toolBar.tintColor = UIColor(red: 92/255, green: 216/255, blue: 255/255, alpha: 1)
		toolBar.sizeToFit()

		// Adding Button ToolBar
		let doneButton = UIBarButtonItem(title: R.string.localizable.pickerDone(), style: .plain, target: self, action: #selector(SimulationViewController.doneClick(sender:)))
		doneButton.tag = textField?.tag ?? 0
		let spaceButton = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
		let cancelButton = UIBarButtonItem(title: R.string.localizable.pickerCancel(), style: .plain, target: self, action: #selector(SimulationViewController.cancelClick(sender:)))
		cancelButton.tag = textField?.tag ?? 0
		toolBar.setItems([cancelButton, spaceButton, doneButton], animated: false)
		toolBar.isUserInteractionEnabled = true
		textField?.inputAccessoryView = toolBar
	}

	@objc func doneClick(sender: UIBarButtonItem) {

		let selectedRow = self.pickerView?.selectedRow(inComponent: 0) ?? 0
		if let policy = self.viewModel?.selectedPolicy?.policy {
			let newValue = policy.selections[selectedRow].name

			policy.select(at: selectedRow)

			if let cell = tableView.cellForRow(at: IndexPath(row: sender.tag, section: 2)) as? PolicyTableViewCell {
				cell.valueField.text = newValue
				cell.valueField.resignFirstResponder()
			}
		}
	}

	@objc func cancelClick(sender: UIBarButtonItem) {
		if let cell = tableView.cellForRow(at: IndexPath(row: sender.tag, section: 2)) as? PolicyTableViewCell {
			cell.valueField.resignFirstResponder()
		}
	}
}

// MARK: TextFieldDelegate

extension SimulationViewController: UITextFieldDelegate {

	func textFieldDidBeginEditing(_ textField: UITextField) {
		self.setupPicker(for: textField)
	}
}

// MARK: UIPickerViewDelegate

extension SimulationViewController: UIPickerViewDelegate {

	func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {

		return self.viewModel?.selectedPolicySelectionName(at: row)
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

		if let policy = self.viewModel?.selectedPolicy?.policy {
			return policy.selections.count
		}

		return 1
	}
}
