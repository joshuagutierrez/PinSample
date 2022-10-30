//
//  LocationDetailViewController.swift
//  PinSample
//
//  Created by Josh Gutierrez on 10/28/22.
//  Copyright © 2022 Udacity. All rights reserved.
//

import UIKit
import CoreLocation
import MapKit

class LocationDetailViewController: UIViewController, MKMapViewDelegate {
    
    var placemark: CLPlacemark?
    var url: String?
    var student: PostStudentRequest?

    @IBOutlet weak var mapView: MKMapView!
    
    @IBAction func finishPressed(_ sender: Any) {
        //when finish is tapped, we should post the student location
 
        
        if OTMClient.Auth.objectId == "" {
            OTMClient.postStudentLocation(student: student!, completion: handlePostStudentResponse(success:error:))
        } else {
            //if we already have an existing objectId, we should not call a fresh post. we should call a put to update the existing object
            OTMClient.putStudentLocation(student: student!, completion: handlePostStudentResponse(success:error:))
        }
        
        

    }
    
    //      This func was previously named handleSessionResponse
        func handlePostStudentResponse(success: Bool, error: Error?) {
    //        setLoggingIn(false)
            if success {
                DispatchQueue.main.async {
                    self.dismiss(animated: true, completion: nil)
                }
//                OTMClient.getUserData(completion: handleUserDataResponse(success:error:))
//                performSegue(withIdentifier: "completeLogin", sender: nil)
            } else {
    //            showLoginFailure(message: error?.localizedDescription ?? "")
            }
        }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "Add Location" //this is what causes the back button to go from add location to back. its overriding the back button. may not be desired
        

        // Do any additional setup after loading the view.
        
        // Notice that the float values are being used to create CLLocationDegree values.
        // This is a version of the Double type.
        let lat = CLLocationDegrees(placemark?.location?.coordinate.latitude ?? 0)
        let long = CLLocationDegrees(placemark?.location?.coordinate.longitude ?? 0)
        
        // The lat and long are used to create a CLLocationCoordinates2D instance.
        let coordinate = CLLocationCoordinate2D(latitude: lat, longitude: long)
        
        let locality = placemark?.locality ?? ""
        let adminsistrativeArea = placemark?.administrativeArea ?? ""
        let country = placemark?.country ?? ""
        
        // Here we create the annotation and set its coordiate, title, and subtitle properties
        let annotation = MKPointAnnotation()
        annotation.coordinate = coordinate
        annotation.title = "\(locality), \(adminsistrativeArea), \(country)"
        annotation.subtitle = ""
        
        var annotations = [MKPointAnnotation]()
        // Finally we place the annotation in an array of annotations.
        annotations.append(annotation)
        
        student = PostStudentRequest(uniqueKey: OTMClient.Auth.userId, firstName: OTMClient.Auth.firstName, lastName: OTMClient.Auth.lastName, mapString: annotation.title, mediaURL: url, latitude: lat, longitude: long)
    
    
        // When the array is complete, we add the annotations to the map.
        DispatchQueue.main.async {
            self.mapView.addAnnotations(annotations)
        }
    }
    

    // MARK: - MKMapViewDelegate

    // Here we create a view with a "right callout accessory view". You might choose to look into other
    // decoration alternatives. Notice the similarity between this method and the cellForRowAtIndexPath
    // method in TableViewDataSource.
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        
        let reuseId = "pin"
        
        var pinView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseId) as? MKPinAnnotationView

        if pinView == nil {
            pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
            pinView!.canShowCallout = true
            pinView!.pinColor = .red
            pinView!.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
        }
        else {
            pinView!.annotation = annotation
        }
        
        return pinView
    }

    
    // This delegate method is implemented to respond to taps. It opens the system browser
    // to the URL specified in the annotationViews subtitle property.
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        if control == view.rightCalloutAccessoryView {
            let app = UIApplication.shared
            if let toOpen = view.annotation?.subtitle! {
                app.openURL(URL(string: toOpen)!)
            }
        }
    }

}
