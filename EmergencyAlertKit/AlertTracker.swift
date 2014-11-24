//
//  AlertTracker.swift
//  BitWatch
//
//  Created by Leo Tanady on 23/11/14.
//  Copyright (c) 2014 Razeware LLC. All rights reserved.
//

import Foundation

public typealias AlertRequestCompletionBlock = (title: NSString?, content: NSString?, error: NSError?, seen: Bool) -> ()

public class AlertTracker {
    
    let defaults = NSUserDefaults.standardUserDefaults()
    let session: NSURLSession
    let URL = "http://watch-ealerts-v1.herokuapp.com/latest.json"
    
    public init() {
        let configuration = NSURLSessionConfiguration.defaultSessionConfiguration()
        session = NSURLSession(configuration: configuration)
    }
    
    public func requestAlert(completion: AlertRequestCompletionBlock) {
        //let request = NSURLRequest(URL: NSURL(string: URL)!)
        var request = NSMutableURLRequest(URL: NSURL(string: URL)!)
        request.HTTPMethod = "GET"
        var params = []
        var err: NSError?
        //request.HTTPBody = NSJSONSerialization.dataWithJSONObject(params, options: nil, error: &err)
        //request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        //request.addValue("application/json", forHTTPHeaderField: "Accept")
        println("Request")
        println(request)
        var seen = true
        var task = session.dataTaskWithRequest(request, completionHandler: { (data, response, error) -> Void in
            if error != nil {
                println(error)
                
            } else {
                //var strData = NSString(data: data, encoding: NSUTF8StringEncoding)
                
                var err: NSError?
                var jsonDictionary: Dictionary = NSJSONSerialization.JSONObjectWithData(data, options: nil, error: &err) as NSDictionary
                if !jsonDictionary.isEmpty {
                    var id = jsonDictionary["id"]? as Int;
                    var title = jsonDictionary["title"]? as String;
                    var content = jsonDictionary["content"]? as String;
                    if (self.defaults.objectForKey("alertId") != nil) {
                        var alertId = self.defaults.objectForKey("alertId")? as Int
                        if alertId == id {
                            seen = true
                        } else {
                            seen = false
                            self.defaults.setObject(id, forKey: "alertId")
                        }
                    } else {
                        self.defaults.setObject(id, forKey: "alertId")
                    }
                    completion(title: title, content: content, error: err, seen: seen)
                
                } else {
                    println("Error could not parse JSON");
                    
                }
            }
        })
        task.resume()
    }
    
    
}
