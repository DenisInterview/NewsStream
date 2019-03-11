//
//  Extensions.swift
//  NewsStream
//
//  Created by Denis Kalashnikov on 3/10/19.
//  Copyright © 2019 Denis Kalashnikov. All rights reserved.
//

import Foundation

extension String {
    func toDate() -> Date {
        return Date(timeIntervalSince1970: TimeInterval(Int(self) ?? 0))
    }
}
