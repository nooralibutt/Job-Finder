//
//  JobsListingController.swift
//  Job Finder
//
//  Created by Noor Ali on 7/1/19.
//  Copyright © 2019 NAB. All rights reserved.
//

import UIKit

class JobsListingController: BaseViewController {
    @IBOutlet weak var tableView: UITableView!
    
    private var dummyDataSource: [Job]?
    
    override func viewDidLoad() {
        self.configureTableView()
        self.hitSearchAPI()
    }
    
    @IBAction func onClickConnect(_ sender: UIButton) {
        DispatchQueue.main.async {
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    @IBAction func onClickSkip(_ sender: UIButton) {
        DispatchQueue.main.async {
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    private func hitSearchAPI() {
        self.showProgressHUD()
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            self.hideProgressHUD()
            
            let count = Int.random(in: 0..<5)
            
            self.dummyDataSource = []
            
            var campaign = Job(title: "Data Scientist - Microscopy Image Analysis", companyName: "New York Stem Cell Foundation")
            for i in 0..<count {
                campaign.title = campaign.title! + " \(i)"
                self.dummyDataSource?.append(campaign)
            }
            
            self.reloadTableView()
        }
    }
}

extension JobsListingController: UITableViewDataSource, UITableViewDelegate {
    func configureTableView() {
        DispatchQueue.main.async {
            self.tableView.separatorStyle = .none
            self.tableView.dataSource = self
            self.tableView.delegate = self
            
            self.tableView.rowHeight = UITableView.automaticDimension
            self.tableView.estimatedRowHeight = 150
            
            self.tableView.register(UINib(nibName: JobTableViewCell.identifier(), bundle: nil), forCellReuseIdentifier: JobTableViewCell.identifier())
            
            self.tableView.reloadData()
        }
    }
    
    func reloadTableView() {
        DispatchQueue.main.async {
            self.tableView.reloadData()
            
            let count = self.dummyDataSource?.count ?? 0
            if count <= 0 {
                self.EmptyMessage(message: "No jobs for specified filters")
            }
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let count = dummyDataSource?.count ?? 0
        
        if count > 0 {
            DispatchQueue.main.async { self.tableView.backgroundView = nil }
        }
        
        return count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: JobTableViewCell.identifier(), for: indexPath) as! JobTableViewCell
        
        cell.titleLabel.text = self.dummyDataSource?[indexPath.row].title
        cell.companyNameLabel.text = self.dummyDataSource?[indexPath.row].companyName
        cell.locationLabel.text = self.dummyDataSource?[indexPath.row].location
        cell.timeStampLabel.text = self.dummyDataSource?[indexPath.row].postDate
        
        cell.profileImageView.image = #imageLiteral(resourceName: "ic_demo_person.pdf")
        cell.tag = indexPath.row
        
        if let logo = self.dummyDataSource?[indexPath.row].companyLogo, let imageURL = URL(string: logo) {
            let task = URLSession.shared.dataTask(with: imageURL) { data, response, error in
                guard let data = data, error == nil else { return }
                
                DispatchQueue.main.async() {
                    if cell.tag == indexPath.row {
                        cell.profileImageView.image = UIImage(data: data)
                    }
                }
            }
            task.resume()
        }
        
        return cell
    }
    
    func EmptyMessage(message:String) {
        let rect = CGRect(origin: CGPoint(x: 0,y :0), size: CGSize(width: self.view.bounds.size.width, height: self.view.bounds.size.height))
        let messageLabel = UILabel(frame: rect)
        messageLabel.text = message
        messageLabel.textColor = UIColor.black
        messageLabel.numberOfLines = 0
        messageLabel.textAlignment = .center
        messageLabel.font = UIFont(name: "TrebuchetMS", size: 15)
        messageLabel.sizeToFit()
        
        self.tableView.backgroundView = messageLabel
        self.tableView.separatorStyle = .none
    }
}
