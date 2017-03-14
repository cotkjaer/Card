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
    @IBOutlet weak var templateCardView: CardView!
    
    @IBOutlet weak var stackBaseView: UIView!
    
    @IBOutlet weak var controls: UIView!
    
    @IBOutlet weak var pileBaseView: UIView!
    
    var stack: [CardView] = []
    var pile: [CardView] = []
    
    // MARK: - Lifecycle
    
    override func viewWillAppear(_ animated: Bool)
    {
        super.viewWillAppear(animated)
        
        templateCardView.flip()
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
        let cardView = CardView()
        cardView.frontImage = #imageLiteral(resourceName: "Front")
        cardView.backImage = #imageLiteral(resourceName: "Back")

        cardView.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(cardView)
        stack.append(cardView)
        
        view.addConstraints([
            NSLayoutConstraint(
                item: cardView,
                attribute: .centerX,
                relatedBy: .equal,
                toItem: view,
                attribute: .centerX,
                multiplier: 1,
                constant: 0),
        
            NSLayoutConstraint(
                item: cardView,
                attribute: .centerY,
                relatedBy: .equal,
                toItem: stackBaseView,
                attribute: .centerY,
                multiplier: 1,
                constant: 0),
        
            NSLayoutConstraint(
                item: cardView,
                attribute: .height,
                relatedBy: .equal,
                toItem: templateCardView,
                attribute: .height,
                multiplier: 1,
                constant: 0),
        
            NSLayoutConstraint(
                item: cardView,
                attribute: .width,
                relatedBy: .equal,
                toItem: templateCardView,
                attribute: .width,
                multiplier: 1,
                constant: 0)])
        
        
        cardView.rotateTo(
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
        
        let cardView = stack.removeLast()
        pile.append(cardView)

        view.bringSubview(toFront: cardView)
        
        cardView.rotateTo(
            x: pileCardRotation.x,
            y: pileCardRotation.y,
            z: pileCardRotation.z,
            duration: duration,
            completion: updateButtons)

        align(cardView: cardView, with: pileBaseView, duration: duration)
    }
    
    func align(cardView: CardView, with baseView: UIView, duration: Double)
    {
        guard let constraint = cardView.superview?.constraints.first(where: { $0.firstItem === cardView && $0.firstAttribute == .centerY }) else { return }
        
        view.removeConstraint(constraint)
        
        view.addConstraint(NSLayoutConstraint(
            item: cardView,
            attribute: .centerY,
            relatedBy: .equal,
            toItem: baseView,
            attribute: .centerY,
            multiplier: 1,
            constant: 0))
        
        cardView.superview?.setNeedsLayout()
        
        UIView.animate(
            withDuration: duration,
            delay: 0,
            options: [.curveLinear],
            animations: { 
                cardView.superview?.layoutIfNeeded()
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
        let cardView = pile.removeLast()
        stack.append(cardView)
        
        view.bringSubview(toFront: cardView)
        
        cardView.rotateTo(
            x: stackCardRotation.x,
            y: stackCardRotation.y,
            z: stackCardRotation.z,
            duration: duration,
            completion: completion)
        
        align(cardView: cardView, with: stackBaseView, duration: duration)
    }
    
    
    func updateButtons()
    {
        drawButton.isEnabled = !stack.isEmpty
        shuffleButton.isEnabled = !pile.isEmpty
        undoButton.isEnabled = !pile.isEmpty
    }
}
