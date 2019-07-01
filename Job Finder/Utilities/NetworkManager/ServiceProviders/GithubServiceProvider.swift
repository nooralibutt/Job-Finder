//
//  GithubServiceProvider.swift
//  Job Finder
//
//  Created by Noor Ali on 7/1/19.
//  Copyright © 2019 NAB. All rights reserved.
//

import UIKit

struct GithubServiceProvider: ServiceProvider {
    // 1: Change name
    var name: String { return "Git Hub" }
    var data: [Job]?
    
    func fetchData(position: String?, location: String?, completion: @escaping ([Job]?) -> ()) {
        // 2: Provide base URL
        var baseURL = "https://jobs.github.com/positions.json"
        
        // 3: Provide your own query system
        var params: String = ""
        if let position = position, !position.isEmpty, let encodedPosition = position.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) {
            params = "?description=\(encodedPosition)"
        }
        
        if let location = location, !location.isEmpty, let encodedLocation = location.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) {
            if params.isEmpty {
                params = "?location=\(encodedLocation)"
            } else {
                params = "&location=\(encodedLocation)"
            }
        }
        
        baseURL += params
        print(baseURL)
        NetworkManager.fetchGenericData(urlString: baseURL, paramsBag: [:]) { (response) in
            guard let jsonJobsArray = response?.result else {
                completion([])
                return
            }

            var jobArray: [Job] = []
            
            jsonJobsArray.forEach({ (jobAny) in
                if let dict = jobAny as? [String: Any] {
                    jobArray.append(self.parseResponse(json: dict))
                }
            })
            
            completion(jobArray)
        }
    }
    
    // 4: Provide your own parsing
    func parseResponse(json: [String: Any]) -> Job {
        
        let title = json["title"] as? String
        let companyName = json["company"] as? String
        var postDate = json["created_at"] as? String // Mon Jul 01 09:24:56 UTC 2019
        let detailURL = json["url"] as? String
        let companyLogo = json["company_logo"] as? String
        let location = json["location"] as? String
        
        let dateFormatterGet = DateFormatter()
        dateFormatterGet.dateFormat = "EEE MMM dd HH:mm:ss zzz yyyy"
        
        let dateFormatterPrint = DateFormatter()
        dateFormatterPrint.dateFormat = "dd/MM/yyyy"
        
        if let serverData = postDate, let newDate = dateFormatterGet.date(from: serverData) {
            postDate = dateFormatterPrint.string(from: newDate)
        }
        
        return Job(companyLogo: companyLogo, title: title, companyName: companyName, location: location, postDate: postDate, detailURL: detailURL)
    }
}
