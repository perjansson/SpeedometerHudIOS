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
        
        /*var alert = UIAlertController(title: "Alert", message: "Message", preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .Default, handler: { action in
            switch action.style {
            case .Default:
                println("default")
                
            case .Cancel:
                println("cancel")
                
            case .Destructive:
                println("destructive")
            }
        }))
        self.presentViewController(alert, animated: true, completion: nil)*/
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

