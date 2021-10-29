//
//  Species.swift
//  dotBrains
//
//  Created by Atte Jokinen on 28.10.2021.
//

import Foundation

class Species: Identifiable, ObservableObject {
    public let id = UUID()
        
    @Published public var dead: Bool
    @Published public var success: Bool
    @Published public var champion: Bool
    @Published public var position: Vector;
    public let brain: Brain;
        
    private let velocity: Vector
    private var acceleration: Vector;
    private let maxWidth: Int;
    private let maxHeight: Int;
    private let minTargetDistance: Float;
    private let dotSize: Int
        
    init(width: Int, height: Int, dotSize: Int, minTargetDistance: Float, brain: Brain) {
        self.velocity = Vector(0, 0)
        self.acceleration = Vector(0, 0)
        self.position = Vector(Float(width / 2), Float(height - 10))
        self.dead = false
        self.success = false
        self.maxWidth = width
        self.maxHeight = height
        self.minTargetDistance = minTargetDistance
        self.dotSize = dotSize
        self.champion = false
        
        self.brain = brain
    }
    
    init(copy: Species) {
        self.velocity = Vector(0, 0)
        self.acceleration = Vector(0, 0)
        self.position = Vector(Float(copy.maxWidth / 2), Float(copy.maxHeight - 10))
        self.dead = false
        self.success = false
        self.maxWidth = copy.maxWidth
        self.maxHeight = copy.maxHeight
        self.minTargetDistance = copy.minTargetDistance
        self.dotSize = copy.dotSize
        self.champion = true
        self.brain = Brain(copy: copy.brain)
    }
        
    func update(target: Vector) {
        let halfDot = Float(self.dotSize) / 2.0;
        let maxX = Float(self.maxWidth) - halfDot;
        let maxY = Float(self.maxHeight) - halfDot;

        if (self.dead || self.success) {
            return;
        }

        guard let direction = self.brain.nextDirection() else {
            self.dead = true;
            return;
        }

        self.move(direction)
        self.objectWillChange.send()
        
        if (self.position.x <= halfDot || self.position.x >= maxX) {
            self.dead = true
            return
        }

        if (self.position.y <= halfDot || self.position.y >= maxY) {
            self.dead = true
            return
        }

        let distance = self.position.nextDistance(target)
        if (distance < minTargetDistance) {
            self.success = true
            return
        }
    }
        
    func fitness(target: Vector) -> Float {
        if (self.success) {
            let size = Float(self.dotSize)
            let step = Float(self.brain.step)
            let targetFitness = 1.0 / (size * size)
            let stepFitness = 10000.0 / (step * step)
            let fitness = targetFitness + stepFitness

            return fitness;
        } else {
            let distance = self.position.nextDistance(target);
            let fitness = 1.0 / (distance * distance);

            return fitness;
        }
    }
        
    private func move(_ direction: Vector) {
        self.acceleration = direction
        self.velocity.Add(self.acceleration)
        self.velocity.limit(5)
        self.position.Add(self.velocity)
    }

}