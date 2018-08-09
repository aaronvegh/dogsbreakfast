//
//  WebViewController.swift
//  DogsBreakfast
//
//  Created by Aaron Vegh on 2018-08-08.
//  Copyright © 2018 Aaron Vegh. All rights reserved.
//

import UIKit
import WebKit

class WebViewController: UIViewController {
    @IBOutlet weak var webView: WKWebView!
    
    var url: URL?
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if let url = url {
            let request = URLRequest(url: url)
            webView.load(request)
        }
    }
}
