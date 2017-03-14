//
//  FlipViewController.swift
//  Card
//
//  Created by Christian Otkjær on 27/02/17.
//  Copyright © 2017 Silverback IT. All rights reserved.
//

import UIKit
import Card

class FlipViewController: UIViewController
{
    @IBOutlet weak var cardView: CardView?
    
    @IBOutlet weak var cardViewVerticalConstraint: NSLayoutConstraint?
    
    @IBOutlet weak var cardViewHorizontalConstraint: NSLayoutConstraint?
    
    override func viewDidLoad()
    {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    @IBOutlet var tapRecognizer: UITapGestureRecognizer!
  

    @IBAction func handleTap(_ sender: UITapGestureRecognizer)
    {
        guard let cardView = cardView else { return }

        guard sender.state == .ended else { return }

        sender.isEnabled = false
        
        let location = sender.location(in: view)
        
        let duration: Double = 1
        
       
        let frame = cardView.frame
        
        let candidates: [(CardView.Edge, CGFloat)] =
            [(.left, frame.minX - location.x),
             (.right, location.x - frame.maxX),
             (.top, frame.minY - location.y),
             (.bottom, location.y - frame.maxY)]
        
        let best = candidates.min(by: {$0.1 > $1.1})!
        
        let edge: CardView.Edge = best.0
        
        cardView.flip(
            from: edge,
            duration: duration,
            completion: {
            sender.isEnabled = true
        })

        cardViewHorizontalConstraint?.constant = location.x - view.bounds.midX
        
        cardViewVerticalConstraint?.constant = location.y - view.bounds.midY
        
        view.setNeedsLayout()
        
        UIView.animate(withDuration: duration, animations: { self.view.layoutIfNeeded() })
    }
}
