//
//  NetworkAPI.swift
//  CombineTestProject
//
//  Created by Rizwan Ahmed on 01/08/2019.
//  Copyright © 2019 Tintash. All rights reserved.
//

import Foundation
import Alamofire

protocol NetworkEngine {
    
    typealias success<RESULT>   = (([RESULT])->Void)?
    typealias failure          = ((String)->Void)?
}
extension NetworkEngine {
    
    private func flickrSearchURLForSearchTerm(_ searchTerm:String) -> URL? {
        
        if let escapedTerm = searchTerm.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) {
            let URLString = APIConfig.basePath + "method=flickr.people.findByUsername&api_key=\(APIConfig.apiKey)&username=\(escapedTerm)&format=json&nojsoncallback=1"
            return URL(string: URLString)
        }
        return nil
    }
    
    func fetchAPI<RESULT: Decodable> (searchPath     : String,
                                      success        : success<RESULT>,
                                      failure        : failure) {
        guard let url = self.flickrSearchURLForSearchTerm(searchPath) else {
            return
        }
        Alamofire.request(url, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: nil).response {  response in
            //Unauthorized, token expired or invalid
            print("GET URL Call")
            if response.response?.statusCode == 401 {
                //            success(response.data)
            }
        }
    }
}