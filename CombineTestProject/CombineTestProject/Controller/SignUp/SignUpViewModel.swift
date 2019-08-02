//
//  SignUpViewModel.swift
//  CombineTestProject
//
//  Created by Rizwan Ahmed on 02/08/2019.
//  Copyright © 2019 Tintash. All rights reserved.
//

import Foundation
struct SignUpViewModel:FindUserServiceAPI {
    
}
extension SignUpViewModel {
    func findUserIDFor(userId: String,  completion: @escaping(Bool) -> Void) {
        findUserID(userId: userId) { (response, error) in
            if let responseData = response {
                //CHEKC IF USER IS  exist or not
                // if stat =  ok and code is nil than user is found
                if let userFoundModel = try? JSONDecoder().decode(UserFoundModel.self, from: responseData) {
                    if userFoundModel.stat == "ok" && userFoundModel.code == nil {
                        print("user Found")
                        completion(true)
                    }else {
                        print("user Not Found")
                        completion(false)
                    }
                }
            }
        }
        
    }
    
}

