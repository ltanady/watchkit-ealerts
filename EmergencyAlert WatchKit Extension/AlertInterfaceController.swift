//
//  AlertInterfaceController.swift
//  BitWatch
//
//  Created by Leo Tanady on 23/11/14.
//  Copyright (c) 2014 Razeware LLC. All rights reserved.
//

import Foundation
import WatchKit
//import EmergencyAlertKit
import EmergencyAlertKit

class AlertInterfaceController: WKInterfaceController {
    
    @IBOutlet var titleImage: WKInterfaceImage!
    @IBOutlet var titleLabel: WKInterfaceLabel!
    @IBOutlet var contentLabel: WKInterfaceLabel!
    @IBOutlet var refreshButton: WKInterfaceButton!
    
    let alertTracker = AlertTracker()
    let image = UIImage(named: "alert.png") as UIImage?
    
    //var updateInterval: NSTimeInterval = 30
    //let dataAccessQueue = dispatch_queue_create("refreshAlert", DISPATCH_QUEUE_SERIAL)
    
    @IBAction func dismissButtonPressed() {
        alertTracker.requestAlert { (title, content, error, seen) -> () in
            if !seen {
                self.titleImage.setImage(self.image)
                self.titleLabel.setText(title? as? String)
                self.contentLabel.setText(content? as? String)
            } else {
                self.clearDisplay()
            }
        }
    }
    
    override init(context: AnyObject?) {
        super.init(context: context)
        println("Initializing watch interface")
        updatingDisplay()
        alertTracker.requestAlert { (title, content, error, seen) -> () in
            if !seen {
                self.titleImage.setImage(self.image)
                self.titleLabel.setText(title? as? String)
                self.contentLabel.setText(content? as? String)
            } else {
                self.clearDisplay()
            }
        }
    }
    
    func updatingDisplay() {
        self.titleImage.setImage(nil)
        self.titleLabel.setText("")
        self.contentLabel.setText("Updating alert...")
    }
    
    func clearDisplay() {
        self.titleImage.setImage(nil)
        self.titleLabel.setText("")
        self.contentLabel.setText("No New Alert")
    }
    
}
