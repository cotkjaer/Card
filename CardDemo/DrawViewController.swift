//
//  DrawViewController.swift
//  Card
//
//  Created by Christian Otkjær on 27/02/17.
//  Copyright © 2017 Silverback IT. All rights reserved.
//

import UIKit
import Card

let duration: Double = 0.35

class DrawViewController: UIViewController
{
    @IBOutlet weak var templateCard3DView: Card3DView!
    
    @IBOutlet weak var stackBaseView: UIView!
    
    @IBOutlet weak var controls: UIView!
    
    @IBOutlet weak var pileBaseView: UIView!
    
    var stack: [Card3DView] = []
    var pile: [Card3DView] = []
    
    // MARK: - Lifecycle
    
    override func viewWillAppear(_ animated: Bool)
    {
        super.viewWillAppear(animated)
        
        templateCard3DView.flip()
    }
    
    override func viewDidAppear(_ animated: Bool)
    {
        super.viewDidAppear(animated)
        
        for _ in 0..<20 {  addCard() }
    }
    
    typealias Rotation3D = (x: CGFloat, y: CGFloat, z: CGFloat)
    
    let stackCardRotation: Rotation3D = (.pi * 0.9999, 0, 0)

    let pileCardRotation: Rotation3D = (0, 0, 0)
    
    func addCard()
    {
        let card3DView = Card3DView()
        card3DView.frontImage = #imageLiteral(resourceName: "Front")
        card3DView.backImage = #imageLiteral(resourceName: "Back")

        card3DView.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(card3DView)
        stack.append(card3DView)
        
        view.addConstraints([
            NSLayoutConstraint(
                item: card3DView,
                attribute: .centerX,
                relatedBy: .equal,
                toItem: view,
                attribute: .centerX,
                multiplier: 1,
                constant: 0),
        
            NSLayoutConstraint(
                item: card3DView,
                attribute: .centerY,
                relatedBy: .equal,
                toItem: stackBaseView,
                attribute: .centerY,
                multiplier: 1,
                constant: 0),
        
            NSLayoutConstraint(
                item: card3DView,
                attribute: .height,
                relatedBy: .equal,
                toItem: templateCard3DView,
                attribute: .height,
                multiplier: 1,
                constant: 0),
        
            NSLayoutConstraint(
                item: card3DView,
                attribute: .width,
                relatedBy: .equal,
                toItem: templateCard3DView,
                attribute: .width,
                multiplier: 1,
                constant: 0)])
        
        
        card3DView.rotateTo(
            x: stackCardRotation.x,
            y: stackCardRotation.y,
            z: stackCardRotation.z,     duration: 0.1) {}

//        view.setNeedsUpdateConstraints()
//        view.updateConstraintsIfNeeded()
    }
    
    // MARK: - Draw
    
    @IBOutlet weak var shuffleButton: UIButton!
    
    @IBOutlet weak var undoButton: UIButton!
    
    @IBOutlet weak var drawButton: UIButton!
    
    @IBAction func handleDrawButton(_ sender: UIButton)
    {
        guard !stack.isEmpty else { return }
        
        sender.isEnabled = false
        
        let Card3DView = stack.removeLast()
        pile.append(Card3DView)

        view.bringSubview(toFront: Card3DView)
        
        Card3DView.rotateTo(
            x: pileCardRotation.x,
            y: pileCardRotation.y,
            z: pileCardRotation.z,
            duration: duration,
            completion: updateButtons)

        align(Card3DView: Card3DView, with: pileBaseView, duration: duration)
    }
    
    func align(Card3DView: Card3DView, with baseView: UIView, duration: Double)
    {
        guard let constraint = Card3DView.superview?.constraints.first(where: { $0.firstItem === Card3DView && $0.firstAttribute == .centerY }) else { return }
        
        view.removeConstraint(constraint)
        
        view.addConstraint(NSLayoutConstraint(
            item: Card3DView,
            attribute: .centerY,
            relatedBy: .equal,
            toItem: baseView,
            attribute: .centerY,
            multiplier: 1,
            constant: 0))
        
        Card3DView.superview?.setNeedsLayout()
        
        UIView.animate(
            withDuration: duration,
            delay: 0,
            options: [.curveLinear],
            animations: { 
                Card3DView.superview?.layoutIfNeeded()
        }, completion: nil)
        
    }

    @IBAction func handleUndoButton(_ sender: UIButton)
    {
        guard !pile.isEmpty else { return }
        
        sender.isEnabled = false
        
        putBack(duration: duration, completion: updateButtons)
    }

    @IBAction func handleShuffleButton(_ sender: UIButton)
    {
        guard !pile.isEmpty else { return }
        
        sender.isEnabled = false
        
        putBackAll()
    }

    func putBackAll()
    {
        guard !pile.isEmpty else { updateButtons(); return }
        
        putBack(duration: 0.2, completion: putBackAll)
    }
    
    func putBack(duration: Double, completion: (() -> ())? = nil)
    {
        let Card3DView = pile.removeLast()
        stack.append(Card3DView)
        
        view.bringSubview(toFront: Card3DView)
        
        Card3DView.rotateTo(
            x: stackCardRotation.x,
            y: stackCardRotation.y,
            z: stackCardRotation.z,
            duration: duration,
            completion: completion)
        
        align(Card3DView: Card3DView, with: stackBaseView, duration: duration)
    }
    
    
    func updateButtons()
    {
        drawButton.isEnabled = !stack.isEmpty
        shuffleButton.isEnabled = !pile.isEmpty
        undoButton.isEnabled = !pile.isEmpty
    }
}
