//
//  NetworkManager.swift
//  NewsStream
//
//  Created by Denis Kalashnikov on 3/10/19.
//  Copyright © 2019 Denis Kalashnikov. All rights reserved.
//

import UIKit

enum NetworkError: Error {
    case network
    case unknown
}

class NetworkManager: NSObject {
    
    static func feed(completion:@escaping ((NewsStream?, Error?)->Void)) {
        if let url = URL(string: "\(Constants.trandingURL)") {
            let task = URLSession.shared.newsStreamTask(with: url) { newsStream, response, error in
                if let newsStream = newsStream {
                    print("model: \(String(describing: newsStream.items?.result?.count))")
                    completion(newsStream, nil)
                } else if error != nil{
                    completion(nil, error)
                } else {
                    completion(nil, NetworkError.unknown)
                }
            }
            task.resume()
        }
    }
    
    static func feedMore(_ uuids:[String], completion:@escaping ((NewsStream?, Error?)->Void)) {
        let uuidsStr = uuids.joined(separator: ",")
        if let url = URL(string: "\(Constants.moreURL)\(uuidsStr)") {
            let task = URLSession.shared.newsStreamTask(with: url) { newsStream, response, error in
                if let newsStream = newsStream {
                    print("model: \(String(describing: newsStream.items?.result?.count))")
                    completion(newsStream, nil)
                } else if error != nil{
                    completion(nil, error)
                } else {
                    completion(nil, NetworkError.unknown)
                }
            }
            task.resume()
        }
    }
}


