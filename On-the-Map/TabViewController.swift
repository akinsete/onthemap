//
//  TabViewController.swift
//  On-the-Map
//
//  Created by Christine Chang on 2/9/17.
//  Copyright © 2017 Christine Chang. All rights reserved.
//

import UIKit

class TabViewController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func viewWillAppear(_ animated: Bool) {
        loadStudentLocations()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    // Load student locations in both the map view and table view.
    func loadStudentLocations() {
        
        // studentLocations is an array of dictionaries
        ParseClient.sharedInstance().getStudentLocations() { (success, studentInfoArray, error) in
            
            performUIUpdatesOnMain {
                
                if success {
                    if let mapVC = self.viewControllers?[0] as? MapViewController {
                        mapVC.studentInfoArrayToLoad = studentInfoArray!
                        mapVC.loadStudents(studentInfo: studentInfoArray!)
                    }
                    if let listVC = self.viewControllers?[1] as? ListViewController {
                        listVC.studentInfoArrayToLoad = studentInfoArray!
                    }
                } else {
                    self.showErrorAlert(messageText: "Pins failed to download.")
                }
            }
        }
    }
    
    @IBAction func logoutPressed(_ sender: Any) {
        
        UdacityClient.sharedInstance().deleteSession() { (success, sessionID, error) in
            
            performUIUpdatesOnMain {
                
                if success {
                    self.dismiss(animated: true, completion: nil)
                } else {
                    self.showErrorAlert(messageText: "Logout failed.")
                }
            }
        }
        
        self.dismiss(animated: true, completion: nil)
    }
    
}

private extension TabViewController {
    
    func showErrorAlert(messageText: String) {
        let alert = UIAlertController(title: "Alert", message: messageText, preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
}
