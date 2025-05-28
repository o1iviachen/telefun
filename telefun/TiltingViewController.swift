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
    var phoneNumber: String? = nil
    var phoneNumberCharacters: [Character] = []
    var counter: Int = 0
    var xBounds: CGFloat? = nil
    var yBounds: CGFloat? = nil
    
    @IBOutlet weak var emilyPhoto: UIImageView!
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
//        print(UIScreen.main.bounds)
    }
    
    override func viewDidLayoutSubviews() {
        // Code from https://developer.apple.com/documentation/corefoundation/cgrect/size
        self.xBounds = view.safeAreaLayoutGuide.layoutFrame.size.width
        self.yBounds = view.safeAreaLayoutGuide.layoutFrame.size.height
    }
    
    func moveBall() {
        if motionManager.isAccelerometerAvailable {
            motionManager.accelerometerUpdateInterval = 0.02
            
            // Code from https://developer.apple.com/documentation/coremotion/cmmotionmanager/startaccelerometerupdates()
            motionManager.startAccelerometerUpdates(to: .main) { data, error in
                if let data = data {
                    let acceleration = data.acceleration
                    var ballCenter = self.ballView.center
                    let speed = 20.0
                    ballCenter.x += CGFloat(acceleration.x) * speed
                    ballCenter.y -= CGFloat(acceleration.y) * speed
                    self.ballView.center = ballCenter
                }
                self.checkCollision(object1: self.ballView, object2: self.numberLabel, type: "number")
            }
        }
    }
    
    func checkCollision(object1: UIView, object2: UIView, type: String) {
        //Code from https://developer.apple.com/documentation/uikit/uiview/frame
        let coordinate1 = object1.frame
        let coordinate2 = object2.frame
        
        // Code from https://developer.apple.com/documentation/corefoundation/cgrect/intersects(_:)
        if coordinate1.intersects(coordinate2) {
            if type == "number" {
                updateScreen()
            }
            else {
                //hit image -> restart
            }
        }
    }
    
    func updateScreen() {
        if counter < 9 {
            self.counter += 1
            self.numberLabel.text = String(self.phoneNumberCharacters[counter])
            randomPosition(object: self.numberLabel)
        }
        else {
            print("done")
        }
    }
    
    func randomPosition(object: UIView) {
        let randomX = CGFloat.random(in: 0...self.xBounds!)
        let randomY = CGFloat.random(in: 0...self.yBounds!)
        
        //Code from https://developer.apple.com/documentation/corefoundation/cgrect
        object.frame.origin = CGPoint(x: randomX, y: randomY)
    }
}
