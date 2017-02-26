//
//  UIView+Edge.swift
//  Card
//
//  Created by Christian Otkjær on 26/02/17.
//  Copyright © 2017 Silverback IT. All rights reserved.
//

import UIKit

// MARK: - Edge

extension UIView
{
    public enum Edge
    {
        case top, bottom, left, right
        
        var animationTransitionOption: UIViewAnimationOptions
        {
            switch self
            {
            case .top:
                return .transitionFlipFromTop
                
            case .bottom:
                return .transitionFlipFromBottom
                
            case .left:
                return .transitionFlipFromLeft
                
            case .right:
                return .transitionFlipFromRight
            }
        }
        
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
}

