//
//  IndividualPostViewController.swift
//  NoticeBoard
//
//  Created by Ethan Hu on 27/03/2017.
//  Copyright © 2017 Ethan Hu. All rights reserved.
//

import UIKit
import Agrume
import Kingfisher

class IndividualPostViewController: UIViewController, UIWebViewDelegate{

    @IBOutlet weak var postWebView: UIWebView!
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    
    var postId:String!
    let individualPostAPIURLAddress = "https://hfi.me/api/post/id/"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        postWebView.delegate = self
        postWebView.scrollView.isScrollEnabled = true
        postWebView.loadRequest(URLRequest(url: URL(string: individualPostAPIURLAddress + postId)!))
    }
    
    func webViewDidStartLoad(_ webView: UIWebView) {
        spinner.startAnimating()
    }
    
    func webView(_ webView: UIWebView, shouldStartLoadWith request: URLRequest, navigationType: UIWebViewNavigationType) -> Bool {
        let imageRecognitionScheme = "post-image-preview"
        if request.url?.scheme == imageRecognitionScheme {
            if let imageSrc = request.url?.absoluteString.replacingOccurrences(of: "\(imageRecognitionScheme):", with: "") {
                if let imageURL = URL(string: imageSrc) {
                    let imagePanel = Agrume(imageUrl: imageURL)
                    imagePanel.download = { url, completion in
                        let kingFishCacher = UIImageView()
                        kingFishCacher.kf.setImage(with: url, completionHandler:{ (image, error, cacheType, imageUrl) in
                            if let image = image {
                                completion(image)
                            }
                        })
                    }
                    imagePanel.showFrom(self)
                }
            }
        }
        return true
    }
    
    func webViewDidFinishLoad(_ webView: UIWebView) {
        let js = "function addImgClickEvent() { " +
            "var imgs = document.getElementsByClassName('scroll-load-image');" +
            // 遍历所有的img标签，统一加上点击事件
            "for (var i = 0; i < imgs.length; ++i) {" +
            "var img = imgs[i];" +
            "img.onclick = function () {" +
            // 给图片添加URL scheme，以便在拦截时可能识别跳转
            "window.location.href = 'post-image-preview:' + this.src" +
            "}" +
            "}" +
        "}"
        // 注入JS代码
        self.postWebView.stringByEvaluatingJavaScript(from: js)
        
        // 执行所注入的JS
        self.postWebView.stringByEvaluatingJavaScript(from: "addImgClickEvent();")
        spinner.stopAnimating()
    }
    
}
