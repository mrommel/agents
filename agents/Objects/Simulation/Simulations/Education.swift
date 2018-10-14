//
//  Education.swift
//  agents
//
//  Created by Michael Rommel on 13.10.18.
//  Copyright © 2018 Michael Rommel. All rights reserved.
//

import Foundation

class Education: Property {

	init() {

		super.init(name: "Education",
				   summary: "A measurement of the education level of the average citizen. Not only literacy, but numeracy and general understanding of everything from history to IT and science.",
				   category: .publicServices,
				   value: 0.18)

		// effects: WorkerProductivity,-0.2+(x*0.4)	RacialTension,0-(0.08*x)	CrimeRate,-0.12*(x^6)	ViolentCrimeRate,-0.12*(x^4)
	}
}
