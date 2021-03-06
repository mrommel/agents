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
		self.viewModel?.globalSimulation.delegate = self

		self.title = self.viewModel?.screenTitle
	}

	override func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
		return nil
	}
}

// MARK: SimulationDelegate

extension SimulationViewController: GlobalSimulationDelegate {

	func iterationComplete() {
		self.tableView.reloadData()
	}

	func triggered(event: Event?) {

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

	func invented(technic: Technic?) {
		print("Technic invented: \(technic?.name ?? "---")")
	}

	func started(situation: Situation?) {
		print("Situation started: \(situation?.name ?? "---")")
	}

	func ended(situation: Situation?) {
		print("Situation ended: \(situation?.name ?? "---")")
	}
}

extension SimulationViewController {

	override func numberOfSections(in tableView: UITableView) -> Int {
		return 4
	}

	override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

		switch section {
		case 0:
			return 1
		case 1:
			return self.viewModel?.simulationItems.count ?? 0
		case 2:
			return self.viewModel?.policyItems.count ?? 0
		case 3:
			return self.viewModel?.situationItems.count ?? 0
		default:
			return 0
		}
	}
}

// MARK: UITableViewDelegate

extension SimulationViewController {

	override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
		switch(section) {
		case 0: return "Actions"
		case 1: return "Properties"
		case 2: return "Policies"
		case 3: return "Situations"

		default: return ""

		}
	}

	override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

		switch indexPath.section {
		case 0:
			return self.setupIterationButton(for: indexPath)
		case 1:
			return self.setupSimulationCell(for: indexPath)
		case 2:
			return self.setupPolicyCell(for: indexPath)
		case 3:
			return self.setupSituationCell(for: indexPath)
		default:
			break
		}

		fatalError("invalid return")
	}

	func setupIterationButton(for indexPath: IndexPath) -> UITableViewCell {

		if let cell = tableView.dequeueReusableCell(withIdentifier: PropertyTableViewCell.identifier, for: indexPath) as? PropertyTableViewCell {
			cell.textLabel?.text = R.string.localizable.simulationIterate()
			cell.valueLabel?.text = "\(self.viewModel?.iteration ?? 0)"
			return cell
		}

		fatalError("invalid return")
	}

	func setupSimulationCell(for indexPath: IndexPath) -> UITableViewCell {

		if let simulationItem = self.viewModel?.simulationItems[indexPath.row], let simulation = simulationItem.simulation {
			if let cell = tableView.dequeueReusableCell(withIdentifier: PropertyTableViewCell.identifier, for: indexPath) as? PropertyTableViewCell {
				cell.textLabel?.text = "\(simulation.name)"
				cell.valueLabel?.text = simulation.valueText()
				return cell
			}
		}

		fatalError("invalid return")
	}

	func setupPolicyCell(for indexPath: IndexPath) -> UITableViewCell {

		if let policyItem = self.viewModel?.policyItems[indexPath.row], let policy = policyItem.policy {
			if let cell = tableView.dequeueReusableCell(withIdentifier: PolicyTableViewCell.identifier, for: indexPath) as? PolicyTableViewCell {
				cell.setup(with: policy, at: indexPath.row, delegate: self)
				return cell
			}
		}

		fatalError("invalid return")
	}

	func setupSituationCell(for indexPath: IndexPath) -> UITableViewCell {

		if let situationItem = self.viewModel?.situationItems[indexPath.row], let situation = situationItem.situation {
			if let cell = tableView.dequeueReusableCell(withIdentifier: SituationTableViewCell.identifier, for: indexPath) as? SituationTableViewCell {
				cell.textLabel?.text = "\(situation.name)"
				cell.valueLabel?.text = situation.valueText()
				return cell
			}
		}

		fatalError("invalid return")
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
