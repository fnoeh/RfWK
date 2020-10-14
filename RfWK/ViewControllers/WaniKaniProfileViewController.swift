//
//  WaniKaniProfileViewController.swift
//  RfWK
//
//  Created by Florian Nöhring on 01.09.19.
//  Copyright © 2019 Florian Nöhring. All rights reserved.
//

import UIKit
import WebKit


class WaniKaniProfileViewController: UIViewController {
       
    override func viewDidLoad() {
        super.viewDidLoad()

        let url = URL(string: "https://www.wanikani.com/settings/personal_access_tokens")!
        let request = URLRequest(url: url)

        let webview = WKWebView()
        webview.load(request)
        
        self.view = webview
    }
}
