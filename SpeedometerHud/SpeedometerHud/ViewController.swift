//
//  ViewController.swift
//  SpeedometerHud
//
//  Created by Per Jansson on 2014-12-07.
//  Copyright (c) 2014 Per Jansson. All rights reserved.
//

import UIKit
import CoreLocation
import QuartzCore
import Darwin

class ViewController: UIViewController, CLLocationManagerDelegate {

    @IBOutlet weak var speed: UILabel!
    @IBOutlet weak var unit: UILabel!
    
    var locationManager : CLLocationManager!
    
    let π = M_PI
    
    var hasReceivedSpeed : Bool!
    var isMirrored : Bool!
    var isMph : Bool!
    var lastSpeed : Double!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        hasReceivedSpeed = false
        isMirrored = false
        isMph = true
        
        self.initLocationManager()
        
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
    
    func initLocationManager() {
        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBestForNavigation
        locationManager.distanceFilter = kCLDistanceFilterNone;
        locationManager.requestAlwaysAuthorization()
        locationManager.startUpdatingLocation()
    }
    
    func locationManager(manager:CLLocationManager, didUpdateLocations locations:[AnyObject]) {
        var locationArray = locations as NSArray
        var location = locationArray.lastObject as? CLLocation
        var locationSpeed = location?.speed
        if (locationSpeed < 112) { // Sometimes an incorrect high speed is received
            if (locationSpeed < 0) {
                locationSpeed = 0;
            } else {
                hasReceivedSpeed = true;
            }
            
            if locationSpeed > 0 || self.hasReceivedSpeed! {
                var newSpeed : Speed = Speed(speedInMps: locationSpeed!);
                if self.isMph! {
                    updateSpeed(newSpeed.speedInMph())
                } else {
                    updateSpeed(newSpeed.speedInKmh())
                }
            }
        }
    }
    
    func updateSpeed(speed: NSString) {
        if speedIsValid(speed.doubleValue) {
            self.speed.text = speed
            if self.isMph! {
                unit.text = "mph";
            } else {
                unit.text = "kmh";
            }
        }
    }
    
    func speedIsValid(newSpeed : Double?) -> Bool {
        if (newSpeed != 0 || lastSpeed == 0 || abs(lastSpeed - newSpeed!) < 15) {
            lastSpeed = newSpeed;
            return true
        } else {
            return false
        }
    }
    
    func locationManager(manager: CLLocationManager!, didFailWithError error: NSError!) {
        locationManager.stopUpdatingLocation()
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

