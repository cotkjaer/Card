//
//  DoubleSidedView.swift
//  Card
//
//  Created by Christian Otkjær on 26/02/17.
//  Copyright © 2017 Silverback IT. All rights reserved.
//

import UIKit

@IBDesignable
open class Card3DView: TwoSided3DImageView
{
    // MARK: - Flip
    
    public enum Edge
    {
        case top, bottom, left, right
        
        var anchorPoint: CGPoint
        {
            switch self
            {
            case .top:
                return CGPoint(x: 0.5, y: 0)
                
            case .bottom:
                return CGPoint(x: 0.5, y: 1)
                
            case .left:
                return CGPoint(x: 0, y: 0.5)
                
            case .right:
                return CGPoint(x: 1, y: 0.5)
            }
        }
    }

    var flippedHorizontally: Bool = false
    var flippedVertically: Bool = false

    open var isFlipped: Bool { return flippedHorizontally != flippedVertically }
    
    open func flip(
                from edge: Edge = .left,
                duration: Double = 0.75,
                completion: (() -> ())? = nil)
    {
        let x,y: CGFloat
        
        switch edge
        {
        case .top:
            x = flippedHorizontally ? 1 : -1
            y = 0
            
        case .bottom:
            x = flippedHorizontally ? -1 : 1
            y = 0
            
        case .left:
            x = 0
            y = flippedVertically ? -1 : 1
            
        case .right:
            x = 0
            y = flippedVertically ? 1 : -1
            
        }
        
        switch edge
        {
        case .top, .bottom:
            flippedVertically = !flippedVertically
            
        case .left, .right:
            flippedHorizontally = !flippedHorizontally
        }

        CATransaction.setCompletionBlock(completion)
        CATransaction.begin()
        CATransaction.setAnimationDuration(duration)
        CATransaction.setAnimationTimingFunction(CAMediaTimingFunction(name: kCAMediaTimingFunctionLinear))
        
        doubleSidedLayer.sublayerTransform = CATransform3DRotate(doubleSidedLayer.sublayerTransform, .pi * 0.9999, x, y, 0)
        
        CATransaction.commit()
    }
}
