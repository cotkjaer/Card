//
//  TwoSided3DImageView.swift
//  Card
//
//  Created by Christian Otkjær on 14/03/17.
//  Copyright © 2017 Silverback IT. All rights reserved.
//

import UIKit

open class TwoSided3DImageView: UIView
{
    let doubleSidedLayer = CATransformLayer()
    
    let topLayer = CALayer()
    let bottomLayer = CALayer()
    
    // MARK: - Init
    
    override init(frame: CGRect)
    {
        super.init(frame: frame)
        initialSetup()
    }
    
    required public init?(coder aDecoder: NSCoder)
    {
        super.init(coder: aDecoder)
        initialSetup()
    }
    
    override open func awakeFromNib()
    {
        super.awakeFromNib()
        initialSetup()
    }
    
    func initialSetup()
    {
        backgroundColor = .clear
        
        topLayer.zPosition = 2
        bottomLayer.zPosition = 1
        
        topLayer.isDoubleSided = false
        bottomLayer.isDoubleSided = true
        
        layoutLayers()
        
        doubleSidedLayer.addSublayer(topLayer)
        doubleSidedLayer.addSublayer(bottomLayer)
        
        layer.addSublayer(doubleSidedLayer)
    }
    
    func updatePerspective()
    {
        var perspective = CATransform3DIdentity
        perspective.m34 = 0.5 / -max(bounds.width, bounds.height, 1)
        doubleSidedLayer.transform = perspective
    }
    
    func layoutLayers()
    {
        updatePerspective()
        
        doubleSidedLayer.frame = bounds
        topLayer.frame = doubleSidedLayer.bounds
        bottomLayer.frame = doubleSidedLayer.bounds
    }
    
    override open func layoutSubviews()
    {
        super.layoutSubviews()
        layoutLayers()
    }
    
    private var _frontImage: UIImage?
    
    @IBInspectable
    open var frontImage: UIImage?
        {
        set { _frontImage = newValue; topLayer.contents = frontImage?.cgImage }
        get { return _frontImage }
    }
    
    private var _backImage: UIImage?
    
    @IBInspectable
    open var backImage: UIImage?
        {
        set { _backImage = newValue; bottomLayer.contents = backImage?.cgImage }
        get { return _backImage }
    }
    
    // MARK: - 3D rotation
    
    open var transform3D: CATransform3D
        {
        get { return doubleSidedLayer.sublayerTransform }
        set { doubleSidedLayer.sublayerTransform = newValue }
    }
    
    open func rotateTo(
        x: CGFloat = 0,
        y: CGFloat = 0,
        z: CGFloat = 0,
        duration: Double = 0.75,
        completion: (() -> ())? = nil)
    {
        let transform3D = CATransform3DConcat(CATransform3DMakeRotation(x, 1, 0, 0), CATransform3DConcat(CATransform3DMakeRotation(y, 0, 1, 0), CATransform3DMakeRotation(z, 0, 0, 1)))
        
        CATransaction.setCompletionBlock(completion)
        
        CATransaction.begin()
        
        CATransaction.setAnimationDuration(duration)
        CATransaction.setAnimationTimingFunction(CAMediaTimingFunction(name: kCAMediaTimingFunctionLinear))
        
        doubleSidedLayer.sublayerTransform = transform3D
        
        CATransaction.commit()
    }
    
    open func rotateBy(
        dx: CGFloat = 0,
        dy: CGFloat = 0,
        dz: CGFloat = 0,
        duration: Double = 0.75,
        completion: (() -> ())? = nil)
    {
        
        CATransaction.setCompletionBlock(completion)
        
        CATransaction.begin()
        CATransaction.setAnimationDuration(duration)
        CATransaction.setAnimationTimingFunction(CAMediaTimingFunction(name: kCAMediaTimingFunctionLinear))
        
        let m = max(abs(dx), abs(dy), abs(dz))
        
        doubleSidedLayer.sublayerTransform = CATransform3DRotate(doubleSidedLayer.sublayerTransform, m, dx / m, dy / m, dz/m)
        
        CATransaction.commit()
    }
}

