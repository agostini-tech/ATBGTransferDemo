//
//  BGTransferController.swift
//  ATBGTransferDemo
//
//  Created by Dejan on 02/04/2018.
//  Copyright © 2018 Dejan. All rights reserved.
//

import UIKit

enum Constant: String {
    case sessionID = "agostini.tech.ATBGTransferDemo.bgSession"
}

class BGTransferController: NSObject
{
    var onProgress: ((Double) -> ())?
    var onCompleted: ((URL) -> ())?
    
    // Download session
    private lazy var bgSession: URLSession = {
        let config = URLSessionConfiguration.background(withIdentifier: Constant.sessionID.rawValue)
//        config.isDiscretionary = true
        config.sessionSendsLaunchEvents = true
        return URLSession(configuration: config, delegate: self, delegateQueue: nil)
    }()

    func startDownload() {
        if let url = URL(string: "https://speed.hetzner.de/1GB.bin") {
            let bgTask = bgSession.downloadTask(with: url)
            bgTask.earliestBeginDate = Date().addingTimeInterval(2 * 60)
            bgTask.countOfBytesClientExpectsToSend = 512
            bgTask.countOfBytesClientExpectsToReceive = 1 * 1024 * 1024 * 1024 // 1GB
            bgTask.resume()
        }
    }
}

// MARK: - URLSessionDelegate
extension BGTransferController: URLSessionDelegate
{
    func urlSessionDidFinishEvents(forBackgroundURLSession session: URLSession) {
        DispatchQueue.main.async {
            guard
                let appDelegate = UIApplication.shared.delegate as? AppDelegate,
                let completionHandler = appDelegate.bgSessionCompletionHandler
                else {
                    return
            }
            appDelegate.bgSessionCompletionHandler = nil
            completionHandler()
        }
    }
}

// MARK: - URLSessionDownloadDelegate
extension BGTransferController: URLSessionDownloadDelegate
{
    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didFinishDownloadingTo location: URL) {
        print("Did finish downloading: \(location.absoluteString)")
        DispatchQueue.main.async {
            self.onCompleted?(location)
        }
    }
    
    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didWriteData bytesWritten: Int64, totalBytesWritten: Int64, totalBytesExpectedToWrite: Int64) {
        guard totalBytesExpectedToWrite != NSURLSessionTransferSizeUnknown else {
            return
        }
        
        let progress = Double(Double(totalBytesWritten)/Double(totalBytesExpectedToWrite))
        print("Download progress: \(progress)")
        DispatchQueue.main.async {
            self.onProgress?(progress)
        }
    }
}
