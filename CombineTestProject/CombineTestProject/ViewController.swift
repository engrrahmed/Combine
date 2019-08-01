//
//  ViewController.swift
//  CombineTestProject
//
//  Created by Rizwan Ahmed on 31/07/2019.
//  Copyright © 2019 Tintash. All rights reserved.
//

import UIKit
import Combine

class ViewController: UIViewController {
    
    @IBOutlet weak var showTextLabel        : UILabel!
    @IBOutlet weak var passwordTextField    : UITextField!
    @IBOutlet weak var confirmTextField     : UITextField!
    @IBOutlet weak var signUpButton         : UIButton!
    
    @Published var passwordText         : String = ""
    @Published var confirmPasswordText  : String = ""
    
    private var passwordSubscription: AnyCancellable?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        passwordSubscription = $passwordText.sink {
            print("The published value is for password '\($0)'")
            self.showTextLabel.text = $0
        }
        
        //        $passwordText.receive(on: DispatchQueue.main).assign(to: \.isEnabled, on: signUpButton)
    }
    
    @IBAction func clickOnSignUpButton(_ sender: Any) {
        passwordText = "ABC"
        confirmPasswordText = "DGH"
    }
    
    @IBAction func didUpdatingPassword(_ sender: UITextField) {
        passwordText = sender.text ?? ""
    }
    
    @IBAction func setUserPassword(_ sender: UITextField) {
        passwordText = sender.text ?? ""
    }
    
    @IBAction func setConfirmPassword(_ sender: UITextField) {
        confirmPasswordText = sender.text ?? ""
    }
    
}
