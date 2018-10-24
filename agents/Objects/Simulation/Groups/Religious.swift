//
//  Religious.swift
//  agents
//
//  Created by Michael Rommel on 19.10.18.
//  Copyright © 2018 Michael Rommel. All rights reserved.
//

import Foundation

class Religious: Group {

	init() {

		super.init(name: "Religious",
				   summary: "Although there is a wide range of different religions, most of the larger organized groups can agree on a few basic principles. Religious voters support religious teaching in schools, specialized 'faith' schools, and are also pro marriage. Religious groups may also be concerned by abortion and organ donation, and are unlikely to be pro-science.",
				   moodValue: 0.0,
				   frequencyValue: 0.2)
	}

	override func setup(with global: GlobalSimulation) {

		global.groups.add(group: self)
	}
}
