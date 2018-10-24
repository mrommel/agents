//
//  Homelessness.swift
//  agents
//
//  Created by Michael Rommel on 19.10.18.
//  Copyright © 2018 Michael Rommel. All rights reserved.
//

import Foundation

class Homelessness: Situation {

	init() {

		super.init(name: "Homelessness",
				   summary: "More and more of our citizens are homeless and have taken to sleeping in the streets. This is having knock-on effects in the areas of crime and violent crime, and is also reducing everyone's quality of life. Something needs to be done to provide homes for these people!",
				   startMessage: "We now have a homelessness problem. Many of our cities have people sleeping in the streets, often begging for money.",
				   startTrigger: 0.6,
				   endMessage: "We no longer have a problem with homelessness and people sleeping on our streets. This will cheer up our more liberal citizens, socialists, and of course the poorer members of our society.",
				   endTrigger: 0.4,
				   category: .welfare)

		// outputs:
		// Poor,-0.24-(0.3*x)
		// MiddleIncome,-0.06-(0.05*x)
		// Liberal,-0.09-(0.09*x)
		// CrimeRate,0.04+(0.04*x)
		// Alcoholism,0+(0.2*x)
		// DrugAddiction,0+(0.2*x)
		// Suicide,0+(0.4*x)
	}

	override func setup(with global: GlobalSimulation) {

		self.add(simulation: StaticProperty(value: 0.1))
		self.add(simulation: global.simulations.povertyRate, formula: "0.9*x")
		//StateHousing,0-(0.4*x)
		//PrivateHousing,0-(0.4*x)
		//UnemployedBenefit,0-(0.3*x)
		//Unemployment,0+(0.9*x)
		//MortgageTaxRelief,-0.04-(0.04*x)
		//PropertyTax,0+(0.04*x)
		//Immigration,0+(0.06*x),4

		super.setup(with: global)
	}
}
