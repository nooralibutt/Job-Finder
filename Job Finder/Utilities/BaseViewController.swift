//
//  BaseViewController.swift
//  Job Finder
//
//  Created by Noor Ali on 7/1/19.
//  Copyright © 2019 NAB. All rights reserved.
//

import UIKit

class BaseViewController: UIViewController {
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .default
    }
    
    private var progressHUD: ProgressHUD?
    
    var isProgressing: Bool {
        return self.progressHUD != nil
    }
    
    func showProgressHUD(text: String = "Loading") {
        DispatchQueue.main.async {
            self.view.isUserInteractionEnabled = false
            self.progressHUD = ProgressHUD(text: text)
            self.view.addSubview(self.progressHUD!)
        }
    }
    
    func hideProgressHUD() {
        guard let progressHUD = self.progressHUD else { return }
        
        DispatchQueue.main.async {
            self.view.isUserInteractionEnabled = true
            progressHUD.removeFromSuperview()
            self.progressHUD = nil
        }
    }
    
    func showAlert(message: String, title: String? = nil, action: UIAlertAction? = nil) {
        DispatchQueue.main.async {
            let alertController = UIAlertController(title: title,
                                                    message: message,
                                                    preferredStyle: .alert)
            
            alertController.addAction(action ?? UIAlertAction(title: "Okay", style: .default, handler: nil))
            
            self.present(alertController, animated: true, completion: nil)
        }
    }
}
