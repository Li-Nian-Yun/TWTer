////
////  PageControlView.swift
////  知乎日报1.0
////
////  Created by 李念韵 on 2019/12/7.
////  Copyright © 2019 李念韵. All rights reserved.
//
import UIKit

protocol SliderGalleryControllerDelegate{
    //获取数据源
    func galleryDataSourceUrl()->[String]
    func galleryDataSourceTitle()->[String]
    //获取内部scrollerView的宽高尺寸
    func galleryScrollerViewSize()->CGSize
}
 
//图片轮播组件控制器
class SliderGalleryController: UIViewController,UIScrollViewDelegate{
    //代理对象
    var delegate : SliderGalleryControllerDelegate!

    //屏幕宽度
    let kScreenWidth = UIScreen.main.bounds.size.width

    //当前展示的图片索引
    var currentIndex : Int = 0

    //数据源 url和title
    var dataSource : [String]?
    var dataSourceTitle : [String]?

    //用于轮播的左中右三个image（不管几张图片都是这三个imageView交替使用）
    var leftImageView , middleImageView , rightImageView : UIImageView?
    var leftLabel , middleLabel , rightLabel : UILabel?
    //放置imageView的滚动视图
    var scrollerView : UIScrollView?

    //scrollView的宽和高
    var scrollerViewWidth : CGFloat?
    var scrollerViewHeight : CGFloat?

    //页控制器（小圆点）
    var pageControl : UIPageControl?
    
    //自动滚动计时器
    var autoScrollTimer:Timer?

    override func viewDidLoad() {
        super.viewDidLoad()

        //获取并设置scrollerView尺寸
        let size : CGSize = self.delegate.galleryScrollerViewSize()
        self.scrollerViewWidth = size.width
        self.scrollerViewHeight = size.height

        //获取数据
        self.dataSource =  self.delegate.galleryDataSourceUrl()
        self.dataSourceTitle = self.delegate.galleryDataSourceTitle()
        //设置scrollerView
        self.configureScrollerView()
        //设置imageView
        self.configureImageView()
        //设置页控制器
        self.configurePageController()
        //设置自动滚动计时器
        self.configureAutoScrollTimer()

        self.view.backgroundColor = UIColor.white
    }

    //设置scrollerView
    func configureScrollerView(){
        self.scrollerView = UIScrollView(frame: CGRect(x: 0,y: 0,
                width: self.scrollerViewWidth!, height: self.scrollerViewHeight!))
        self.scrollerView?.backgroundColor = UIColor.white
        self.scrollerView?.delegate = self
        self.scrollerView?.contentSize = CGSize(width: self.scrollerViewWidth! * 3, height: self.scrollerViewHeight!)
        //滚动视图内容区域向左偏移一个view的宽度
        self.scrollerView?.contentOffset = CGPoint(x: self.scrollerViewWidth!, y: 0)
        self.scrollerView?.isPagingEnabled = true
        self.scrollerView?.bounces = false
        self.view.addSubview(self.scrollerView!)
    }

