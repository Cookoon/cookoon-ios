//
//  ViewController.swift
//  coookoon-ios
//
//  Created by Charles PERNET on 14/09/2017.
//  Copyright © 2017 Charles PERNET. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UIWebViewDelegate {
    
    var webView = UIWebView(frame: CGRect(x: 0, y: 0, width: Int(UIScreen.main.bounds.width), height: Int(UIScreen.main.bounds.height)))
    

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if !Reachability.isConnectedToNetwork() {
            webView.stopLoading()
            showError("No Internet Connection", "Make sure your device is connected to the internet.")
        }
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    // UIWebViewDelegate Implementation
    func webViewDidFinishLoad(_ webView: UIWebView) {
        self.view.addSubview(webView)
    }
    
    func webView(_ webView: UIWebView, didFailLoadWithError: Error) {
        showError("An error occurred", didFailLoadWithError.localizedDescription)
    }
    
    func webView(_ webView: UIWebView, shouldStartLoadWith request: URLRequest, navigationType: UIWebViewNavigationType) -> Bool {
        
        // mailto or tel
        if navigationType == UIWebViewNavigationType.other {
            if ["mailto", "tel"].contains(request.url!.scheme!) {
                UIApplication.shared.open(request.url!, options: [:], completionHandler: nil)
                return false
            }
        }
        
//        if navigationType == UIWebViewNavigationType.linkClicked {
//            // Link outside app, open in native browser
//            if request.url!.host != "cookoon.herokuapp.com" {
//                UIApplication.shared.open(request.url!, options: [:], completionHandler: nil)
//                return false
//            }
//            
//            // TODO: Native social apps (TWTR/FB/LI)
//        }
        
        return true
    }
    
    
    // Error Helper
    func showError(_ title: String, _ message: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
        let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.destructive) {
            (result : UIAlertAction) -> Void in
            exit(0)
        }
        
        alertController.addAction(okAction)
        self.present(alertController, animated: true, completion: nil)
    }
    
}
