//
//  xor.swift
//  Card
//
//  Created by Christian Otkjær on 26/02/17.
//  Copyright © 2017 Silverback IT. All rights reserved.
//

import Foundation

/** Logical XOR operator for Bool
 
 - true ^ true == false
 - true ^ false == true
 - false ^ true == true
 - false ^ false == false
 - parameter lhs: left hand side
 - parameter rhs: right hand side
 */
@inline(__always) func ^(lhs: Bool, rhs: Bool) -> Bool
{
    return (lhs != rhs)
}
