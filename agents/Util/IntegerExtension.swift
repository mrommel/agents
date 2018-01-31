//
//  IntegerExtension.swift
//  agents
//
//  Created by Michael Rommel on 25.01.18.
//  Copyright © 2018 Michael Rommel. All rights reserved.
//

import Foundation

extension Int {
	
	public func sign() -> Int {
		return (self < 0 ? -1 : 1)
	}
	/* or, use signature: func sign() -> Self */
}
