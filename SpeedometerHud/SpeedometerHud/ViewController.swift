//
//  ViewController.swift
//  SpeedometerHud
//
//  Created by Per Jansson on 2014-12-07.
//  Copyright (c) 2014 Per Jansson. All rights reserved.
//

import UIKit
import QuartzCore
import Darwin

class ViewController: UIViewController {

    @IBOutlet weak var speed: UILabel!
    @IBOutlet weak var unit: UILabel!
    
    var hasReceivedSpeed : Bool!
    var isMirrored : Bool!
    var isMph : Bool!
    
    let π = M_PI
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        hasReceivedSpeed = false
        isMirrored = false
        isMph = true
        
        let swipeUp = UISwipeGestureRecognizer(target: self, action: "swipeUpOrDown")
        swipeUp.numberOfTouchesRequired = 1
        swipeUp.direction = UISwipeGestureRecognizerDirection.Up
        view.addGestureRecognizer(swipeUp)
        
        let swipeDown = UISwipeGestureRecognizer(target: self, action: "swipeUpOrDown")
        swipeDown.numberOfTouchesRequired = 1
        swipeDown.direction = UISwipeGestureRecognizerDirection.Down
        view.addGestureRecognizer(swipeDown)
        
        UIApplication.sharedApplication().idleTimerDisabled = true
        UIApplication.sharedApplication().setStatusBarHidden(true, withAnimation: UIStatusBarAnimation.Fade)
    }
    
    override func viewDidAppear(animated: Bool) {
        let alertController = UIAlertController(title: "Mph or km/h?", message: "Select how speed should be shown.", preferredStyle: UIAlertControllerStyle.Alert)
        alertController.addAction(UIAlertAction(title: "mph", style: .Default) { action in
            self.isMph = true
            })
        alertController.addAction(UIAlertAction(title: "kmh", style: .Default) { action in
            self.isMph = false
            })
        self.presentViewController(alertController, animated: true, completion: nil)
    }
    
    func swipeUpOrDown() {
        if (isMirrored!) {
            unmirrorScreen()
        } else {
            mirrorScreen()
        }
    }
    
    func mirrorScreen() {
        isMirrored = true
        UIView.beginAnimations(nil, context: nil)
        speed.layer.transform = CATransform3DMakeRotation(CGFloat(π), -360.0, 1.0, 0.0)
        unit.layer.transform = CATransform3DMakeRotation(CGFloat(π), -360.0, 1.0, 0.0)
        UIView.commitAnimations()
    }
    
    func unmirrorScreen() {
        isMirrored = false
        UIView.beginAnimations(nil, context: nil)
        speed.layer.transform = CATransform3DMakeRotation(CGFloat(π), 0.0, 0.0, 0.0)
        unit.layer.transform = CATransform3DMakeRotation(CGFloat(π), 0.0, 0.0, 0.0)
        UIView.commitAnimations()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
        UIApplication.sharedApplication().idleTimerDisabled = false
    }

}