    //设置imageView
    func configureImageView(){
        self.leftImageView = UIImageView(frame: CGRect(x: 0, y: 0,
                    width: self.scrollerViewWidth!, height: self.scrollerViewHeight!))
        self.middleImageView = UIImageView(frame: CGRect(x: self.scrollerViewWidth!, y: 0,
                    width: self.scrollerViewWidth!, height: self.scrollerViewHeight! ));
        self.rightImageView = UIImageView(frame: CGRect(x: 2*self.scrollerViewWidth!, y: 0,
                    width: self.scrollerViewWidth!, height: self.scrollerViewHeight!));
        self.scrollerView?.showsHorizontalScrollIndicator = false
    //设置初始时左中右三个imageView的图片（分别是数据源中最后一张，第一张，第二张图片）
        if(self.dataSource?.count != 0){
            resetImageViewSource()
        }
        
        self.middleLabel = UILabel(frame: CGRect(x: self.scrollerViewWidth!, y: self.scrollerViewHeight!/3*2,
        width: self.scrollerViewWidth!, height: self.scrollerViewHeight!/3*1))
        middleLabel?.font = UIFont.boldSystemFont(ofSize: 30)
        middleLabel?.backgroundColor = UIColor .clear
//        middleLabel?.textColor = UIColor .white
        
        self.rightLabel = UILabel(frame: CGRect(x: 2*self.scrollerViewWidth!, y: self.scrollerViewHeight!/3*2,
        width: self.scrollerViewWidth!, height: self.scrollerViewHeight!/3*1))
        rightLabel?.font = UIFont.boldSystemFont(ofSize: 30)
        rightLabel?.backgroundColor = UIColor .clear
//        rightLabel?.textColor = UIColor .white
        
        self.leftLabel = UILabel(frame: CGRect(x: 0, y: self.scrollerViewHeight!/3*2,
        width: self.scrollerViewWidth!, height: self.scrollerViewHeight!/3*1))
        leftLabel?.font = UIFont.boldSystemFont(ofSize: 30)
        leftLabel?.backgroundColor = UIColor .clear
//        leftLabel?.textColor = UIColor .white
        
        self.scrollerView?.addSubview(self.leftImageView!)
        self.scrollerView?.addSubview(self.middleImageView!)
        self.scrollerView?.addSubview(self.rightImageView!)
        self.scrollerView?.addSubview(self.middleLabel!)
        self.scrollerView?.addSubview(self.rightLabel!)
        self.scrollerView?.addSubview(self.leftLabel!)
    }

    //设置页控制器
    func configurePageController() {
        self.pageControl = UIPageControl(frame: CGRect(x: kScreenWidth/2-60,
                        y: self.scrollerViewHeight! - 20, width: 120, height: 20))
        self.pageControl?.numberOfPages = (self.dataSource?.count)!
        self.pageControl?.isUserInteractionEnabled = false
        self.view.addSubview(self.pageControl!)
    }

    //设置自动滚动计时器
    func configureAutoScrollTimer() {
        //设置一个定时器，每三秒钟滚动一次
        autoScrollTimer = Timer.scheduledTimer(timeInterval: 3, target: self,
                    selector: #selector(SliderGalleryController.letItScroll),
                    userInfo: nil, repeats: true)
    }

    //计时器时间一到，滚动一张图片
    @objc func letItScroll(){
        let offset = CGPoint(x: 2*scrollerViewWidth!, y: 0)
        self.scrollerView?.setContentOffset(offset, animated: true)
    }

