//
//  MVVMSampleVM.swift
//  CombineTestProject
//
//  Created by Rizwan Ahmed on 05/08/2019.
//  Copyright © 2019 Tintash. All rights reserved.
//

import Foundation
import Combine
import UIKit

// Need to use Class because:
//'wrappedValue' is unavailable: @Published is only available on properties of classes
class MVVMSampleVM {
    
    @Published var passwordText         : String = ""
    @Published var confirmPasswordText  : String = ""
    
    func setupPasswordValidatorOnbutton() -> AnyPublisher<Bool, Never> {
        return Publishers.CombineLatest($passwordText, $confirmPasswordText)
            .map { (password, confirmedPassword) -> Bool in
                print("password: \(password) , confirmPassword : \(confirmedPassword)")
                guard password == confirmedPassword, password.count > 8 else { return true }
                return false
        }.eraseToAnyPublisher()
    }
}
