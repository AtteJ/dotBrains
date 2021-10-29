//
//  Population.swift
//  dotBrains
//
//  Created by Atte Jokinen on 28.10.2021.
//

import Foundation

class Population: ObservableObject {
    @Published public var dots: [Species] = []
    @Published public var generation: Int
        
    private let size: Int
    private let width: Int
    private let height: Int
    private let dotSize: Int
    private let brainSize: Int
    private let minTargetDistance: Double
    private let mutationRatio: Double
        
    init(
        populationSize: Int,
        width: Int,
        height: Int,
        dotSize: Int,
        brainSize: Int,
        minTargetDistance: Double,
        mutationRatio: Double
    ) {
        self.size = populationSize
        self.width = width
        self.height = height
        self.dotSize = dotSize
        self.brainSize = brainSize
        self.minTargetDistance = minTargetDistance
        self.mutationRatio = mutationRatio
        self.generation = 1
            
        self.generate(brainSize: self.brainSize);
    }
        
    func update(target: Vector) {
        self.dots.forEach { $0.update(target: target) }
    }
        
    func naturalSelection(target: Vector) {
//        self.generate(brainSize: self.brainSize);
            
        var fitnessSum: Double = 0;
        var maxFitness: Double = -1;
        var maxFitnessIndex = -1;
        var minSteps = -1;

        for index in 0..<dots.count {
            let dot = self.dots[index];
            let fitness = dot.fitness(target: target);
            if (minSteps == -1) {
                minSteps = dot.brain.size
            }

            if (fitness > maxFitness) {
                maxFitness = fitness
                maxFitnessIndex = index

                if (dot.success) {
                    minSteps = min(minSteps, dot.brain.step)
                }
            }

            fitnessSum += fitness;
        }

        let champion = self.dots[maxFitnessIndex];

        print("Min steps \(minSteps)")
        let fittestValue = Double.random(in: 0...1) * fitnessSum;
        var fittest: Species? = nil;
        var runningSum: Double = 0;
        for index in 0..<dots.count {
            runningSum += self.dots[index].fitness(target: target);
            if (runningSum >= fittestValue) {
                fittest = self.dots[index];
                break;
            }
        }

        var newDots: [Species] = [];
        newDots.append(Species(copy: champion));
        for _ in 1..<dots.count {
            // Copy the fittest brain, but mutate it by the slightest
            var directions: [Vector] = []
            for index in 0..<minSteps {
                if Double.random(in: 0...1) >= self.mutationRatio {
                    let direction = fittest!.brain.directions[index]
                    directions.append(Vector(direction.x, direction.y))
                } else {
                    let angle = Double.random(in: 0...(2 * Double.pi))
                    directions.append(Vector(cos(angle), sin(angle)))
                }
            }
                
            let nextDot = Species(
                width: self.width,
                height: self.width,
                dotSize: self.dotSize,
                minTargetDistance: minTargetDistance,
                brain: Brain(directions)
            )
                
            newDots.append(nextDot)
        }

        self.dots.removeAll()
        self.dots.append(contentsOf: newDots)

        self.generation += 1
    }
        
    func allDead() -> Bool {
        for dot in dots {
            if !dot.dead && !dot.success {
                return false
            }
        }
            
        return true
    }
        
    private func generate(brainSize: Int) {
        self.dots.removeAll()
            
        var newDots: [Species] = []
        for _ in 0..<size {
            var directions: [Vector] = []
            for _ in 0..<brainSize {
                let angle = Double.random(in: 0...(2 * Double.pi))
                directions.append(Vector(cos(angle), sin(angle)))
            }
                
            let brain = Brain(directions)
            let dot = Species(
                width: width,
                height: height,
                dotSize: dotSize,
                minTargetDistance: minTargetDistance,
                brain: brain
            )

            newDots.append(dot)
        }
            
        self.dots.append(contentsOf: newDots)
    }
}
