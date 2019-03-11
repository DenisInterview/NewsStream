//
//  NewsModel.swift
//  NewsStream
//
//  Created by Denis Kalashnikov on 3/10/19.
//  Copyright © 2019 Denis Kalashnikov. All rights reserved.
//

import UIKit

class NewsModel: NSObject {
    var items = [ItemsResult]()
    var isLoading = false
    var totalResults: Int = 0
    var more = [String]()
    
    func sortItems() {
        items.sort { (item1, item2) -> Bool in
            if let date1 = item1.publishedAt?.toDate(), let date2 = item2.publishedAt?.toDate(){
                return date1.compare(date2) == ComparisonResult.orderedDescending
            }
            return false
        }
    }
    
    func reload(complition:@escaping ((Error?)->Void)) {
        self.items.removeAll()
        self.more.removeAll()
        loadFirst(completion: complition)
    }

    
    func loadFirst(completion:@escaping ((Error?)->Void)) {
        isLoading = true
        
        NetworkManager.feed() { (newsModel, error) in
            self.isLoading = false
            guard let newsModel = newsModel else {
                completion(error)
                return
            }
            if let totalMore = newsModel.more?.result {
                self.more = totalMore.compactMap{ $0.uuid }
            }
            self.items.append(contentsOf: newsModel.items?.result ?? [])
            self.sortItems()
            completion(nil)
        }
    }
    
    func shouldLoadMore(_ currentItemIndex: Int) -> Bool {
        return !isLoading && more.count > 0 && currentItemIndex > (items.count-5)
    }
    
    func loadMore(completion:@escaping ((Error?)->Void))  {
        isLoading = true
        let uuids = Array(more.prefix(Constants.count))
        more = Array(more.dropFirst(Constants.count))
        NetworkManager.feedMore(uuids) { (newsModel, error) in
            self.isLoading = false
            guard let newsModel = newsModel else {
                completion(error)
                return
            }
            self.items.append(contentsOf: newsModel.items?.result ?? [])
            self.sortItems()
            completion(nil)
        }
    }
}
