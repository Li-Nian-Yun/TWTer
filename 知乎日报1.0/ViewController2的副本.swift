//
//  ViewController2.swift
//  知乎日报1.0
//
//  Created by 李念韵 on 2019/11/30.
//  Copyright © 2019 李念韵. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import MJRefresh
import SDWebImage
import WebKit

class ViewController2: UIViewController {
    fileprivate var dataModel:Main?
    fileprivate var currentTabelView:UITableView?
    fileprivate var detailDataModel:DetailData?
    fileprivate var dataArray:NSMutableArray?
    let header = MJRefreshNormalHeader()
    var webView = WKWebView()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.progressView.frame = CGRect(x:0,y:64,width:self.view.frame.size.width,height:2)
        self.progressView.isHidden = false
        UIView.animate(withDuration: 1.0) {
            self.progressView.progress = 0.0
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.white
        navigationItem.title = "知乎日报"
        navigationItem.rightBarButtonItem = UIBarButtonItem(title:"评论",style: UIBarButtonItem.Style.plain,target:self, action: #selector(pushComment(comment:)))
        
        loadNewData()
        initWebview()
    }
    
    func initWebview(){
        let url = detailDataModel?.url ?? "https://daily.zhihu.com/story/9717824"
        webView = WKWebView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: UIScreen.main.bounds.size.height))
        view.addSubview(webView)
        webView.navigationDelegate = self
        let mapwayURL = URL(string: url)!
        let mapwayRequest = URLRequest(url: mapwayURL)
        webView.load(mapwayRequest)
        view.addSubview(self.progressView)
    }
    
    //    进度条
    lazy var progressView:UIProgressView = {
        let progress = UIProgressView()
        progress.progressTintColor = UIColor.orange
        progress.trackTintColor = .clear
        return progress
    }()
    
    func loadNewData(){
        let urlString = "https://news-at.zhihu.com/api/4/news/" + String(rowIndex.id)
        let parameters:[String : Any] = [:]
        weak var weakSelf = self
            SwiftNetWorkManager.sharedInstance.getRequest(urlString, params:parameters, success: { (dictResponse) in
            weakSelf?.currentTabelView?.mj_header?.endRefreshing()
                let loaclData = dictResponse as Data
                do {
                    weakSelf?.detailDataModel = try JSONDecoder().decode(DetailData.self, from: loaclData)
                    weakSelf?.currentTabelView?.reloadData()
                    self.initWebview()
                    self.webView.reload()
                } catch {
                    print("error")
                }
            }) { (error) in
                    print("错误")
            }
    }
    
    @objc func pushComment(comment:UIBarButtonItem){
        navigationController?.pushViewController(commentViewController(), animated: true)
    }
}

extension ViewController2:WKNavigationDelegate{
    // 页面开始加载时调用
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!){
        self.navigationItem.title = "加载中..."
        /// 获取网页的progress
        UIView.animate(withDuration: 0.5) {
            self.progressView.progress = Float(self.webView.estimatedProgress)
        }
    }
    
    // 当内容开始返回时调用
    func webView(_ webView: WKWebView, didCommit navigation: WKNavigation!){
        
    }
    
    // 页面加载完成之后调用
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!){
        /// 获取网页title
        self.title = self.webView.title
        
        UIView.animate(withDuration: 0.5) {
            self.progressView.progress = 1.0
            self.progressView.isHidden = true
        }
    }
    
    // 页面加载失败时调用
    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error){
        UIView.animate(withDuration: 0.5) {
            self.progressView.progress = 0.0
            self.progressView.isHidden = true
        }
        let alertView = UIAlertController.init(title: "提示", message: "加载失败", preferredStyle: .alert)
        let okAction = UIAlertAction.init(title:"确定", style: .default) { okAction in
            _=self.navigationController?.popViewController(animated: true)
        }
        alertView.addAction(okAction)
        self.present(alertView, animated: true, completion: nil)
    }
}

