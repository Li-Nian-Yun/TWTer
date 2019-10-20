//
//  ViewController.swift
//  培训
//
//  Created by 李念韵 on 2019/10/13.
//  Copyright © 2019 李念韵. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    
    
    
    
    let tmp = UIImageView()
    let π = M_PI
    
    @objc func imageUp(image: UIImageView){
        UIView.animate(withDuration: 3, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 0, options: [], animations: {
            self.tmp.frame.origin.y -= 100
        }, completion: nil)
    }
    
    @objc func imageDown(image: UIImageView){
        UIView.animate(withDuration: 3, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 0, options: [], animations: {
            self.tmp.frame.origin.y += 100
        }, completion: nil)
    }
    
    @objc func imageRight(image: UIImageView){
        UIView.animate(withDuration: 3, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 0, options: [], animations: {
            self.tmp.frame.origin.x += 100
        }, completion: nil)
    }

    @objc func imageLeft(image: UIImageView){
        UIView.animate(withDuration: 3, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 0, options: [], animations: {
            self.tmp.frame.origin.x -= 100
        }, completion: nil)
    }

    @objc func imageOrigin(image: UIImageView){
        tmp.frame =  CGRect(x: 107, y: 200, width: 200, height: 200)
    }

    @objc func imageLarge(image: UIImageView){
        UIView.animate(withDuration: 1, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 0, options: [], animations: {
            self.tmp.transform = self.tmp.transform.scaledBy(x: 1.4, y: 1.4)
        }, completion: nil)
    }

    @objc func imageTiny(image: UIImageView){
        UIView.animate(withDuration: 1, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 0, options: [], animations: {
            self.tmp.transform = self.tmp.transform.scaledBy(x: 0.6, y: 0.6)
        }, completion: nil)
    }
    
    @objc func imageTransfom(image: UIImageView){
        UIView.animate(withDuration: 0, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 0, options: [], animations: {
            self.tmp.transform = self.tmp.transform.rotated(by: CGFloat(self.π/2))
        }, completion: nil)
    }

    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
                
    
        
        
        tmp.frame = CGRect(x: 107, y: 200, width: 200, height: 200)
        tmp.image = #imageLiteral(resourceName: "Image")
        tmp.alpha = 1
        tmp.animationDuration=3
        view.addSubview(tmp)
        
        
        
        
        let but1 =  UIButton()
        but1.frame = CGRect(x: 60, y: 600, width:50, height: 50)
        but1.setImage( #imageLiteral(resourceName: "A07C47187D4E09773034F11E087857B7-1"),for: .normal)
        but1.setImage( #imageLiteral(resourceName: "A07C47187D4E09773034F11E087857B7-1"),for: .highlighted)
        but1.addTarget(self, action: #selector(imageLeft(image: )), for: .touchUpInside)
        view.addSubview(but1)
        
        
        let but2 =  UIButton()
        but2.frame = CGRect(x: 160, y: 600, width:50, height: 50)
        but2.setImage( #imageLiteral(resourceName: "A07C47187D4E09773034F11E087857B7-1"),for: .normal)
        but2.setImage( #imageLiteral(resourceName: "A07C47187D4E09773034F11E087857B7-1"),for: .highlighted)
        but2.addTarget(self, action: #selector(imageRight(image: )), for: .touchUpInside)
        view.addSubview(but2)
      
        let but3 =  UIButton()
        but3.frame = CGRect(x: 110, y: 600, width:50, height: 50)
        but3.setImage( #imageLiteral(resourceName: "A07C47187D4E09773034F11E087857B7-1"),for: .normal)
        but3.setImage( #imageLiteral(resourceName: "A07C47187D4E09773034F11E087857B7-1"),for: .highlighted)
        but3.addTarget(self, action: #selector(imageOrigin(image: )), for: .touchUpInside)
        view.addSubview(but3)
        
        let but4 =  UIButton()
        but4.frame = CGRect(x: 110, y: 550, width:50, height: 50)
        but4.setImage( #imageLiteral(resourceName: "A07C47187D4E09773034F11E087857B7-1"),for: .normal)
        but4.setImage( #imageLiteral(resourceName: "A07C47187D4E09773034F11E087857B7-1"),for: .highlighted)
        but4.addTarget(self, action: #selector(imageUp(image: )), for: .touchUpInside)
        view.addSubview(but4)
 
        let but5 =  UIButton()
        but5.frame = CGRect(x: 110, y: 650, width:50, height: 50)
        but5.setImage( #imageLiteral(resourceName: "A07C47187D4E09773034F11E087857B7-1"),for: .normal)
        but5.setImage( #imageLiteral(resourceName: "A07C47187D4E09773034F11E087857B7-1"),for: .highlighted)
        but5.addTarget(self, action: #selector(imageDown(image: )), for: .touchUpInside)
        view.addSubview(but5)
        

        let but6 =  UIButton()
        but6.frame = CGRect(x: 230, y: 600, width:50, height: 50)
        but6.setImage( #imageLiteral(resourceName: "A07C47187D4E09773034F11E087857B7-1"),for: .normal)
        but6.setImage( #imageLiteral(resourceName: "A07C47187D4E09773034F11E087857B7-1"),for: .highlighted)
        but6.addTarget(self, action: #selector(imageLarge(image:)), for: .touchUpInside)
        view.addSubview(but6)

        let but7 =  UIButton()
        but7.frame = CGRect(x: 330, y: 600, width:50, height: 50)
        but7.setImage( #imageLiteral(resourceName: "A07C47187D4E09773034F11E087857B7-1"),for: .normal)
        but7.setImage( #imageLiteral(resourceName: "A07C47187D4E09773034F11E087857B7-1"),for: .highlighted)
        but7.addTarget(self, action: #selector(imageTiny(image:)), for: .touchUpInside)
        view.addSubview(but7)
        
        let but8 =  UIButton()
        but8.frame = CGRect(x: 280, y: 600, width:50, height: 50)
        but8.setImage( #imageLiteral(resourceName: "A07C47187D4E09773034F11E087857B7-1"),for: .normal)
        but8.setImage( #imageLiteral(resourceName: "A07C47187D4E09773034F11E087857B7-1"),for: .highlighted)
        but8.addTarget(self, action: #selector(imageTransfom(image:)), for: .touchUpInside)
        view.addSubview(but8)


        }
    }
    

