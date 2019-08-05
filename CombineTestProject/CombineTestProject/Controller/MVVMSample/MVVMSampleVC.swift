//
//  MVVMSampleVC.swift
//  CombineTestProject
//
//  Created by Rizwan Ahmed on 05/08/2019.
//  Copyright © 2019 Tintash. All rights reserved.
//

import UIKit
import Combine

class MVVMSampleVC: UIViewController {
    
    @IBOutlet weak var showTextLabel        : UILabel!
    @IBOutlet weak var passwordTextField    : UITextField!
    @IBOutlet weak var confirmTextField     : UITextField!
    @IBOutlet weak var signUpButton         : UIButton!
    
    var viewModel:MVVMSampleVM          = MVVMSampleVM()
    
    private var validatedCredentials    : AnyCancellable?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
     validatedCredentials = viewModel.setupPasswordValidatorOnbutton()
        .receive(on: DispatchQueue.main)
        .sink { [weak self] isInValidPassword in
            print("IS Valid PASSWORD: \(isInValidPassword)")
            self?.signUpButton.isHidden = isInValidPassword
            self?.showTextLabel.isHidden = !isInValidPassword
        }
        //        .assign(to: \.isHidden, on: signUpButton)
    }
    
    @IBAction func clickOnSignUpButton(_ sender: Any) {
        viewModel.passwordText = "ABC"
    }
    
    @IBAction func didUpdatingPassword(_ sender: UITextField) {
        viewModel.passwordText = sender.text ?? ""
    }
    
    @IBAction func setUpdatingConfirmPassword(_ sender: UITextField) {
        viewModel.confirmPasswordText = sender.text ?? ""
    }
}
