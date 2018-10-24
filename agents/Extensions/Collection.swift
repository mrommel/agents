//
//  Collection.swift
//  agents
//
//  Created by Michael Rommel on 24.10.18.
//  Copyright © 2018 Michael Rommel. All rights reserved.
//

import Foundation

extension Collection {

	/// Returns the element at the specified index iff it is within bounds, otherwise nil.
	subscript (safe index: Index) -> Element? {
		return indices.contains(index) ? self[index] : nil
	}
}
