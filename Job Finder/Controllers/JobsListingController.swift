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
    
    @IBOutlet weak var locationTextField: UITextField!
    @IBOutlet weak var positionTextField: UITextField!
    @IBOutlet weak var providerButton: UIButton!
    
    private var jobModels: [Job]?
    private var providers: [ServiceProvider] = []
    private var alert: UIAlertController!
    
    override func viewDidLoad() {
        self.configureTableView()
        
        // COnfiguring service providers
        self.configureProviderArray()
    }
    
    @IBAction func onClickProviderFilter(_ sender: UIButton) {
        self.present(alert, animated: true, completion: {
            print("completion block")
        })
    }
    
    private func hitSearchAPI() {
        self.showProgressHUD()
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            self.hideProgressHUD()
            
            let count = Int.random(in: 0..<5)
            
            self.jobModels = []
            
            var campaign = Job(title: "Data Scientist - Microscopy Image Analysis", companyName: "New York Stem Cell Foundation")
            for i in 0..<count {
                campaign.title = campaign.title! + " \(i)"
                self.jobModels?.append(campaign)
            }
            
            self.reloadTableView()
        }
    }
    
    func configureProviderArray() {
        // Add provider here
        providers = [GithubServiceProvider(data: nil), SearchGovServiceProvider(data: nil)]
        
        providerButton.setTitle(providers[0].name, for: .normal)
        self.showProgressHUD()
        providers[0].fetchData(position: nil, location: nil, completion: { (jobs) in
            self.jobModels = jobs
            self.reloadTableView()
            self.hideProgressHUD()
        })
        
        alert = UIAlertController(title: "Select Provider", message: nil, preferredStyle: .actionSheet)
        
        let providerArray = providers.map({ $0.name })
        for providerString in providerArray {
            alert.addAction(UIAlertAction(title: providerString, style: .default , handler:{ (action) in
                guard let title = action.title, let index = providerArray.firstIndex(of: title) else { return }
                
                self.providerButton.setTitle(title, for: .normal)
                
                self.showProgressHUD()
                self.providers[index].fetchData(position: self.positionTextField.text, location: self.locationTextField.text, completion: { (jobs) in
                    self.jobModels = jobs
                    self.reloadTableView()
                    self.hideProgressHUD()
                })
            }))
        }
        
        alert.addAction(UIAlertAction(title: "Dismiss", style: .cancel, handler:{ (UIAlertAction)in
            print("User click Dismiss button")
        }))
    }
}

extension JobsListingController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        return true
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
            
            let count = self.jobModels?.count ?? 0
            if count <= 0 {
                self.EmptyMessage(message: "No jobs for specified filters")
            }
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let count = jobModels?.count ?? 0
        
        if count > 0 {
            DispatchQueue.main.async { self.tableView.backgroundView = nil }
        }
        
        return count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: JobTableViewCell.identifier(), for: indexPath) as! JobTableViewCell
        
        cell.titleLabel.text = self.jobModels?[indexPath.row].title
        cell.companyNameLabel.text = self.jobModels?[indexPath.row].companyName
        cell.locationLabel.text = self.jobModels?[indexPath.row].location
        cell.timeStampLabel.text = self.jobModels?[indexPath.row].postDate
        
        cell.profileImageView.image = #imageLiteral(resourceName: "ic_demo_person.pdf")
        cell.tag = indexPath.row
        
        if let logo = self.jobModels?[indexPath.row].companyLogo, let imageURL = URL(string: logo) {
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
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let jobDetailVC = JobDetailViewController()
        jobDetailVC.detailURLString = self.jobModels?[indexPath.row].detailURL
        self.navigationController?.pushViewController(jobDetailVC, animated: true)
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
