//
//  Simulation.swift
//  agents
//
//  Created by Michael Rommel on 04.09.18.
//  Copyright © 2018 Michael Rommel. All rights reserved.
//

import Foundation

protocol GlobalSimulationDelegate: class {
	func iterationComplete()
	func simulationTriggered(by event: Event?)
}

class GlobalSimulation {

	weak var delegate: GlobalSimulationDelegate?

	var simulations: Simulations
	var policies: Policies
	var events: Events
	var groups: Groups
	var situations: Situations
	var technics: Technics

	// Effects

	var effects: [Effect] = []

	init() {

		// init
		self.simulations = Simulations()
		self.policies = Policies()
		self.events = Events()
		self.groups = Groups()
		self.situations = Situations()
		self.technics = Technics()

		// setup
		self.simulations.setup(with: self)
		self.policies.setup(with: self)
		self.events.setup(with: self)
		self.groups.setup(with: self)
		self.situations.setup(with: self)
		self.technics.setup(with: self)
	}

	func iterate() {
		DispatchQueue.global(qos: .userInitiated).async {
			// perform expensive task
			self.doIterate()

			DispatchQueue.main.async {
				// Update the UI
				self.delegate?.iterationComplete()
			}
		}
	}

	private func doIterate() {

		// first we need to do the calculation
		self.technics.evaluate()
		self.simulations.calculate()
		self.policies.calculate()
		self.events.calculate()
		self.groups.calculate()
		self.situations.calculate()
		self.effects.forEach { $0.calculate() }

		// find event
		if let event = self.events.findBestEvent(with: self) {
			DispatchQueue.main.async {
				// Update the UI
				self.delegate?.simulationTriggered(by: event)
			}
		}

		// then we need to push the value
		self.simulations.push()
		self.policies.push()
		self.events.push()
		self.groups.push()
		self.situations.push()
		self.effects.forEach { $0.push() }

		// filter effects that are too small
		//print("- before filtering \(self.effects) effects")
		self.effects = self.effects.filter { abs($0.value()) > 0.01 }
		//print("- after filtering \(self.effects) effects")
	}
}

extension GlobalSimulation: SituationDelegate {

	func start(situation: Situation?) {
		if let situation = situation {
			print("Situation started: \(situation.name)")
		}
	}

	func end(situation: Situation?) {
		if let situation = situation {
			print("Situation ended: \(situation.name)")
		}
	}
}

extension GlobalSimulation: TechnicDelegate {

	func invented(technic: Technic?) {
		if let technic = technic {
			print("Technic invented: \(technic.name) => \(self.technics.numberOfInvented()) techs invented")
		}
	}
}
