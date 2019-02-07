//
//  Simulation.swift
//  agents
//
//  Created by Michael Rommel on 04.09.18.
//  Copyright © 2018 Michael Rommel. All rights reserved.
//

import Foundation

enum TerrainInfo: CaseIterable {

    case ocean
    case shore
    case plain
    case grassland
    case desert
    case swamp
    case tundra
}

enum FeatureInfo: CaseIterable {

    case forest
    case rainforest
    case hill
    case mountain
    case isle
}

enum ResourceInfo: CaseIterable {

    case coal
    case ironore
    case copperore
}

class TileInfo {

    let terrain: TerrainInfo
    let features: [FeatureInfo]
    let resource: ResourceInfo?

    init(terrain: TerrainInfo, features: [FeatureInfo]) {
        self.terrain = terrain
        self.features = features
        self.resource = Double.random(minimum: 0.0, maximum: 1.0) < 0.1 ? ResourceInfo.allCases.randomItem() : nil
    }

    var mineralsPropability: Double {

        var value = 0.0

        if self.terrain == .desert {
            value = 0.1
        }

        if self.resource != nil {
            value += 0.2
        }

        return value
    }

    var animalsPropability: Double {

        var value = 0.0

        if self.terrain == .desert {
            value = 0.1
        }

        if self.features.contains(.hill) || self.features.contains(.rainforest) {
            value += 0.1
        }

        if self.features.contains(.forest) {
            value += 0.2
        }

        return value
    }
}

protocol GlobalSimulationDelegate: class {

    func iterationComplete()

    func triggered(event: Event?)
    func invented(technic: Technic?)
    func started(situation: Situation?)
    func ended(situation: Situation?)
}

class GlobalSimulation {

    let tileInfo: TileInfo

    var simulations: Simulations
    var policies: Policies
    var events: Events
    var groups: Groups
    var situations: Situations
    var technics: Technics
    var effects: Effects

    weak var delegate: GlobalSimulationDelegate?

    init(tileInfo: TileInfo) {

        self.tileInfo = tileInfo

        // init
        self.simulations = Simulations()
        self.policies = Policies()
        self.events = Events()
        self.groups = Groups()
        self.situations = Situations()
        self.technics = Technics()
        self.effects = Effects()

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
        self.effects.calculate()

        // find event
        if let event = self.events.findBestEvent(with: self) {
            DispatchQueue.main.async {
                // Inform the UI
                self.delegate?.triggered(event: event)
            }
        }

        // then we need to push the value
        self.simulations.push()
        self.policies.push()
        self.events.push()
        self.groups.push()
        self.situations.push()
        self.effects.push()

        // filter effects that are too small
        self.effects.reduce()
    }
}

extension GlobalSimulation: SituationDelegate {

    func start(situation: Situation?) {
        if let situation = situation {
            DispatchQueue.main.async {
                // Inform the UI
                self.delegate?.started(situation: situation)
            }
        }
    }

    func end(situation: Situation?) {
        if let situation = situation {
            DispatchQueue.main.async {
                // Inform the UI
                self.delegate?.ended(situation: situation)
            }
        }
    }
}

extension GlobalSimulation: TechnicDelegate {

    func invented(technic: Technic?) {
        if let technic = technic {
            DispatchQueue.main.async {
                // Inform the UI
                self.delegate?.invented(technic: technic)
            }
        }
    }
}