    //每当滚动后重新设置各个imageView的图片
    func resetImageViewSource() {
        let imgUrlError =
        "https://pic4.zhimg.com/05ed7f110ed96b938483132871e2a343.jpg"
//        当前显示的是第一张图片
        if self.currentIndex == 0 {
            let imgUrl = dataSource?[0] ?? imgUrlError
            let url = URL(string: imgUrl)
            do{
                let data = try Data(contentsOf: url!)
                middleImageView?.image = UIImage(data:data)
            }catch let error as NSError{
                print(error)
            }
            let imgUrlRight = dataSource?[1] ?? imgUrlError
            let urlRight = URL(string: imgUrlRight)
            do{
                let data = try Data(contentsOf: urlRight!)
                rightImageView?.image = UIImage(data:data)
            }catch let error as NSError{
                print(error)
            }
            let imgUrlLeft = dataSource?[4] ?? imgUrlError
            let urlLeft = URL(string: imgUrlLeft)
            do{
                let data = try Data(contentsOf: urlLeft!)
                leftImageView?.image = UIImage(data:data)
            }catch let error as NSError{
                print(error)
            }
            middleLabel?.text = dataSourceTitle?[0] ?? "hello"
            rightLabel?.text = dataSourceTitle?[1] ?? "hello"
            leftLabel?.text = dataSourceTitle?[4] ?? "hello"
        }
        //当前显示的是最后一张图片
        else if self.currentIndex == (self.dataSource?.count)! - 1 {
            let imgUrl = dataSource?[4] ?? imgUrlError
            let url = URL(string: imgUrl)
            do{
                let data = try Data(contentsOf: url!)
                middleImageView?.image = UIImage(data:data)
            }catch let error as NSError{
                print(error)
            }
            let imgUrlRight = dataSource?[0] ?? imgUrlError
            let urlRight = URL(string: imgUrlRight)
            do{
                let data = try Data(contentsOf: urlRight!)
                rightImageView?.image = UIImage(data:data)
            }catch let error as NSError{
                print(error)
            }
            let imgUrlLeft = dataSource?[1] ?? imgUrlError
            let urlLeft = URL(string: imgUrlLeft)
            do{
                let data = try Data(contentsOf: urlLeft!)
                leftImageView?.image = UIImage(data:data)
            }catch let error as NSError{
                print(error)
            }
            middleLabel?.text = dataSourceTitle?[4] ?? "hello"
            rightLabel?.text = dataSourceTitle?[0] ?? "hello"
            leftLabel?.text = dataSourceTitle?[3] ?? "hello"
        }
        //其他情况
        else{
            let imgUrl = dataSource?[currentIndex] ?? imgUrlError
            let url = URL(string: imgUrl)
            do{
                let data = try Data(contentsOf: url!)
                middleImageView?.image = UIImage(data:data)
            }catch let error as NSError{
                print(error)
            }
            let imgUrlRight = dataSource?[currentIndex+1] ?? imgUrlError
            let urlRight = URL(string: imgUrlRight)
            do{
                let data = try Data(contentsOf: urlRight!)
                rightImageView?.image = UIImage(data:data)
            }catch let error as NSError{
                print(error)
            }
            let imgUrlLeft = dataSource?[currentIndex-1] ?? imgUrlError
            let urlLeft = URL(string: imgUrlLeft)
            do{
                let data = try Data(contentsOf: urlLeft!)
                leftImageView?.image = UIImage(data:data)
            }catch let error as NSError{
                print(error)
            }
            middleLabel?.text = dataSourceTitle?[currentIndex] ?? "hello"
            rightLabel?.text = dataSourceTitle?[currentIndex+1] ?? "hello"
            leftLabel?.text = dataSourceTitle?[currentIndex-1] ?? "hello"
        }
    }

    //scrollView滚动完毕后触发
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        //获取当前偏移量
        let offset = scrollView.contentOffset.x

        if(self.dataSource?.count != 0){

            //如果向左滑动（显示下一张）
            if(offset >= self.scrollerViewWidth!*2){
                //还原偏移量
                scrollView.contentOffset = CGPoint(x: self.scrollerViewWidth!, y: 0)
                //视图索引+1
                self.currentIndex = self.currentIndex + 1

                if self.currentIndex == self.dataSource?.count {
                    self.currentIndex = 0
                }
            }

            //如果向右滑动（显示上一张）
            if(offset <= 0){
                //还原偏移量
                scrollView.contentOffset = CGPoint(x: self.scrollerViewWidth!, y: 0)
                //视图索引-1
                self.currentIndex = self.currentIndex - 1

                if self.currentIndex == -1 {
                    self.currentIndex = (self.dataSource?.count)! - 1
                }
            }

            //重新设置各个imageView的图片
            resetImageViewSource()
            //设置页控制器当前页码
            self.pageControl?.currentPage = self.currentIndex
        }
    }

    //手动拖拽滚动开始
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        //使自动滚动计时器失效（防止用户手动移动图片的时候这边也在自动滚动）
        autoScrollTimer?.invalidate()
    }

    //手动拖拽滚动结束
    func scrollViewDidEndDragging(_ scrollView: UIScrollView,
                                  willDecelerate decelerate: Bool) {
        //重新启动自动滚动计时器
        configureAutoScrollTimer()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
