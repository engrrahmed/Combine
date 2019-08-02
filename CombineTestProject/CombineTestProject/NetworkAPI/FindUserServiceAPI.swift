//
//  FindUserServiceAPI.swift
//  CombineTestProject
//
//  Created by Rizwan Ahmed on 02/08/2019.
//  Copyright © 2019 Tintash. All rights reserved.
//

import Foundation
protocol FindUserServiceAPI : NetworkEngine {
    func findUserID(userId:String, completion: @escaping (Data?, String?) -> Void)    
}

extension FindUserServiceAPI {
    func findUserID(userId:String, completion: @escaping (Data?, String?) -> Void) {
        
        fetchAPI(searchPath: userId, success: { (response, error) in
            if let responseData = response?.result.value {
                completion(responseData, error)
            }
            else {
                completion(nil, error)
            }
            
        }) { (errorString) in
            print("API Error: \(errorString)")
        }
    }
}
