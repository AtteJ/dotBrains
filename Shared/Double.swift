//
//  Double.swift
//  dotBrains
//
//  Created by Atte Jokinen on 29.10.2021.
//

import Foundation

extension Double {
    /// Returns true if given parameter is greater than the Double that calls the function
    func lessThan(_ b: Double) -> Bool{
        let value1 = roundTo(self)
        let value2 = roundTo(b)
        
        let difference = value1 - value2
        if (difference >= 0) {
            return false
        }
        else {
            return true
        }
    }
    
    
    /// Returns true if given parameter is less than the Double that calls the function
    func greaterThan(_ b: Double) -> Bool {
        let value1 = roundTo(self)
        let value2 = roundTo(b)
        
        let difference = value1 - value2
        if (difference > 0) {
            return true
        }
        else {
            return false
        }
    }
    
    
    /// Returns true if the doubles are equal
    func equal(_ b: Double) -> Bool {
        let value1 = roundTo(self)
        let value2 = roundTo(b)
        
        let difference = value1 - value2
        if (difference == 0)
        {
            return true
        }
        else {
            return false
        }
    }
    
    func roundTo (_ a: Double) -> Double {
        return (a * 1000.0).rounded() / 1000.0
    }
}
