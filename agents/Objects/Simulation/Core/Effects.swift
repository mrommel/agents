//
//  Effects.swift
//  agents
//
//  Created by Michael Rommel on 25.10.18.
//  Copyright © 2018 Michael Rommel. All rights reserved.
//

import Foundation

class Effects {

	fileprivate var effects: [Effect]

	init() {

		self.effects = []
	}

	func calculate() {

		self.effects.forEach { $0.calculate() }
	}

	func push() {

		self.effects.forEach { $0.push() }
	}

	func add(effects newEffects: [Effect]) {

		self.effects.append(contentsOf: newEffects)
	}

	func reduce() {

		self.effects = self.effects.filter { abs($0.value()) > 0.01 }
	}
}
