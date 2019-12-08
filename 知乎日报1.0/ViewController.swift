//
//  ViewController.swift
//  知乎日报1.0
//
//  Created by 李念韵 on 2019/11/26.
//  Copyright © 2019 李念韵. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import MJRefresh
import SDWebImage
import WebKit

class ViewController: UIViewController,SliderGalleryControllerDelegate {
    
    //获取屏幕宽度
    let screenWidth =  UIScreen.main.bounds.size.width
     
    //图片轮播组件
    var sliderGallery : SliderGalleryController!

    
    fileprivate var currentTabelView:UITableView?
    fileprivate var dataModel:Main?
    fileprivate var dataArray:NSMutableArray?
    
    
    let imgUrlError =
    "https://pic4.zhimg.com/05ed7f110ed96b938483132871e2a343.jpg"
    let header = MJRefreshNormalHeader()
    let pageControl = UIPageControl(frame: CGRect(x: 0, y: 50, width: 500, height: 150))
    var TableView = UITableView()
    var scrollView = UIScrollView(frame:CGRect(x: 0, y: 50, width: 420, height: 280))
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        navigationItem.title = "知乎日报"
        loadNewData()
        initTable()
        scrollView.isPagingEnabled = true
        //        initPageControl()
        header.setRefreshingTarget(self, refreshingAction: #selector(ViewController.headerRefresh))
        self.TableView.mj_header = header
        self.TableView.reloadData()
    }
    
    //初始化
    func initPageControl(){
        pageControl.numberOfPages = 5
        pageControl.pageIndicatorTintColor = UIColor .green
        pageControl.backgroundColor = UIColor .black
        pageControl.currentPage = 3
        self.view.addSubview(pageControl)
    }
    
    func initTable(){
        TableView = UITableView(frame: CGRect(x: 0, y:300, width: view.frame.width, height: view.frame.height),style: .grouped)
        TableView.delegate = self as? UITableViewDelegate
        TableView.dataSource = self as? UITableViewDataSource
        TableView.allowsSelection = true
        TableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        view.addSubview(TableView)
    }
    
    func initSliderGallery(){
        //初始化图片轮播组件
        sliderGallery = SliderGalleryController()
        sliderGallery.delegate = self
        sliderGallery.view.frame = CGRect(x: 0, y: 40, width: screenWidth-10,height: (screenWidth-20)/4*3)
         
        //将图片轮播组件添加到当前视图
        self.addChild(sliderGallery)
        self.view.addSubview(sliderGallery.view)
        
        //添加组件的点击事件
        let tap = UITapGestureRecognizer(target: self,
                        action: #selector(ViewController.handleTapAction(_:)))
        sliderGallery.view.addGestureRecognizer(tap)
    }
    
    
    //下拉刷新
    @objc func headerRefresh(){
        sleep(1)
        loadNewData()
        initSliderGallery()
        self.TableView.reloadData()
        header.endRefreshing()
    }
    //加载数据
    func loadNewData(){
        let urlString = "https://news-at.zhihu.com/api/4/news/latest"
        let parameters:[String : Any] = [:]
        weak var weakSelf = self
            SwiftNetWorkManager.sharedInstance.getRequest(urlString, params: parameters, success: { (dictResponse) in
                weakSelf?.currentTabelView?.mj_header?.endRefreshing()
                let loaclData = dictResponse as Data
                do {
                    weakSelf?.dataModel = try JSONDecoder().decode(Main.self, from: loaclData)
                    weakSelf?.currentTabelView?.reloadData()
                    self.initSliderGallery()
                    self.TableView.reloadData()
                } catch {
                    print("error")
                }
            }) { (error) in
                    print("错误")
            }
        
        }
    func galleryScrollerViewSize() -> CGSize {
        return CGSize(width: screenWidth, height: (screenWidth-20)/4*3)
    }
     
    //图片轮播组件协议方法：获取数据集合
    func galleryDataSourceUrl() -> [String] {
        return [(dataModel?.topStories[0].image ?? imgUrlError),(dataModel?.topStories[1].image ?? imgUrlError),(dataModel?.topStories[2].image ?? imgUrlError),(dataModel?.topStories[3].image ?? imgUrlError),(dataModel?.topStories[4].image ?? imgUrlError)]
    }
    
    func galleryDataSourceTitle()->[String]{
        return[dataModel?.topStories[0].title ?? "",
               dataModel?.topStories[1].title ?? "",
               dataModel?.topStories[2].title ?? "",
               dataModel?.topStories[3].title ?? "",
               dataModel?.topStories[4].title ?? ""
        ]
    }
    
    @objc func handleTapAction(_ tap:UITapGestureRecognizer)->Void{
        //获取图片索引值
        rowIndex.index = sliderGallery.currentIndex
        rowIndex.id = dataModel!.topStories[rowIndex.index].id
        navigationController?.pushViewController(ViewController2(), animated: true)
    }
    
}

extension ViewController:UITableViewDelegate,UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let identify:String = "cell"
        let cell = tableView.dequeueReusableCell(withIdentifier: identify, for: indexPath)
        as UITableViewCell
        cell.accessoryType = .disclosureIndicator
        cell.textLabel?.text = dataModel?.stories[indexPath.row].title ?? "数据还没来，刷新一下试试"
        
        let imgUrlError =
        "https://pic4.zhimg.com/05ed7f110ed96b938483132871e2a343.jpg"
        let imgUrl = dataModel?.stories[indexPath.row].images?[0]
        let url = URL(string: imgUrl ?? imgUrlError)
        do{
            let data = try Data(contentsOf: url!)
            cell.imageView?.image = UIImage(data:data)
        }catch let error as NSError{
            print(error)
        }
        
        cell.textLabel?.font = UIFont.systemFont(ofSize: 20)//字体大小
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.dataModel?.stories.count ?? 3
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        rowIndex.index = indexPath.row
        rowIndex.id = dataModel!.stories[rowIndex.index].id
        navigationController?.pushViewController(ViewController2(), animated: true)
        tableView.deselectRow(at: indexPath, animated: true)
       }
    
}
