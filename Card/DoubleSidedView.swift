//
//  DoubleSidedView.swift
//  Card
//
//  Created by Christian Otkjær on 26/02/17.
//  Copyright © 2017 Silverback IT. All rights reserved.
//

import UIKit

@IBDesignable
open class CardView: UIView
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
        
        var perspective = CATransform3DIdentity
        perspective.m34 = 1.0 / -1000
        
        //Set the anchor point to the left side of the layer without shifting position
//        doubleSidedLayer.shiftAnchorPoint(to: edge.anchorPoint)//CGPoint(x: 0, y: 0.5))
        
        doubleSidedLayer.transform = perspective

        
        layer.addSublayer(doubleSidedLayer)
    }
    
    func layoutLayers()
    {
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
    var frontImage: UIImage?
    {
        set { _frontImage = newValue; topLayer.contents = frontImage?.cgImage }
        get { return _frontImage }
    }

    private var _backImage: UIImage?
    
    @IBInspectable
    var backImage: UIImage?
        {
        set { _backImage = newValue; bottomLayer.contents = backImage?.cgImage }
        get { return _backImage }
    }

    
//    
//func initWithFrame:(CGRect)frame frontImage:(NSString*)frontImageName backImage:(NSString *)backImageName
//    {
//    CGRect containerFrame = CGRectMake(frame.origin.x - frame.size.width,
//    frame.origin.y,
//    frame.size.width*2,
//    frame.size.height);
//    
//    self = [super initWithFrame:containerFrame];
//    self.backgroundColor = [UIColor clearColor];
//    
//    //Configuring doubleSidedLayer
//    self.doubleSidedLayer  = [CATransformLayer layer];
//    [self.doubleSidedLayer setFrame:frame];
//    
//
//    
//    //Configuring top layer
//    topLayer = [[CALayer alloc]init];
//    [self.topLayer setFrame:doubleSidedLayer.bounds];
//    [self.topLayer setContents:(id)[UIImage imageNamed:frontImageName].CGImage];
//    [self.topLayer setZPosition:2];
//    [self.topLayer setDoubleSided:NO];
//    
//    //Configuring bottom layer
//    bottomLayer = [[CALayer alloc]init];
//    [self.bottomLayer setFrame:doubleSidedLayer.bounds];
//    //    [self.bottomLayer setContents:(id)[UIImage imageNamed:frontImageName].CGImage];
//    
//    self.bottomLayer.backgroundColor = [[UIColor purpleColor] CGColor];
//    [self.bottomLayer setZPosition:1];
//    [self.bottomLayer setDoubleSided:YES];
//    
//    [self.doubleSidedLayer addSublayer:topLayer];
//    [self.doubleSidedLayer addSublayer:bottomLayer];
//    [self.layer addSublayer:doubleSidedLayer];
//    
//    }
    
    var flippedHorizontally: Bool = false
    var flippedVertically: Bool = false
    
    open func flip(
                on edge: Edge = .left,
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
        
//        var x: CGFloat = edge.anchorPoint.x == 0.5 ? 1 : 0
//        var y: CGFloat = edge.anchorPoint.y == 0.5 ? 1 : 0
//
//        
//        let radians: CGFloat = .pi * 0.9999
//        
//        if edge == .bottom { x *= -1 }
//        if edge == .left { y *= -1 }
        
        let rotationTransform = CATransform3DRotate(doubleSidedLayer.sublayerTransform, .pi * 0.9999, x, y, 0)

        CATransaction.setCompletionBlock(completion)
        
//        var perspective = CATransform3DIdentity
//        perspective.m34 = 1.0 / -1000
        
        //Set the anchor point to the left side of the layer without shifting position
        doubleSidedLayer.shiftAnchorPoint(to: edge.anchorPoint)//CGPoint(x: 0, y: 0.5))
        
        CATransaction.begin()
        CATransaction.setAnimationDuration(duration)
        
        doubleSidedLayer.sublayerTransform = rotationTransform//CATransform3DRotate(doubleSidedLayer.sublayerTransform, radians, x, y, 0)
        
        doubleSidedLayer.shiftAnchorPoint(to: CGPoint(x: 0.5, y: 0.5))
        CATransaction.commit()
    }
}
