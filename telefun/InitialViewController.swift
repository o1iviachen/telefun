//
//  InitialViewController.swift
//  telefun
//
//  Created by olivia chen on 2025-05-27.
//

import UIKit

class InitialViewController: UIViewController {
    
    @IBOutlet weak var phoneTextField: UITextField!
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "confirmSegue" {
            let destinationVC = segue.destination as! TiltingViewController
            destinationVC.phoneNumber = phoneTextField.text
        }
    }
    
    @IBAction func submitButton(_ sender: UIButton) {
        if let phoneText = phoneTextField.text {
            if phoneText.isInt && phoneText.count == 10 {
                performSegue(withIdentifier: "confirmSegue", sender: self)
            }
        }
    }
}

extension String {
    var isInt: Bool {
        return Int(self) != nil
    }
}
