//
//  Flip2DViewController.swift
//  Card
//
//  Created by Christian Otkjær on 14/03/17.
//  Copyright © 2017 Silverback IT. All rights reserved.
//

import UIKit
import Card

class Flip2DViewController: UIViewController
{
    @IBOutlet weak var cardView: CardView!

    @IBAction func handleTap(_ recognizer: UIGestureRecognizer)
    {
        guard recognizer.state == .ended else { return }
        
        recognizer.isEnabled = false
        
        cardView.flip(
            duration: 1,
            delay: 0,
            from: .bottom) { (completed) in
                recognizer.isEnabled = completed
        }
    }

}
