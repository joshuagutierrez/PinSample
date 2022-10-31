//
//  StudentTableViewController.swift
//  PinSample
//
//  Created by Josh Gutierrez on 10/27/22.
//  Copyright © 2022 Udacity. All rights reserved.
//

import UIKit

class StudentTableViewController: UITableViewController {

    public func refresh() {
        tableView.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationBar()
        let locations = StudentsData.sharedInstance().students

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
    
    @objc func didTapRefreshButton() {
        //TODO: implement refresh button tap
//        OTMClient.getStudentLocation(completion: handleRefreshStudentsLocation(location:error:))
        
        _ = OTMClient.getStudentLocation() { studentLocations, error in
            if error == nil {
                StudentsData.sharedInstance().students = studentLocations
    //            self.tableView.reloadData()
                //TODO: this fixed the issue when I wouldn't see pins in the first load
                self.refresh()
            } else {
//                ViewController.showStudentLocationDownloadFailure(message: error?.localizedDescription ?? "")

            }
        }
    }
    
//    // Setup navigation bar
    private func setupNavigationBar() {
        navigationItem.title = "On The Map"
        let addButton   = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(didTapAddButton))
        let refreshButton = UIBarButtonItem(barButtonSystemItem: .refresh, target: self, action: #selector(didTapRefreshButton))
        let logoutButton = UIBarButtonItem(title: "Logout", style: UIBarButtonItem.Style.plain, target: self, action: #selector(didTapLogoutButton))

        navigationItem.rightBarButtonItems = [addButton, refreshButton]
        navigationItem.leftBarButtonItem = logoutButton
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return StudentsData.sharedInstance().students.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

     let cell = tableView.dequeueReusableCell(withIdentifier: "StudentTableViewCell", for: indexPath) as! StudentTableViewCell
     let locations = StudentsData.sharedInstance().students

     let location = locations[indexPath.row]
     cell.studentName?.text = (location.firstName ?? "") + (location.lastName ?? "")
        cell.url?.text = location.mediaURL ?? ""
     cell.pinImageView?.image = UIImage(named: "icon_pin")
        //TODO: get the correct image to load in table view

        return cell
    }
    

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let locations = StudentsData.sharedInstance().students
        
        let location = locations[indexPath.row]
        
        let app = UIApplication.shared
        if let toOpen = location.mediaURL {
            if URL(string: toOpen) != nil {
                app.openURL(URL(string: toOpen)!)
            }
        }
    }
    
//    // This delegate method is implemented to respond to taps. It opens the system browser
//    // to the URL specified in the annotationViews subtitle property.
//    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
//        if control == view.rightCalloutAccessoryView {
//            let app = UIApplication.shared
//            if let toOpen = view.annotation?.subtitle! {
//                app.openURL(URL(string: toOpen)!)
//            }
//        }
//    }
    
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
