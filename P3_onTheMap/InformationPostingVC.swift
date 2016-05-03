//
//  InformationPostingView.swift
//

import UIKit
import MapKit
import CoreLocation

class InformationPostingVC: UIViewController {
    
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var linkTextField: UITextField!
    @IBOutlet weak var locationTextField: UITextField!
    @IBOutlet weak var saveButton: UIButton!
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var findOnMapButton: UIButton!
    @IBOutlet weak var browseButton: UIButton!
    
    
    // Map Variables
    var annotation:MKAnnotation!
    var localSearchRequest:MKLocalSearchRequest!
    var localSearch:MKLocalSearch!
    var localSearchResponse:MKLocalSearchResponse!
    var error:NSError!
    var pointAnnotation:MKPointAnnotation!
    var pinAnnotationView:MKPinAnnotationView!
    
    var udacity: UdacityClient! // grab our clients
    var parse: ParseMngr!
    
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        udacity = UdacityClient.sharedInstance()
        parse = ParseMngr.sharedInstance()
        
    }
    
    func searchForLocationDisplayOnMap() {
        
        // Check that there is text in the text field
        if locationTextField == nil  || locationTextField.text == "" {
            displayError(self, errorString: "Enter an address or place")
            return
        }
        
        // setup activity view
        let activityViewIndicator : UIActivityIndicatorView = UIActivityIndicatorView(frame: CGRectMake(0,0, 50, 50)) as UIActivityIndicatorView
        activityViewIndicator.center = self.view.center
        activityViewIndicator.hidesWhenStopped = true
        activityViewIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.Gray
        
        // start spinning activityView
        view.addSubview(activityViewIndicator)
        activityViewIndicator.startAnimating()
        view.alpha = 0.5
        
        
        // if there are existing annotaions, remove them
        if !(self.mapView.annotations.isEmpty) {
            
            //remove all annotations before adding any
            let oldAnnotations = self.mapView.annotations
            self.mapView.removeAnnotations(oldAnnotations)
        }
        
        let geocoder = CLGeocoder()
        geocoder.geocodeAddressString(locationTextField.text!, completionHandler: {(placemarks, error) -> Void in
            
            if error != nil {
                displayError(self, errorString: error!.localizedDescription)
                //fixes error
                self.view.alpha = 1.0
                activityViewIndicator.stopAnimating()
                return
            } else if let placemark = placemarks?[0] {
                
                let coordinates = placemark.location!.coordinate
                
                self.pointAnnotation = MKPointAnnotation()
                self.pointAnnotation.title = self.locationTextField.text
                self.pointAnnotation.coordinate =  coordinates //CLLocationCoordinate2D(latitude: localSearchResponse!.boundingRegion.center.latitude, longitude: localSearchResponse!.boundingRegion.center.longitude)
                
                self.pinAnnotationView = MKPinAnnotationView(annotation: self.pointAnnotation, reuseIdentifier: nil)
                self.mapView.centerCoordinate = self.pointAnnotation.coordinate
                self.mapView.addAnnotation(self.pinAnnotationView.annotation!)
                
                
                //zooms in
                
                let lat = CLLocationDegrees(placemark.location!.coordinate.latitude)
                let long = CLLocationDegrees(placemark.location!.coordinate.longitude)
                
                let span = MKCoordinateSpanMake(0.075, 0.075)
                let region = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: lat, longitude: long), span: span)
                
                self.mapView.setRegion(region, animated: true)
                
                
                
                
                self.view.alpha = 1.0
                activityViewIndicator.stopAnimating()
                
            }
            
        })
    }
    
    @IBAction func cancelButtonPressed(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func saveButtonPressed(sender: AnyObject) {
        
        
        
        // retrieve key, first name, last name from udacity
        var student: [String:AnyObject] = [:]
        udacity.getUserInfo()
        
        
        // update coords
        searchForLocationDisplayOnMap()
        
        //appdend dictionary
        if let point = pointAnnotation {
            student["longitude"] = point.coordinate.longitude
            student["latitude"] = point.coordinate.latitude
        } else {
            displayError(self, errorString: "Location data invalid, check your address  ")
            shakeViewController(self)
            return
            
        }
        
        student["mapString"] = locationTextField.text!
        student["mediaURL"] = linkTextField.text
        student["firstName"] = udacity.firstName
        student["lastName"] = udacity.lastName
        student["uniqueKey"] = udacity.userID
        
        parse.postLocation(student, completionHandler: {(success, errorString) -> Void in
            if success {
                
            } else {
                displayError(self, errorString: errorString)
            }
        })
        
    }
    @IBAction func browseButtonPressed(sender: AnyObject) {
        let app = UIApplication.sharedApplication()
        app.openURL(NSURL(string: "http://www.google.com" )!)
    }
    
    @IBAction func findOnMapButtonPressed(sender: AnyObject) {
        
        searchForLocationDisplayOnMap()
    }
}

