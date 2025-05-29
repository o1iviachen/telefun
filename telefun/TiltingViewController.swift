//
//  TiltingViewController.swift
//  telefun
//
//  Created by olivia chen on 2025-05-23.
//

import UIKit
import CoreMotion

class TiltingViewController: UIViewController {
    
    let motionManager = CMMotionManager()
    let speed = 50.0
    var done = false
    var phoneNumber: String? = nil
    var phoneNumberCharacters: [Character] = []
    var counter: Int = 0
    var xBounds: [CGFloat] = []
    var yBounds: [CGFloat] = []
    
    @IBOutlet weak var gibbyPhoto: UIView!
    @IBOutlet weak var phoneNumberLabel: UILabel!
    @IBOutlet weak var ballView: UIView!
    @IBOutlet weak var numberLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.hidesBackButton = true
        ballView.layer.cornerRadius = 25
        self.phoneNumberCharacters = Array(phoneNumber!)
        self.numberLabel.text = String(self.phoneNumberCharacters[counter])
        moveBall()
        phoneNumberLabel.text = "Confirm your phone number: \(phoneNumber!)"
    }
    
    override func viewDidLayoutSubviews() {
        // Code from https://developer.apple.com/documentation/corefoundation/cgrect/minx
        self.xBounds.append(view.safeAreaLayoutGuide.layoutFrame.minX)
        self.xBounds.append(view.safeAreaLayoutGuide.layoutFrame.maxX)
        self.yBounds.append(view.safeAreaLayoutGuide.layoutFrame.minY)
        self.yBounds.append(view.safeAreaLayoutGuide.layoutFrame.maxY)
        print(self.xBounds, self.yBounds)
        randomPosition(object: numberLabel)
    }
    
    func moveBall() {
        if motionManager.isAccelerometerAvailable {
            motionManager.accelerometerUpdateInterval = 0.02
            
            // Code from https://developer.apple.com/documentation/coremotion/cmmotionmanager/startaccelerometerupdates()
            motionManager.startAccelerometerUpdates(to: .main) { data, error in
                if let data = data {
                    let acceleration = data.acceleration
                    var ballCenter = self.ballView.center
                    ballCenter.x += CGFloat(acceleration.x) * self.speed
                    ballCenter.y -= CGFloat(acceleration.y) * self.speed
                    self.ballView.center = ballCenter
                }
                if !self.done {
                    self.checkContainsNumber()
                    self.checkIntersectsImage()
                }
            }
        }
    }
    
    func checkContainsNumber() {
        // Code from https://developer.apple.com/documentation/uikit/uiview/frame
        let ball = self.ballView.frame
        let number = self.numberLabel.frame
        
        // Code from https://developer.apple.com/documentation/corefoundation/cgrect/contains(_:)
        if ball.contains(number) {
            updateScreen()
        }
    }
    
    func checkIntersectsImage() {
        // Code from https://developer.apple.com/documentation/uikit/uiview/frame
        let ball = self.ballView.frame
        let gibby = self.gibbyPhoto.frame
        
        // Code from https://developer.apple.com/documentation/corefoundation/cgrect/intersects(_:)
        if ball.intersects(gibby) {
            done = true
            print("oijehrw")
            performSegue(withIdentifier: "lostSegue", sender: self)
        }
    }
    
    func updateScreen() {
        if counter < 9 {
            self.counter += 1
            self.numberLabel.text = String(self.phoneNumberCharacters[counter])
            randomPosition(object: self.numberLabel)
        }
        else {
            done = true
        }
    }
    
    func randomPosition(object: UIView) {
        let randomX = CGFloat.random(in: self.xBounds[0]...self.xBounds[1])
        let randomY = CGFloat.random(in: self.yBounds[0]...self.yBounds[1])
        
        //Code from https://developer.apple.com/documentation/corefoundation/cgrect
        object.frame.origin = CGPoint(x: randomX, y: randomY)
    }
}
