//
//  ApiResponse.swift
//  Job Finder
//
//  Created by Noor Ali on 7/1/19.
//  Copyright © 2019 NAB. All rights reserved.
//

struct ApiResponse {
    var isSuccess: Bool
    var message: String?
    var result: [String: Any]?
    
    init(_ json: [String: Any]) {
        self.isSuccess = true
        self.message = "Success"
        self.result = json
    }
    
    init(message: String? = nil) {
        self.isSuccess = false
        self.message = message
    }
}

struct Job {
    var companyLogo: String?
    var title: String?
    var companyName: String?
    var location: String?
    var postDate: String?
    var detailURL: String?
}
