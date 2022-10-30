//
//  TabBarController.swift
//  PinSample
//
//  Created by Josh Gutierrez on 10/29/22.
//  Copyright © 2022 Udacity. All rights reserved.
//

import UIKit

class TabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
//        setupNavigationBar()
        // Do any additional setup after loading the view.
    }
    
    // Setup navigation bar
//    private func setupNavigationBar() {
//        navigationItem.title = "On The Map"
//        let addButton   = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(didTapAddButton))
//        let refreshButton = UIBarButtonItem(barButtonSystemItem: .refresh, target: self, action: #selector(didTapRefreshButton))
//        let logoutButton = UIBarButtonItem(title: "Logout", style: UIBarButtonItem.Style.plain, target: self, action: #selector(didTapLogoutButton))
//
//        navigationItem.rightBarButtonItems = [addButton, refreshButton]
//        navigationItem.leftBarButtonItem = logoutButton
//    }
    
//    @objc func didTapRefreshButton() {
//        //TODO: implement refresh button tap
//        OTMClient.getStudentLocation(completion: handleRefreshStudentsLocation(location:error:))
//
//    }
    

    func handleRefreshStudentsLocation(location: [StudentLocations], error: Error?){
        if let error = error {
//            showAlert(ofType: .retrieveUsersLocationFailed, message: error.localizedDescription)
        } else {
            StudentsData.sharedInstance().students = location
        }
        
        for childViewController in self.children {
            if let mapViewController = childViewController as? ViewController {
                mapViewController.refresh()
            }
            else if let tableViewController = childViewController as? StudentTableViewController {
                tableViewController.refresh()
            }
        }
    }

}
