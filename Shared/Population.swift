//
//  Population.swift
//  dotBrains
//
//  Created by Atte Jokinen on 28.10.2021.
//

import Foundation

class Population {
    public var species: [Species] = []
    public var generation: Int
    
    private let size: Int
    private let minTargetDistance: Double
    private let mutationRatio: Double
    
    func update(target: Vector) {
        self.species.forEach { $0.update(target: target) }
    }
    func naturalSelection(target: Vector) {}
    
    
    func allDead() -> Bool {
        for specie in species {
                if !specie.dead && !specie.success {
                    return false
                }
            }
            return true
    }
}
