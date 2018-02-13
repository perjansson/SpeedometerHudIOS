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
    var colors : [UIColor] = [UIColor.greenColor(), UIColor.yellowColor(), UIColor.redColor(), UIColor.blueColor(), UIColor.orangeColor()]
    var colorIndex : Int = 0
    
    var hasReceivedSpeed : Bool!
    var isMirrored : Bool!
    var isMph : Bool!
    var lastSpeed : Double!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        hasReceivedSpeed = false
        isMirrored = false
        isMph = true
        updateTextColorForIndex(0)
        
        self.initLocationManager()
        
        let swipeUp = UISwipeGestureRecognizer(target: self, action: "swipeUpOrDown")
        swipeUp.numberOfTouchesRequired = 1
        swipeUp.direction = UISwipeGestureRecognizerDirection.Up
        view.addGestureRecognizer(swipeUp)
        
        let swipeDown = UISwipeGestureRecognizer(target: self, action: "swipeUpOrDown")
        swipeDown.numberOfTouchesRequired = 1
        swipeDown.direction = UISwipeGestureRecognizerDirection.Down
        view.addGestureRecognizer(swipeDown)
        
        let swipeLeft = UISwipeGestureRecognizer(target: self, action: "swipeLeft")
        swipeLeft.numberOfTouchesRequired = 1
        swipeLeft.direction = UISwipeGestureRecognizerDirection.Left
        view.addGestureRecognizer(swipeLeft)
        
        let swipeRight = UISwipeGestureRecognizer(target: self, action: "swipeRight")
        swipeRight.numberOfTouchesRequired = 1
        swipeRight.direction = UISwipeGestureRecognizerDirection.Right
        view.addGestureRecognizer(swipeRight)
        
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
    
    func locationManager(manager:CLLocationManager, didUpdateLocations locations:[CLLocation]) {
        let locationArray = locations as NSArray
        let location = locationArray.lastObject as? CLLocation
        
        if location?.speed != nil {
            var locationSpeed = location?.speed
            let locationCourse = location?.course
            if (locationSpeed < 112) { // Sometimes an incorrect high speed is received
                if (locationSpeed <= 0) {
                    locationSpeed = 0;
                } else {
                    hasReceivedSpeed = true;
                }
                
                if locationSpeed > 0 || self.hasReceivedSpeed! {
                    var newSpeed : Speed
                    if locationCourse != nil {
                        newSpeed = Speed(speedInMps: locationSpeed!, course: locationCourse!);
                    } else {
                        newSpeed = Speed(speedInMps: locationSpeed!);
                    }
                    updateSpeed(newSpeed)
                }
            }
        }
        
    }
    
    func updateSpeed(speed: Speed) {
        if speedIsValid(speed.speedInMps) {
            if self.isMph! {
                self.speed.text = speed.speedInMph()
                unit.text = "mph";
            } else {
                self.speed.text = speed.speedInKmh()
                unit.text = "km/h";
            }
            
            if speed.hasCourse() {
                unit.text = unit.text! + " and going \(speed.cardinalDirection())"
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
    
    func locationManager(manager: CLLocationManager, didFailWithError error: NSError) {
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
        self.view.layer.transform = CATransform3DMakeRotation(CGFloat(π), -360.0, 1.0, 0.0)
        UIView.commitAnimations()
    }
    
    func unmirrorScreen() {
        isMirrored = false
        UIView.beginAnimations(nil, context: nil)
        self.view.layer.transform = CATransform3DMakeRotation(CGFloat(π), 0.0, 0.0, 0.0)
        UIView.commitAnimations()
    }
    
    func swipeLeft() {
        updateTextColorForIndex(colorIndex + 1)
    }
    
    func swipeRight() {
        updateTextColorForIndex(colorIndex - 1)
    }

    
    func updateTextColorForIndex(var colorIndex : Int) {
        if colorIndex < 0 {
            colorIndex = self.colors.count - 1
        } else if colorIndex >= self.colors.count {
            colorIndex = 0
        }
        self.colorIndex = colorIndex
        speed.textColor = self.colors[colorIndex]
        unit.textColor = self.colors[colorIndex]
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
        UIApplication.sharedApplication().idleTimerDisabled = false
    }

}

