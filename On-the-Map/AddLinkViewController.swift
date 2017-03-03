//
//  AddLinkViewController.swift
//  On-the-Map
//
//  Created by Christine Chang on 12/25/16.
//  Copyright © 2016 Christine Chang. All rights reserved.
//

import UIKit
import MapKit

class AddLinkViewController: UIViewController {
    
    @IBOutlet weak var linkTextField: UITextField!
    @IBOutlet weak var mapView: MKMapView!
    
    var latitude:Double!
    var longitude:Double!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        let request = MKLocalSearchRequest()
        request.naturalLanguageQuery = "555 Bailey Avenue San Jose"
        request.region = mapView.region
        let search = MKLocalSearch(request: request)
        search.start { response, _ in
            guard let response = response else {
                return
            }
            print(response.mapItems[0].placemark);
            
            self.displayPlaceMarkOnMap(placemark: response.mapItems[0].placemark);
        }

    }

    
    
    func displayPlaceMarkOnMap(placemark:MKPlacemark){
        // cache the pin
        // clear existing pins
        mapView.removeAnnotations(mapView.annotations)
        let annotation = MKPointAnnotation()
        annotation.coordinate = placemark.coordinate
        annotation.title = placemark.name
       
        mapView.addAnnotation(annotation)
        let span = MKCoordinateSpanMake(0.05, 0.05)
        let region = MKCoordinateRegionMake(placemark.coordinate, span)
        mapView.setRegion(region, animated: true)
        
        latitude = placemark.coordinate.latitude
        longitude = placemark.coordinate.longitude
    }
    
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func cancelPressed(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func submitPressed(_ sender: Any) {
        let link = linkTextField.text
        
        
        ParseClient.sharedInstance().postStudentLocation(uniqueKey: "2", firstName: "Me", lastName: "You", mapString: "", mediaURL: link, latitude: latitude, longitude: longitude) { (response, error) in
           
            print(response);
            print(error);
        }
    }
}
