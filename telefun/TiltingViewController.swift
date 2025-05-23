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
    
    @IBOutlet weak var ballView: UIView!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.hidesBackButton = true
        ballView.layer.cornerRadius = 25
        moveBall()
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
            }
        }
    }
}
