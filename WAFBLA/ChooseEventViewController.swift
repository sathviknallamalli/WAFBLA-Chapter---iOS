//
//  ChooseEventViewController.swift
//  WAFBLA
//
//  Created by Sathvik Nallamalli on 3/25/21.
//

import UIKit
import WebKit


class ChooseEventViewController: UIViewController, WKUIDelegate, WKNavigationDelegate {

    @IBOutlet var menuButton: UIBarButtonItem!
   
    @IBOutlet var webView: WKWebView!
    @IBOutlet var Activity: UIActivityIndicatorView!
    
    let sampleURL = "https://docs.google.com/presentation/d/1ofRyxTDHyYtDhKBQyNHKneMTr4bPop0GhpGAsKvy3LM/edit?usp=sharing"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if revealViewController() != nil {
            menuButton.target = revealViewController()
            menuButton.action = "revealToggle:"
            view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        }
        
        webView.navigationDelegate = self
        webView.addSubview(Activity)

        sendRequest(urlString: sampleURL)
    }
    
    private func sendRequest(urlString: String) {
        let myURL = URL(string: urlString)
        let myRequest = URLRequest(url: myURL!)
        webView.load(myRequest)
      }
    fileprivate func showActivityIndicator(show: Bool) {
       if show {
        Activity.startAnimating()
       } else {
        Activity.stopAnimating()
        Activity.isHidden = true
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
