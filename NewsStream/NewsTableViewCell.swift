//
//  NewsTableViewCell.swift
//  NewsStream
//
//  Created by Denis Kalashnikov on 3/10/19.
//  Copyright © 2019 Denis Kalashnikov. All rights reserved.
//

import UIKit

class NewsTableViewCell: UITableViewCell {

    @IBOutlet weak var newsImageView: UIImageView!
    @IBOutlet weak var newsTitleLable: UILabel!
    @IBOutlet weak var newsRemarkLabel: UILabel!
    
    static let id = "NewsTableViewCell"
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func setup(model: ItemsResult) {
        if let imageURL = model.mainImage?.resolutions?.first(where: { (resolution) -> Bool in
            return resolution.tag == Tag.square140X140
        })?.url {
            newsImageView.loadImageUsingCacheWithURLString(imageURL, placeHolder: UIImage(named: "image-placeholder")){ result in }
        }
        newsTitleLable.text = model.title
        newsRemarkLabel.text = "\(model.publisher ?? "")"
        
    }
}
