//
//  UdacityConvenience.swift
//  On-the-Map
//
//  Created by Christine Chang on 12/18/16.
//  Copyright © 2016 Christine Chang. All rights reserved.
//

import Foundation
import UIKit 

extension UdacityClient {
    
    // The HTTP request message body for postSession contains username & password.
    // The HTTP response message body for postSession contains userID and sessionID.
    func postSession(username: String, password: String, completionHandlerForSession: @escaping (_ success: Bool, _ sessionID: String?, _ error: NSError?) -> Void) {
        
        // The string form of httpRequestBody (below) gets converted to type Data in taskForPOSTMethod.
        let httpRequestBody = "{\"udacity\": {\"username\": \"\(username)\", \"password\": \"\(password)\"}}"
        
        let _ = taskForPOSTMethod(method: Methods.Session, httpRequestBody: httpRequestBody) { (parsedResponse, error) in
            
            func sendError(error: String) {
                print(error)
                let userInfo = [NSLocalizedDescriptionKey: error]
                completionHandlerForSession(false, nil, NSError(domain: "completionHandlerForPOST", code: 1, userInfo: userInfo))
            }
            
            guard (error == nil) else {
                sendError(error: "There was an error with your request: \(error)")
                return
            }
            
            guard (parsedResponse != nil) else {
                sendError(error: "No results were found.")
                return
            }
            
            guard let account = parsedResponse?[JSONResponseKeys.Account] as! [String:AnyObject]? else {
                sendError(error: "No account was found.")
                return
            }
            
            guard let key = account[JSONResponseKeys.Key] as! String? else {
                sendError(error: "No key was found.")
                return
            }
            
            // Set the userID (unique key)
            self.userID = key
            
            
            // Now check if the sessionID exists. If it exists, then success = true.
            guard let session = parsedResponse?[JSONResponseKeys.Session] as! [String:AnyObject]? else {
                sendError(error: "No session was found.")
                return
            }
            
            guard let sessionID = session[JSONResponseKeys.ID] as! String? else {
                sendError(error: "No session ID was found.")
                return
            }
            
            completionHandlerForSession(true, sessionID, nil)

        }
        
    }
    
    // No parameters needed for deleteSession.
    func deleteSession(completionHandlerForDeleteSession: @escaping (_ success: Bool, _ sessionID: String?, _ error: NSError?) -> Void) {
        
        let _ = taskForDELETEMethod(method: Methods.Session)
        { (parsedResponse, error) in
            
            func sendError(error: String) {
                print(error)
                let userInfo = [NSLocalizedDescriptionKey: error]
                completionHandlerForDeleteSession(false, nil, NSError(domain: "completionHandlerForDELETE", code: 1, userInfo: userInfo))
            }
            
            guard (error == nil) else {
                sendError(error: "There was an error with your request: \(error)")
                return
            }
            
            guard (parsedResponse != nil) else {
                sendError(error: "No results were found.")
                return
            }
            
            guard let session = parsedResponse?[JSONResponseKeys.Session] as! [String:AnyObject]? else {
                sendError(error: "No session was found.")
                return
            }
            
            guard let sessionID = session[JSONResponseKeys.ID] as! String? else {
                sendError(error: "No session ID was found.")
                return
            }
            
            // Only if there is a session ID (success = true) can we delete a session.
            completionHandlerForDeleteSession(true, sessionID, nil)
        }
    }

    // Use this method to get the user's first name and last name for their pin.
    func getUserData(completionHandlerForUserData: @escaping (_ fullName: String?, _ error: NSError?) -> Void) {
    
        let _ = taskForGETMethod(method: Methods.User + self.userID!) { (parsedResponse, error) in
            
            func sendError(error: String) {
                print(error)
                let userInfo = [NSLocalizedDescriptionKey: error]
                completionHandlerForUserData(nil, NSError(domain: "completionHandlerForGET", code: 1, userInfo: userInfo))
            }
            
            guard (error == nil) else {
                sendError(error: "There was an error with your request: \(error)")
                return
            }
            
            guard (parsedResponse != nil) else {
                sendError(error: "No results were found.")
                return
            }
            
            guard let user = parsedResponse?[JSONResponseKeys.User] as! [String:AnyObject]? else {
                sendError(error: "No user was found.")
                return
            }
            
            guard let firstName = user[JSONResponseKeys.FirstName] as! String? else {
                sendError(error: "No first name was found.")
                return
            }
            
            guard let lastName = user[JSONResponseKeys.LastName] as! String? else {
                sendError(error: "No last name was found.")
                return
            }
            
            let fullName = "\(firstName) \(lastName)"
            
            completionHandlerForUserData(fullName, nil)
        }

        
    }
    
}
