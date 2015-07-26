//
//  ViewController.swift
//  Easy Browser
//
//  Created by Mac Bellingrath on 7/26/15.
//  Copyright © 2015 Mac Bellingrath. All rights reserved.
//

import UIKit
import WebKit

class ViewController: UIViewController, WKNavigationDelegate {
    
    var webView: WKWebView!
    var websites = ["https://www.apple.com","https://www.twitter.com","https://www.google.com"]
    var progressView:UIProgressView!
    var inputTextField:UITextField?

    override func loadView() {
        webView = WKWebView()
        webView.navigationDelegate = self
        view = webView
        
        
    }


    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.tintColor = UIColor.whiteColor()
        navigationController?.navigationBar.backgroundColor = UIColor.blackColor()
        UIToolbar.appearance().barTintColor = UIColor.whiteColor()

        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Open", style: UIBarButtonItemStyle.Plain, target: self, action: "openTapped")
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Add", style: .Plain, target: self, action: "addButtonTapped")
        let url = NSURL(string: websites[0])!
        webView.loadRequest(NSURLRequest(URL: url))
        webView.allowsBackForwardNavigationGestures = true
        
        progressView = UIProgressView(progressViewStyle: UIProgressViewStyle.Default)
        progressView.sizeToFit()
        let progressButton = UIBarButtonItem(customView: progressView)
        let spacer = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.FlexibleSpace, target: nil, action: nil)
        let refresh = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Refresh, target: webView, action: "reload")
        toolbarItems = [spacer,progressButton, refresh, spacer]
        navigationController?.toolbarHidden = false
        
        
        webView.addObserver(self, forKeyPath: "estimatedProgress", options: .New, context: nil)
        

    }
    
    func openTapped() {
        let ac = UIAlertController(title: "Open", message: nil, preferredStyle: .ActionSheet)
        ac.addAction(UIAlertAction(title: "Cancel", style: .Cancel, handler: nil))
        for website in websites {
            ac.addAction(UIAlertAction(title: website, style: .Default, handler: openPage))
        }
        presentViewController(ac, animated: true, completion: nil)
        
        
    }
    func addButtonTapped(){
        let ac = UIAlertController(title: "Add", message: "Add your favorite site", preferredStyle: UIAlertControllerStyle.Alert)
        ac.addTextFieldWithConfigurationHandler { (textfield: UITextField!) -> Void in
            textfield.placeholder = "http://www."
            self.inputTextField = textfield
            
        }
        ac.addAction(UIAlertAction(title: "Add", style: .Default, handler: addBookmark))
        ac.addAction(UIAlertAction(title: "Cancel", style: .Cancel, handler: nil))
        presentViewController(ac, animated: true, completion: nil)
    }
    func addBookmark(UIAlertAction!) {
       websites.append((inputTextField?.text)!)
        print("added")
        print(websites)
        
        
    }
    
    func openPage(action: UIAlertAction!){
        let url = NSURL(string: action.title!)!
        webView.loadRequest(NSURLRequest(URL: url))
        
    }
    
    func webView(webView: WKWebView, didFinishNavigation navigation: WKNavigation!) {
        title = webView.title
    }
    
    override func observeValueForKeyPath(keyPath: String?, ofObject object: AnyObject?, change: [NSObject : AnyObject]?, context: UnsafeMutablePointer<Void>) {
        if keyPath == "estimatedProgress" {
            progressView.progress = Float(webView.estimatedProgress)
        }
    }

}

