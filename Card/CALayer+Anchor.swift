//
//  CALayer+Anchor.swift
//  Card
//
//  Created by Christian Otkjær on 26/02/17.
//  Copyright © 2017 Silverback IT. All rights reserved.
//

import Foundation

// MARK: - AnchorPoint

extension CALayer
{
    /**
     Moves the anchor-point without moving the layer
     - parameter dx: horizontal displacement
     - parameter dy: vertical displacement
     */
    func shiftAnchorPoint(byDx dx: CGFloat, dy: CGFloat)
    {
        guard dx != 0 || dy != 0 else { return }
        
        //Set the anchor point
        anchorPoint = CGPoint(x: anchorPoint.x + dx, y: anchorPoint.y + dy)
        
        // Move the position, to avoid the layer shifting
        position = CGPoint(
            x: position.x + bounds.size.width * dx,
            y: position.y + bounds.size.height * dy)
    }
    
    /**
     Moves the anchor-point without moving the layer
     - parameter delta: displacement vector
     */
    func shiftAnchorPoint(by delta: CGVector)
    {
        shiftAnchorPoint(byDx: delta.dx, dy: delta.dy)
    }
    
    /**
     Moves the anchor-point to a new position without moving the layer
     - parameter newAnchorPoint: the new anchor-point 
     */
    func shiftAnchorPoint(to newAnchorPoint: CGPoint)
    {
        shiftAnchorPoint(byDx: newAnchorPoint.x - anchorPoint.x, dy: newAnchorPoint.y - anchorPoint.y)
    }
}
