//
//  ServiceProvider.swift
//  Job Finder
//
//  Created by Noor Ali on 7/1/19.
//  Copyright © 2019 NAB. All rights reserved.
//

import Foundation

protocol ServiceProvider {
    var name: String { get }
    var data: [Job]? { get set }
    
    func fetchData(position: String?, location: String?, completion: @escaping ([Job]?) -> ())
}
