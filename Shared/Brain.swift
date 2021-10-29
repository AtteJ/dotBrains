//
//  Brain.swift
//  dotBrains
//
//  Created by Atte Jokinen on 28.10.2021.
//

import Foundation

class Brain {
    public let size: Int
    public let directions: [Vector]
    
    public var step: Int
    
    init(_ directions: [Vector]) {
        self.size = directions.count
        self.step = 0
        self.directions = directions
    }
    
    init(copy: Brain) {
            self.size = copy.directions.count
            self.step = 0
            self.directions = copy.directions
    }
        
    func nextDirection() -> Vector? {
        if (self.directions.count <= self.step) {
            return nil;
        }

        let direction = self.directions[self.step];
        self.step += 1;

        return direction;
    }
}
