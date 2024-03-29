//
//  SignUpUserVC.swift
//  CombineTestProject
//
//  Created by Rizwan Ahmed on 02/08/2019.
//  Copyright © 2019 Tintash. All rights reserved.
//

import UIKit

import Combine
//import Publi
class SignUpUserVC: UIViewController {
    
    @IBOutlet weak var passwordErrorLabel   : UILabel!
    @IBOutlet weak var userNotFoundLabel    : UILabel!
    @IBOutlet weak var userNameTextField    : UITextField!
    @IBOutlet weak var passwordTextField    : UITextField!
    @IBOutlet weak var confirmTextField     : UITextField!
    @IBOutlet weak var signUpButton         : UIButton!
    
    var viewModel = SignUpViewModel()
    
    @Published var userName             : String = ""
    @Published var passwordText         : String = ""
    @Published var confirmPasswordText  : String = ""
    
    private var cancellableSet          : Set<AnyCancellable> = []
    
    var validatedPassword: AnyPublisher<String?, Never> {
        return Publishers.CombineLatest($passwordText, $confirmPasswordText)
            .receive(on: RunLoop.main)
            .map { passwordText, confirmPasswordText -> String? in
                guard confirmPasswordText == passwordText, passwordText.count > 5 else {
                    self.passwordErrorLabel.text = "values must match and have at least 5 characters"
                    return nil
                }
                self.passwordErrorLabel.text = ""
                return passwordText
        }.map { $0 == "password1"  ? nil : $0}
            /* //Adding Break point for the debugging purpose
            .breakpoint( receiveOutput: { (test) -> Bool in
                print(test)
                if (test == "rizwan") { return true}
                return false
            })
            */
            .eraseToAnyPublisher()
    }
    
    var validatedUsername: AnyPublisher<String?, Never> {
        return $userName
            .debounce(for: 0.5, scheduler: RunLoop.main)
            //            .throttle(for: 0.5, scheduler: RunLoop.main, latest: true)
            .removeDuplicates()
            .filter { stringValue in return stringValue != ""}
            .flatMap { userName in
                return Future { promise in //(Result<Output, Failure>) -> Void
                    self.viewModel.findUserIDFor(userId: userName) { available in
                        self.userNotFoundLabel.isHidden = available
                        promise(.success(available ? userName : nil))
                    }
                }
        }
        .eraseToAnyPublisher()
    }
    
    var readyToSubmit: AnyPublisher<(String, String)?, Never> {
        return Publishers.CombineLatest(validatedUsername, validatedPassword)
            .map { value2, value1 in
                guard let realValue2 = value2, let realValue1 = value1 else {
                    return nil
                }
                return (realValue2, realValue1)
        }
        .eraseToAnyPublisher()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        signUpButton.setTitleColor(.red, for: .disabled)
        signUpButton.setTitleColor(.white, for: .normal)
        self.readyToSubmit
            .map { $0 != nil }
            .receive(on: RunLoop.main)
//            .replaceError(with: false)
//            .sink { (valid) in
//                print("CombineLatest: Are the credentials valid: \(valid)")
//        }
            .assign(to: \.isEnabled, on: signUpButton)
            .store(in: &cancellableSet)
    }
    
    @IBAction func clickOnSignUpButton(_ sender: Any) {
        
    }

    @IBAction func userNameChanged(_ sender: UITextField) {
        userName = sender.text ?? ""
    }
    @IBAction func userPasswordChanged(_ sender: UITextField) {
        passwordText = sender.text ?? ""
    }
    
    @IBAction func confirmPasswordChanged(_ sender: UITextField) {
        confirmPasswordText = sender.text ?? ""
    }
}
