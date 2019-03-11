//
//  ArticleDetailViewController.swift
//  NewsStream
//
//  Created by Denis Kalashnikov on 3/10/19.
//  Copyright © 2019 Denis Kalashnikov. All rights reserved.
//

import UIKit
import WebKit

class ArticleDetailViewController: UIViewController {

    @IBOutlet weak var webView: WKWebView!
    public var content : String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.setNavigationBarHidden(false, animated: true)
        if let content = content {
            let css = "<style>.container img { width: 100%; height: auto;} .container iframe {width: 100%; height: auto;} .container {font-size: 200%;}</style>"
            webView.loadHTMLString("<html><body>\(css)<div class=container>\(content)</div></body></html>", baseURL: nil)
        }
    }
}
