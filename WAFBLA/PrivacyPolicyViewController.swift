//
//  PrivacyPolicyViewController.swift
//  WAFBLA
//
//  Created by Sathvik Nallamalli on 3/28/21.
//

import UIKit
import WebKit

class PrivacyPolicyViewController: UIViewController, WKNavigationDelegate {

    @IBOutlet var menuButton: UIBarButtonItem!
   
    @IBOutlet var progressCircle: UIActivityIndicatorView!
    @IBOutlet var webView: WKWebView!
    
    let sampleURL = "https://myfbla-0.flycricket.io/privacy.html"
   
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        if revealViewController() != nil {
            menuButton.target = revealViewController()
            menuButton.action = "revealToggle:"
            view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        }
        webView.navigationDelegate = self
        webView.addSubview(progressCircle)

        sendRequest(urlString: sampleURL)
    }
    
    private func sendRequest(urlString: String) {
        let myURL = URL(string: urlString)
        let myRequest = URLRequest(url: myURL!)
        webView.load(myRequest)
      }
    fileprivate func showActivityIndicator(show: Bool) {
       if show {
         progressCircle.startAnimating()
       } else {
        progressCircle.stopAnimating()
        progressCircle.isHidden = true
                }
     }
    
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        // Set the indicator everytime webView started loading
        self.showActivityIndicator(show: true)
      }
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        self.showActivityIndicator(show: false)
    }
    
      func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        self.showActivityIndicator(show: false)
      }


}
