//
//  InAppBrowserViewController.swift
//  RfWK
//
//  Created by Florian Nöhring on 01.05.20.
//  Copyright © 2020 Florian Nöhring. All rights reserved.
//

import UIKit
import WebKit

class InAppBrowserViewController: UIViewController {

    var url: URL? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if let url = url {
            let request = URLRequest(url: url)
            
            let webview = WKWebView()
            webview.load(request)
            
            self.view = webview
        }
    }
}
