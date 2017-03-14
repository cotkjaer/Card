//
//  ViewController.swift
//  CardDemo
//
//  Created by Christian Otkjær on 22/02/17.
//  Copyright © 2017 Silverback IT. All rights reserved.
//

import UIKit
import Card

class ViewController: UIViewController
{
    @IBOutlet weak var Card3DView: Card3DView!
    
    @IBOutlet weak var topButton: UIButton!
    @IBOutlet weak var bottomButton: UIButton!
    @IBOutlet weak var leftButton: UIButton!
    @IBOutlet weak var rightButton: UIButton!
    
    @IBOutlet weak var horizontalConstraint: NSLayoutConstraint!

    @IBOutlet weak var verticalConstrint: NSLayoutConstraint!
    
    @IBAction func flip(_ sender: UIButton)
    {
        sender.isEnabled = false
        
        let edge: Card3DView.Edge
        
        switch sender
        {
        case topButton:
            edge = .top
            
        case leftButton:
            edge = .left
            
        case bottomButton:
            edge = .bottom
            
        case rightButton:
            edge = .right
            
        default:
            edge = .left
        }
        
        Card3DView.flip(
            from: edge,
            duration: 3,
            completion: { (completed) in
                sender.isEnabled = true
        })
        
    }
}

