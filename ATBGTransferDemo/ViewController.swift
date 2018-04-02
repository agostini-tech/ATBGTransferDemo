//
//  ViewController.swift
//  ATBGTransferDemo
//
//  Created by Dejan on 01/04/2018.
//  Copyright © 2018 Dejan. All rights reserved.
//

import UIKit
import UserNotifications

class ViewController: UIViewController {

    private let controller = BGTransferController()
    
    @IBOutlet weak var progressView: UIProgressView!
    @IBOutlet weak var dlLocationLabel: UILabel!
    
    override func viewDidLoad() {
        super .viewDidLoad()
        
        registerForNotifications()
        
        controller.onProgress = { (progress) in
            self.progressView.progress = Float(progress)
        }
        
        controller.onCompleted = { (location) in
            // Save your file somewhere, or use it...
            print("Download finished: \(location.absoluteString)")
            self.dlLocationLabel.text = location.absoluteString
            self.postNotification()
        }
    }
    
    private func registerForNotifications() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound]) { (granted, error) in }
    }
    
    private func postNotification() {
        let content = UNMutableNotificationContent()
        content.title = "Download complete!"
        content.body = "Your background transfer has completed."
        
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 30, repeats: false)
        
        let request = UNNotificationRequest(identifier: "TransferComplete", content: content, trigger: trigger)
        UNUserNotificationCenter.current().add(request, withCompletionHandler: nil)
    }
    
    @IBAction func downloadAction(_ sender: Any) {
        controller.startDownload()
    }
}
