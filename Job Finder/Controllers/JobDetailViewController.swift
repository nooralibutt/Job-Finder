//
//  JobDetailViewController.swift
//  Job Finder
//
//  Created by Noor Ali on 7/1/19.
//  Copyright © 2019 NAB. All rights reserved.
//

import UIKit
import WebKit

// Add WKWebView programmatically
class JobDetailViewController: UIViewController {
    
    var detailURLString: String!
    
    private var webView: WKWebView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // init webView
        webView = WKWebView(frame: view.bounds)
        view.addSubview(webView!)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // load url
        webView?.loadUrl(string: detailURLString)
    }
}

extension WKWebView {
    func loadUrl(string: String) {
        if let url = URL(string: string) {
            load(URLRequest(url: url))
        }
    }
}
