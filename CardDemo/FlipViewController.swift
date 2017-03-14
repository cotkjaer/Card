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
    @IBOutlet weak var Card3DView: Card3DView?
    
    @IBOutlet weak var Card3DViewVerticalConstraint: NSLayoutConstraint?
    
    @IBOutlet weak var Card3DViewHorizontalConstraint: NSLayoutConstraint?
    
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
        guard let Card3DView = Card3DView else { return }

        guard sender.state == .ended else { return }

        sender.isEnabled = false
        
        let location = sender.location(in: view)
        
        let duration: Double = 1
        
       
        let frame = Card3DView.frame
        
        let candidates: [(Card3DView.Edge, CGFloat)] =
            [(.left, frame.minX - location.x),
             (.right, location.x - frame.maxX),
             (.top, frame.minY - location.y),
             (.bottom, location.y - frame.maxY)]
        
        let best = candidates.min(by: {$0.1 > $1.1})!
        
        let edge: Card3DView.Edge = best.0
        
        Card3DView.flip(
            from: edge,
            duration: duration,
            completion: {
            sender.isEnabled = true
        })

        Card3DViewHorizontalConstraint?.constant = location.x - view.bounds.midX
        
        Card3DViewVerticalConstraint?.constant = location.y - view.bounds.midY
        
        view.setNeedsLayout()
        
        UIView.animate(withDuration: duration, animations: { self.view.layoutIfNeeded() })
    }
}
