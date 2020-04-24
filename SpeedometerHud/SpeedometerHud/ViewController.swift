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
    
    let π = Double.pi
    var colors : [UIColor] = [UIColor.green, UIColor.yellow, UIColor.red, UIColor.blue, UIColor.orange]
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
        updateTextColorForIndex(colorIndex: 0)
        
        self.initLocationManager()
        
        let swipeUp = UISwipeGestureRecognizer(target: self, action: #selector(ViewController.swipeUpOrDown))
        swipeUp.numberOfTouchesRequired = 1
        swipeUp.direction = UISwipeGestureRecognizer.Direction.up
        view.addGestureRecognizer(swipeUp)
        
        let swipeDown = UISwipeGestureRecognizer(target: self, action: #selector(ViewController.swipeUpOrDown))
        swipeDown.numberOfTouchesRequired = 1
        swipeDown.direction = UISwipeGestureRecognizer.Direction.down
        view.addGestureRecognizer(swipeDown)
        
        let swipeLeft = UISwipeGestureRecognizer(target: self, action: #selector(ViewController.swipeLeft))
        swipeLeft.numberOfTouchesRequired = 1
        swipeLeft.direction = UISwipeGestureRecognizer.Direction.left
        view.addGestureRecognizer(swipeLeft)
        
        let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(ViewController.swipeRight))
        swipeRight.numberOfTouchesRequired = 1
        swipeRight.direction = UISwipeGestureRecognizer.Direction.right
        view.addGestureRecognizer(swipeRight)
        
        UIApplication.shared.isIdleTimerDisabled = true
        UIApplication.shared.setStatusBarHidden(true, with: UIStatusBarAnimation.fade)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        let alertController = UIAlertController(title: "Mph or km/h?", message: "Select how speed should be shown.", preferredStyle: UIAlertController.Style.alert)
        alertController.addAction(UIAlertAction(title: "mph", style: .default) { action in
            self.isMph = true
            })
        alertController.addAction(UIAlertAction(title: "kmh", style: .default) { action in
            self.isMph = false
            })
        self.present(alertController, animated: true, completion: nil)
    }
    
    func initLocationManager() {
        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBestForNavigation
        locationManager.distanceFilter = kCLDistanceFilterNone;
        locationManager.requestAlwaysAuthorization()
        locationManager.startUpdatingLocation()
    }
    
    func locationManager(_ manager:CLLocationManager, didUpdateLocations locations:[CLLocation]) {
        let locationArray = locations as NSArray
        let location = locationArray.lastObject as? CLLocation
        
        if location?.speed != nil {
            var locationSpeed = location!.speed
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
                        newSpeed = Speed(speedInMps: locationSpeed, course: locationCourse!);
                    } else {
                        newSpeed = Speed(speedInMps: locationSpeed);
                    }
                    updateSpeed(speed: newSpeed)
                }
            }
        }
        
    }
    
    func updateSpeed(speed: Speed) {
        if speedIsValid(newSpeed: speed.speedInMps) {
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
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        locationManager.stopUpdatingLocation()
    }
    
    @objc func swipeUpOrDown() {
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
    
    @objc func swipeLeft() {
        updateTextColorForIndex(colorIndex: colorIndex + 1)
    }
    
    @objc func swipeRight() {
        updateTextColorForIndex(colorIndex: colorIndex - 1)
    }
    
    func updateTextColorForIndex(colorIndex : Int) {
        var c = colorIndex
        if colorIndex < 0 {
            c = self.colors.count - 1
        } else if colorIndex >= self.colors.count {
            c = 0
        }
        self.colorIndex = c
        speed.textColor = self.colors[c]
        unit.textColor = self.colors[c]
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
        UIApplication.shared.isIdleTimerDisabled = false
    }

}

