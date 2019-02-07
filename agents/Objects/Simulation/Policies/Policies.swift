//
//  Policies.swift
//  agents
//
//  Created by Michael Rommel on 24.10.18.
//  Copyright © 2018 Michael Rommel. All rights reserved.
//

import Foundation

class Policies {

    var primarySchools: PrimarySchools = PrimarySchools()
    var sewage: Sewage = Sewage()

    fileprivate var policies: [Policy] = []

    init() {

        self.primarySchools = PrimarySchools()
        self.sewage = Sewage()
    }

    func setup(with global: GlobalSimulation) {

        self.primarySchools.setup(with: global)
        self.sewage.setup(with: global)
    }

    func add(policy: Policy) {

        self.policies.append(policy)
    }

    func calculate() {

        self.policies.forEach { $0.calculate() }
    }

    func push() {

        self.policies.forEach { $0.push() }
    }
}

extension Policies: Sequence {

    struct PoliciesIterator: IteratorProtocol {

        private var index = 0
        private let policies: [Policy]

        init(policies: [Policy]) {
            self.policies = policies
        }

        mutating func next() -> Policy? {
            let policy = self.policies[safe: index]
            index += 1
            return policy
        }
    }

    func makeIterator() -> PoliciesIterator {
        return PoliciesIterator(policies: self.policies)
    }
}
