//
//  APIConfig.swift
//  CombineTestProject
//
//  Created by Rizwan Ahmed on 01/08/2019.
//  Copyright © 2019 Tintash. All rights reserved.
//

import Foundation

struct APIConfig {
    static let basePath  = "https://www.flickr.com/services/rest/?"
    static let apiKey     = "a411522442e5c07d1353215de1719320"
    static let findUserName  = "method=flickr.people.findByUsername"
    
    
}

struct APIPath {
    static let findUser = APIConfig.basePath + "method=flickr.people.findByUsername&api_key=\(APIConfig.apiKey)&username=jkfsjkfbskjfb&format=json&nojsoncallback=1"
}
