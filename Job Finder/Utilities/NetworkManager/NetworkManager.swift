//
//  NetworkManager.swift
//  Job Finder
//
//  Created by Noor Ali on 7/1/19.
//  Copyright © 2019 NAB. All rights reserved.
//

import Foundation
import UIKit

class NetworkManager {
    fileprivate enum NetworkResponse:String {
        case success
        case authenticationError = "Unfortunately we encountered an error."
        case badRequest = "Bad request"
        case outdated = "The url you requested is outdated."
        case noInternet = "Please check your Internet Connection"
        case noData = "Response returned with no data."
        case unableToDecode = "We could not decode the response."
        case somethingWrong = "Something went wrong please try again."
        case userNameOrPass = "User name or password incorrect."
    }
    
    fileprivate enum Result<String>{
        case success
        case failure(String)
    }
    
    fileprivate class func handleNetworkResponse(_ response: HTTPURLResponse) -> Result<String> {
        switch response.statusCode {
        case 200...299: return .success
        case 401...500: return .failure(NetworkResponse.authenticationError.rawValue)
        case 501...599: return .failure(NetworkResponse.badRequest.rawValue)
        case 600: return .failure(NetworkResponse.outdated.rawValue)
        default: return .failure(NetworkResponse.authenticationError.rawValue)
        }
    }
    
    fileprivate class func processResponse(data: Data?, response: URLResponse?, responseError: Error?, completion: @escaping (ApiResponse?) -> ()) {
        DispatchQueue.main.async { UIApplication.shared.isNetworkActivityIndicatorVisible = false }
        
        guard responseError == nil else {
            completion(ApiResponse(message: responseError?.localizedDescription))
            return
        }
        
        guard let responseData = data else {
            completion(ApiResponse(message: NetworkResponse.noData.rawValue))
            return
        }
        
        guard let json = (try? JSONSerialization.jsonObject(with: responseData, options: JSONSerialization.ReadingOptions.mutableContainers)) as? [Any] else {
            print("Not containing JSON")
            completion(ApiResponse(message: NetworkResponse.noData.rawValue))
            return
        }
        
        completion(ApiResponse(json))
    }
    
    //MARK:- Network Calls
    // Netwrok Call with URL Sessions
    class func fetchGenericData(urlString: String, paramsBag: [String: String], completion: @escaping (ApiResponse?) -> ()) {
        if Connectivity.isConnectedToInternet {
            UIApplication.shared.isNetworkActivityIndicatorVisible = true
            
            guard let urlComp = NSURLComponents(string: urlString) else { return }
            var items = [URLQueryItem]()
            for (key,value) in paramsBag {
                items.append(URLQueryItem(name: key, value: value))
            }
            items = items.filter{!$0.name.isEmpty}
            if !items.isEmpty {
                urlComp.queryItems = items
            }
            var urlRequest = URLRequest(url: urlComp.url!)
            
            urlRequest.httpMethod = "GET"
            
            URLSession.shared.dataTask(with: urlRequest) { (data, response, responseError) in
                NetworkManager.processResponse(data: data, response: response, responseError: responseError, completion: completion)
                }.resume()
        } else {
            completion(ApiResponse(message: NetworkResponse.noInternet.rawValue))
        }
    }
}
