//
//  WebViewController.swift
//  WKWebView
//
//  Created by Marco Barnig on 17/11/2016.
//  Copyright © 2016 Marco Barnig. All rights reserved.
//

import Cocoa
import WebKit

class WebViewController: NSViewController, WKUIDelegate, WKNavigationDelegate {
    
    var delegate: feedBack?   
    
    var myWebView: WKWebView!
    
    func output(item: AnyObject) {
        outputText += "ScrollView : " + String(describing: item.scrollView)
        outputText += "Title : " + item.title!
        // print("URL : " + String(item.url)!) // crash
        outputText += "UserAgent : " + item.customUserAgent!
        outputText += "serverTrust : " + String(describing: item.serverTrust)
        NotificationCenter.default.post(name: Notification.Name(rawValue: notifyKeyOutput), object: self)
    }  // end func
    
    func webView(_ myWebView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        outputText += "1. The web content is loaded in the WebView.\n"
        NotificationCenter.default.post(name: Notification.Name(rawValue: notifyKeyOutput), object: self)
    }  // end func
    
    func webView(_ myWebView: WKWebView, didCommit navigation: WKNavigation!) {
        outputText += "2. The WebView begins to receive web content.\n"
        NotificationCenter.default.post(name: Notification.Name(rawValue: notifyKeyOutput), object: self)
    }  // end func
    
    func webView(_ myWebView: WKWebView, didFinish navigation: WKNavigation!) {
        outputText += "3. The navigating to url \(myWebView.url!) finished.\n"
        NotificationCenter.default.post(name: Notification.Name(rawValue: notifyKeyOutput), object: self)
    }  // end func
    
    func webViewWebContentProcessDidTerminate(_ myWebView: WKWebView) {
        outputText += "The Web Content Process is finished.\n"
        NotificationCenter.default.post(name: Notification.Name(rawValue: notifyKeyOutput), object: self)    
    }  // end func
    
    func webView(_ myWebView: WKWebView, didFail navigation: WKNavigation!, withError: Error) {
        outputText += "An error didFail occured.\n"
        NotificationCenter.default.post(name: Notification.Name(rawValue: notifyKeyOutput), object: self)    
    }  // end func
    
    func webView(_ myWebView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError: Error) {
        outputText += "An error didFailProvisionalNavigation occured.\n"
        NotificationCenter.default.post(name: Notification.Name(rawValue: notifyKeyOutput), object: self)    
    }  // end func
    
    func webView(_ myWebView: WKWebView, didReceiveServerRedirectForProvisionalNavigation navigation: WKNavigation!) {
        outputText += "The WebView received a server redirect.\n"
        NotificationCenter.default.post(name: Notification.Name(rawValue: notifyKeyOutput), object: self)    
    }  // end func
    
    // the following function handles target="_blank" links by opening them in the same view
    func webView(_ myWebView: WKWebView, createWebViewWith configuration: WKWebViewConfiguration, for navigationAction: WKNavigationAction, windowFeatures: WKWindowFeatures) -> WKWebView? {
        outputText += "New Navigation.\n"
        if navigationAction.targetFrame == nil {
            outputText += "Trial to open a blank window.\n"
            outputText += "navigationAction : " + String(describing: navigationAction) + ".\n"
            let newLink = navigationAction.request
            outputText += "\nThe new navigationAction is : " + String(describing: navigationAction) + ".\n\n"
            outputText += "The new URL is : " + String(describing: newLink.url!) + ".\n"
            NotificationCenter.default.post(name: Notification.Name(rawValue: notifyKeyOutput), object: self)  
            openSafari(link: newLink.url!)
        }  // end if
        return nil
    } // end func
    
    func openSafari(link: URL) {
        let checkURL = link
        if NSWorkspace.shared.open(checkURL as URL) {
            outputText += "URL Successfully Opened in Safari.\n"
        } else {
            outputText += "Invalid URL in Safari.\n"
        }  // end if
        NotificationCenter.default.post(name: Notification.Name(rawValue: notifyKeyOutput), object: self)
    }  // end func    
    
    func react() {
        outputText += "\nHi. How are you? Here is the \"dummy\" react function speaking!\n\n"
        if let doAction = delegate { 
            DispatchQueue.main.async() { 
                doAction.output()
            }  // end dispatch
        } // end if doAction        
    }  // end func

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.
        outputText += "0. WebViewController View loaded.\n"
        NotificationCenter.default.post(name: Notification.Name(rawValue: notifyKeyOutput), object: self)
        let configuration = WKWebViewConfiguration()
        myWebView = WKWebView(frame: .zero, configuration: configuration)
        myWebView.translatesAutoresizingMaskIntoConstraints = false
        myWebView.navigationDelegate = self
        myWebView.uiDelegate = self
        view.addSubview(myWebView)
        // topAnchor only available in version 10.11
        [myWebView.topAnchor.constraint(equalTo: view.topAnchor),
         myWebView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
         myWebView.leftAnchor.constraint(equalTo: view.leftAnchor),
         myWebView.rightAnchor.constraint(equalTo: view.rightAnchor)].forEach  { 
            anchor in
            anchor.isActive = true
        }  // end forEach
        // let myURL = URL(string: "http://localhost:8042")
        let myURL = URL(string: "http://www.web3.lu/")
        let myRequest = URLRequest(url: myURL!)
        myWebView.load(myRequest)
    }  // end func        
    
}  // end class
