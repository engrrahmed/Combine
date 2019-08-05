//
//  Sample1VC.swift
//  CombineTestProject
//
//  Created by Rizwan Ahmed on 01/08/2019.
//  Copyright © 2019 Tintash. All rights reserved.
//

import UIKit
import Combine
//import Publi
class Sample1VC: UIViewController {
    
    @IBOutlet weak var showTextLabel        : UILabel!
    @IBOutlet weak var passwordTextField    : UITextField!
    @IBOutlet weak var confirmTextField     : UITextField!
    @IBOutlet weak var signUpButton         : UIButton!
    
    
    @Published var passwordText         : String = ""
    @Published var confirmPasswordText  : String = ""
    private var validatedCredentials    : AnyCancellable?
    
    
    
    private var passwordSubscription: AnyCancellable?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        validatedCredentials = Publishers.CombineLatest($passwordText, $confirmPasswordText)
            .map { (password, confirmedPassword) -> Bool in
                print("password: \(password) , confirmPassword : \(confirmedPassword)")
                guard password == confirmedPassword, password.count > 8 else { return true }
                return false
        }.receive(on: DispatchQueue.main).assign(to: \.isHidden, on: signUpButton)
        //        sink { isInValidPassword in
        //            print("IS Valid PASSWORD: \(isValidPassword)")
        //
        //        }
    }
    
    @IBAction func clickOnSignUpButton(_ sender: Any) {
        passwordText = "ABC"
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



