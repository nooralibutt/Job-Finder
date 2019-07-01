//
//  ApiResponse.swift
//  Job Finder
//
//  Created by Noor Ali on 7/1/19.
//  Copyright © 2019 NAB. All rights reserved.
//

import UIKit

struct ApiResponse {
    var isSuccess: Bool
    var message: String?
    var result: [Any]?
    
    init(_ json: [Any]) {
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

extension Job {
    init(title: String, companyName: String) {
        self.title = title
        self.companyName = companyName
        self.companyLogo = "https://jobs.github.com/rails/active_storage/blobs/eyJfcmFpbHMiOnsibWVzc2FnZSI6IkJBaHBBcDFxIiwiZXhwIjpudWxsLCJwdXIiOiJibG9iX2lkIn19--42c9a62cb6a553820e540af005c45a99a3a8c611/Logo1.png"
        self.location = "New York, New York, New York, 10019"
        self.detailURL = "https://jobs.github.com/positions/da153d56-c75e-48db-82ef-263196f164ae"
        self.postDate = "Thu Jun 27 14:39:22 UTC 2019"
    }
}
