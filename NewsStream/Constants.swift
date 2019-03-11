//
//  Constants.swift
//  NewsStream
//
//  Created by Denis Kalashnikov on 3/10/19.
//  Copyright © 2019 Denis Kalashnikov. All rights reserved.
//

//News Stream API:
//http://doubleplay-sports-yql.media.yahoo.com/v3/sports_news?leagues=sports&stream_type=headlines&count=10&region=US&lang=en-US
//
//Inflation API: http://doubleplay-sports-yql.media.yahoo.com/v3/news_items?uuids=uuid1,uuid2,uuid3
//Where the uuids are from the “more” field in the New Stream API response

import UIKit

class Constants: NSObject {
    fileprivate static let baseUrl = "http://doubleplay-sports-yql.media.yahoo.com/v3/"
    fileprivate static let defaultParams = "sports_news?"
    static let count = 20
    
    static let trandingURL = "\(baseUrl)\(defaultParams)&leagues=sports&stream_type=headlines&count=\(count)&region=US&lang=en-US"
    
    static let moreURL = "\(baseUrl)news_items?uuids="

}
