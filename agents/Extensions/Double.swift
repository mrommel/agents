//
//  Double.swift
//  agents
//
//  Created by Michael Rommel on 27.09.18.
//  Copyright © 2018 Michael Rommel. All rights reserved.
//

import Foundation

extension Double {

	func between(from: Double, to: Double) -> Bool {
		return from <= self && self <= to
	}
}

extension Double {
	func format(with format: String) -> String {
		return String(format: "%\(format)f", self)
	}
}
