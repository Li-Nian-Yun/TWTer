//
//  commentViewcontroller.swift
//  知乎日报1.0
//
//  Created by 李念韵 on 2019/12/8.
//  Copyright © 2019 李念韵. All rights reserved.
//
import UIKit
import Alamofire
import SwiftyJSON
import MJRefresh
import SDWebImage
import WebKit

class commentViewController: UIViewController {

    fileprivate var currentTabelView:UITableView?
    fileprivate var dataModel:Main?
    fileprivate var dataArray:NSMutableArray?
    fileprivate var dataDetailComment:DetailDataComment?
    let imgUrlError =
    "https://pic4.zhimg.com/05ed7f110ed96b938483132871e2a343.jpg"
    let header = MJRefreshNormalHeader()
    var TableView = UITableView()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        navigationItem.title = "知乎日报"
        loadNewDataComment()
        initTable()
        header.setRefreshingTarget(self, refreshingAction: #selector(ViewController.headerRefresh))
        self.TableView.mj_header = header
        self.TableView.reloadData()
    }
    
    //初始化
    func initTable(){
        TableView = UITableView(frame: CGRect(x: 0, y:0, width: view.frame.width, height: view.frame.height),style: .grouped)
        TableView.delegate = self as? UITableViewDelegate
        TableView.dataSource = self as? UITableViewDataSource
        TableView.allowsSelection = true
        TableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        view.addSubview(TableView)
    }
    
    //下拉刷新
    @objc func headerRefresh(){
        sleep(1)
        loadNewDataComment()
        self.TableView.reloadData()
        header.endRefreshing()
    }
    //加载数据
    func loadNewDataComment(){
        let urlString = "https://news-at.zhihu.com/api/4/story/"+String(rowIndex.id)+"/comments"
        let parameters:[String : Any] = [:]
        weak var weakSelf = self
            SwiftNetWorkManager.sharedInstance.getRequest(urlString, params:parameters, success: { (dictResponse) in
            weakSelf?.currentTabelView?.mj_header?.endRefreshing()
                let loaclData = dictResponse as Data
                do {
                    weakSelf?.dataDetailComment = try JSONDecoder().decode(DetailDataComment.self, from: loaclData)
                    weakSelf?.currentTabelView?.reloadData()
                    self.TableView.reloadData()
                } catch {
                    print("error")
                }
            }) { (error) in
                    print("错误")
            }
    }
}

extension commentViewController:UITableViewDelegate,UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let identify:String = "cell"
        let cell = tableView.dequeueReusableCell(withIdentifier: identify, for: indexPath)
        as UITableViewCell
        cell.accessoryType = .disclosureIndicator
        cell.textLabel?.text = dataDetailComment?.comments[indexPath.row].content ?? "数据还没来，刷新一下试试"
        
        cell.textLabel?.font = UIFont.systemFont(ofSize: 15)//字体大小
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.dataDetailComment?.comments.count ?? 3
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        rowIndex.index = indexPath.row
        navigationController?.pushViewController(ViewController2(), animated: true)
        tableView.deselectRow(at: indexPath, animated: true)
       }
    
}
