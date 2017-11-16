//
//  UnsplashWebViewController.swift
//  Papr
//
//  Created by Joan Disho on 16.11.17.
//  Copyright © 2017 Joan Disho. All rights reserved.
//

import UIKit
import WebKit

class UnsplashWebViewController: UIViewController, WKNavigationDelegate {

    var webView : WKWebView!

    var onWillDismiss: ((_ didCancel: Bool) -> Void)?
    var onMatchedURL: ((_ url: URL) -> Void)?

    var cancelButton: UIBarButtonItem?

    let startURL : URL?
    let dismissOnMatchURL : URL?
    
    init(startURL : URL, dismissOnMatchURL : URL) {
        self.startURL = startURL
        self.dismissOnMatchURL = dismissOnMatchURL
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if !webView.canGoBack {
            loadURL(url: startURL!)
        }
    }
    
    // MARK: UI
    private func configureUI() {
        self.title = "Unsplash"
        self.webView = WKWebView(frame: self.view.bounds)
        self.view.addSubview(self.webView)
        self.webView.navigationDelegate = self
        self.view.backgroundColor = .white
        self.cancelButton = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(cancel))
        self.navigationItem.rightBarButtonItem = self.cancelButton
    }
    
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        if let url = navigationAction.request.url {
            if self.dimissURLMatchesURL(url: url) {
                self.onMatchedURL?(url)
                self.dismiss(animated: true)
                return decisionHandler(.cancel)
            }
        }
        return decisionHandler(.allow)
    }
    
    // MARK: Helpers
    func loadURL(url: URL) {
        webView.load(URLRequest(url: url))
    }
    
    func dimissURLMatchesURL(url: URL) -> Bool {
        if (url.scheme == self.dismissOnMatchURL?.scheme &&
            url.host == self.dismissOnMatchURL?.host &&
            url.path == self.dismissOnMatchURL?.path) {
            return true
        }
        return false
    }
    
    func showHideBackButton(show: Bool) {
        navigationItem.leftBarButtonItem = show ? UIBarButtonItem(barButtonSystemItem: .rewind, target: self, action: #selector(goBack)) : nil
    }
    
    @objc func goBack() {
        webView.goBack()
    }

    @objc func cancel() {
        dismiss(animated: true)
    }

    func dismiss(asCancel: Bool, animated: Bool) {
        webView.stopLoading()

        self.onWillDismiss?(asCancel)
        presentingViewController?.dismiss(animated: animated, completion: nil)
    }

}
