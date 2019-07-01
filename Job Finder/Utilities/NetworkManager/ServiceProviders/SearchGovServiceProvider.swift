//
//  SearchGovServiceProvider.swift
//  Job Finder
//
//  Created by Noor Ali on 7/1/19.
//  Copyright © 2019 NAB. All rights reserved.
//

import UIKit

struct SearchGovServiceProvider: ServiceProvider {
    // 1: Change name
    var name: String { return "Search.Gov" }
    var data: [Job]?
    
    func fetchData(position: String?, location: String?, completion: @escaping ([Job]?) -> ()) {
        // 2: Provide base URL
        var baseURL = "https://jobs.search.gov/jobs/search.json"
        
        // 3: Provide your own query system
        var params: String = ""
        if let position = position, !position.isEmpty, let encodedPosition = position.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) {
            params = "?query=\(encodedPosition)"
        }
        
        if let location = location, !location.isEmpty, let encodedLocation = location.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) {
            if params.isEmpty {
                params = "?query=\(encodedLocation)"
            } else {
                params = "+in+\(encodedLocation)"
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
        let title = json["position_title"] as? String
        let companyName = json["organization_name"] as? String
        var postDate = json["start_date"] as? String // Mon Jul 01 09:24:56 UTC 2019
        let detailURL = json["url"] as? String
        let companyLogo = json["company_logo"] as? String
        let locations = json["locations"] as? [String]
        
        let dateFormatterGet = DateFormatter()
        dateFormatterGet.dateFormat = "yyyy-MM-dd"
        
        let dateFormatterPrint = DateFormatter()
        dateFormatterPrint.dateFormat = "dd/MM/yyyy"
        
        if let serverData = postDate, let newDate = dateFormatterGet.date(from: serverData) {
            postDate = dateFormatterPrint.string(from: newDate)
        }
        
        return Job(companyLogo: companyLogo, title: title, companyName: companyName, location: locations?.first, postDate: postDate, detailURL: detailURL)
    }
}
