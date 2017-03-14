//
//  TwoSidedImageView.swift
//  Card
//
//  Created by Christian Otkjær on 27/02/17.
//  Copyright © 2017 Silverback IT. All rights reserved.
//

import UIKit

/**
 View representing a two-sided image. It has two sides and can be flipped between them.
 */
@IBDesignable
open class TwoSidedImageView: UIImageView
{
    @IBInspectable
    open var frontImage: UIImage?
    
    @IBInspectable
    open var backImage: UIImage?
    
    // MARK: - Flip
    
    @IBInspectable
    open var isFlipped: Bool
        {
        get { return image == backImage }
        set { image = newValue ? backImage : frontImage }
    }
    
    /** flips the card over with no animation
     */
    open func flip()
    {
        isFlipped = !isFlipped
    }
    
    public enum FlipFrom
    {
        case top, left, right, bottom
        
        var animationOption: UIViewAnimationOptions
        {
            switch self {
            case .top: return .transitionFlipFromTop
            case .bottom: return .transitionFlipFromBottom
            case .left: return .transitionFlipFromLeft
            case .right: return .transitionFlipFromRight
            }
        }
    }
    
    /** flips the card over animated
     - parameter duration: tim the flip should take
     */
    open func flip(duration: Double,
                   delay: Double = 0,
                   from: FlipFrom = .bottom,
                   completion: ((Bool)->())? = nil)
    {
        let originalTransform = transform
        
        let temporaryTransform = transform.scaledBy(x: 1.1, y: 1.1)
        
        func updateTransform(_ newTransform: CGAffineTransform)
        {
            transform = newTransform
        }
        
        UIView.animate(
            withDuration: duration / 5,
            delay: delay,
            options: [.curveEaseIn],
            animations: { updateTransform( temporaryTransform) },
            completion: { _ in
                
                self.superview?.bringSubview(toFront: self)
                
                UIView.transition(
                    with: self,
                    duration: 3 * duration / 5,
                    options: [.curveLinear, from.animationOption],
                    animations: self.flip,
                    completion: { _ in
                        
                        UIView.animate(
                            withDuration: duration / 5,
                            delay: 0,
                            options: [.curveEaseOut, .beginFromCurrentState],
                            animations: { updateTransform( originalTransform) },
                            completion: completion)
                })
        })
    }
}
