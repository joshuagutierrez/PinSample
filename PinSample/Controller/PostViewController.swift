//
//  PostViewController.swift
//  PinSample
//
//  Created by Josh Gutierrez on 10/28/22.
//  Copyright © 2022 Udacity. All rights reserved.
//

import UIKit
import CoreLocation

class PostViewController: UIViewController {

    @IBOutlet weak var location: UITextField!
    @IBOutlet weak var url: UITextField!
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    let geocoder = CLGeocoder()
    var address: CLPlacemark?

    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationBar()
        // Do any additional setup after loading the view.
    }
    
    // Setup navigation bar
    private func setupNavigationBar() {
        let cancelButton = UIBarButtonItem(title: "Cancel", style: UIBarButtonItem.Style.plain, target: self, action: #selector(didTapCancelButton))

        navigationItem.leftBarButtonItem = cancelButton
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "completeLocationSegue" {
            let detailVC = segue.destination as! LocationDetailViewController
            detailVC.placemark = address
            detailVC.url = url.text
        }
    }


    @IBAction func findLocation(_ sender: Any) {
        setForwardGeocoding(true)
        geocoder.geocodeAddressString(location.text!) { placemarks, error in
            guard let placemarks = placemarks else {
                DispatchQueue.main.async { [self] in
                      showGeocodeFailure(message: "Error finding location!")
                    self.setForwardGeocoding(false) 
                  }
               return
               }
            self.setForwardGeocoding(false)  //TODO: is this the correct place to stop the activity indicator?
            let placemark = placemarks.first
            self.address = placemark
               DispatchQueue.main.async {
                   let lat = placemark?.location?.coordinate.latitude
                   let lon = placemark?.location?.coordinate.longitude
                   print("Lat:: \(lat), Lon: \(lon)")
                  self.performSegue(withIdentifier: "completeLocationSegue", sender: self)
               }
        }

    }
    
    func showGeocodeFailure(message: String) {
        let alertVC = UIAlertController(title: "Geocode Error", message: message, preferredStyle: .alert)
        alertVC.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        self.present(alertVC, animated:true)
    }
    
    func setForwardGeocoding(_ forwardGeocoding: Bool) {
        if forwardGeocoding {
            activityIndicator.startAnimating()
        } else {
            activityIndicator.stopAnimating()
        }
        location.isEnabled = !forwardGeocoding
        url.isEnabled = !forwardGeocoding
//        loginButton.isEnabled = !loggingIn
    }
}
