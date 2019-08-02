//
//  SignUpUserViewController.swift
//  CombineTestProject
//
//  Created by Rizwan Ahmed on 02/08/2019.
//  Copyright © 2019 Tintash. All rights reserved.
//

import UIKit

import Combine
//import Publi
class SignUpUserViewController: UIViewController {
    
    @IBOutlet weak var showTextLabel        : UILabel!
    @IBOutlet weak var userNameTextField    : UITextField!
    @IBOutlet weak var passwordTextField    : UITextField!
    @IBOutlet weak var confirmTextField     : UITextField!
    @IBOutlet weak var signUpButton         : UIButton!
        
    var viewModel = SignUpViewModel()
    
    @Published var userName             : String = ""
    @Published var passwordText         : String = ""
    @Published var confirmPasswordText  : String = ""
    
    private var cancellableSet          : Set<AnyCancellable> = []
    
    private var validatedPassword1      : AnyCancellable?
    private var userNameSubscription    : AnyCancellable?
    private var validatedCredentials    : AnyCancellable?
    
//    private var validatedUsername       : AnyCancellable?
    
    var validatedPassword: AnyPublisher<String?, Never> {
        return Publishers.CombineLatest($passwordText, $passwordText)
            .receive(on: RunLoop.main)
            .map { passwordText, confirmPasswordText in
                guard confirmPasswordText == passwordText, passwordText.count > 5 else {
                    self.showTextLabel.text = "values must match and have at least 5 characters"
                    return nil
                }
                self.showTextLabel.text = ""
                return passwordText
            }.eraseToAnyPublisher()
    }
    
    var validatedUsername: AnyPublisher<String?, Never> {
        return $userName
            .debounce(for: 0.5, scheduler: RunLoop.main)
            .removeDuplicates()
            .flatMap { userName in
                return Future { promise in
                    self.viewModel.findUserIDFor(userId: userName) { available in
                        promise(.success(available ? userName : nil))
                    }
                }
        }
        .eraseToAnyPublisher()
    }
    
//    var validatedCredentials: AnyPublisher<(String, String)?, Never> {
//        return Publishers.CombineLatest(validatedUsername, validatedPassword) { username, password in
//            guard let uname = username, let pwd = password else { return nil }
//            return (uname, pwd)
//        }
//        .eraseToAnyPublisher()
//    }
    
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
        
        self.readyToSubmit
                 .map { $0 != nil }
                 .receive(on: RunLoop.main)
                 .assign(to: \.isHidden, on: signUpButton)
                 .store(in: &cancellableSet)
//         }
        
        
//        userNameSubscription = $userName.sink {
//            print("The published value is for password '\($0)'")
//            self.showTextLabel.text = $0
//            self.viewModel.findUserIDFor(userId: $0) { isUserfound in
//                print("is User found :\(isUserfound)" )
//            }
//        }
//
//
//
//        validatedPassword1 = Publishers.CombineLatest($passwordText, $confirmPasswordText)
//            .map { (password, confirmedPassword) -> Bool in
//                print("password: \(password) , confirmPassword : \(confirmedPassword)")
//                guard password == confirmedPassword, password.count > 8 else { return true }
//                return false
//        }.receive(on: DispatchQueue.main).assign(to: \.isHidden, on: signUpButton)
//
//        validatedCredentials =  Publishers.CombineLatest(validatedUsername, validatedPassword) { username, password in
//                   guard let uname = username, let pwd = password else { return nil }
//                   return (uname, pwd)
//               }
//               .eraseToAnyPublisher()
        
    }
    
    @IBAction func clickOnSignUpButton(_ sender: Any) {
        passwordText = "ABC"
    }
    
    @IBAction func didUpdatingPassword(_ sender: UITextField) {
        passwordText = sender.text ?? ""
    }
    
    @IBAction func setUserName(_ sender: UITextField) {
        userName = sender.text ?? ""
    }
    @IBAction func setUserPassword(_ sender: UITextField) {
        passwordText = sender.text ?? ""
    }
    
    @IBAction func setConfirmPassword(_ sender: UITextField) {
        confirmPasswordText = sender.text ?? ""
    }
}
