//
//  MainTabBarController.swift
//  U17Comics
//
//  Created by qianfeng on 16/10/21.
//  Copyright © 2016年 zhb. All rights reserved.
//

import UIKit
import SnapKit

class MainTabBarController: UITabBarController {

    private var bgView: UIView?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        createViewControllers()
    }

    
    func createViewControllers() {
        let nameArray = ["HomePageViewController","SearchViewController"]
        let imageArray = ["tabbar_comic","tabbar_Special"]
        let titleArray = ["首页","分类"]
//        let nameArray = ["HomePageViewController","SearchViewController","BookShelfViewController","ProfileViewController"]
//        let imageArray = ["tabbar_comic","tabbar_Special","tabbar_collection","tabbar_mine"]
//        let titleArray = ["首页","分类","书架","我的"]
        var ctrlArray = Array<UINavigationController>()
        for i in 0..<nameArray.count {
            let name = "UM7Comics."+nameArray[i]
            let ctrl = NSClassFromString(name) as! UIViewController.Type
            let vc = ctrl.init()
            let navCtrl = UINavigationController(rootViewController: vc)
            ctrlArray.append(navCtrl)
        }
        viewControllers = ctrlArray
        //隐藏系统的tabbar
        tabBar.hidden = true
        createMyTabBar(imageArray,titles: titleArray)
    }
    
    func createMyTabBar(imageNames: Array<String>, titles: Array<String>) {
        bgView = UIView.createView()
        bgView?.backgroundColor = UIColor.whiteColor()
        view.addSubview(bgView!)
        bgView?.snp_makeConstraints(closure: { [weak self](make) in
            make.left.right.bottom.equalTo(self!.view)
            make.height.equalTo(49)
        })
        
        let width = screenWidth/CGFloat(imageNames.count)
        for i in 0..<imageNames.count {
            //首先创建2个按钮添加视图
            let btnView = UIView.createView()
            bgView?.addSubview(btnView)
            
            btnView.snp_makeConstraints(closure: { (make) in
                make.top.bottom.equalTo(bgView!)
                make.width.equalTo(width)
                make.left.equalTo(width*CGFloat(i))
            })
            //循环创建按钮
            let imageName = imageNames[i]+"_normal"
            let selectName = imageNames[i]+"_selected"
            let btn = UIButton.createBtn(nil, normalImage: imageName, highlightImage: nil, selectImage: selectName, target: self, action: #selector(btnClick(_:)))
            btn.tag = 100+i
            btn.adjustsImageWhenHighlighted = false//禁用高亮
            bgView?.addSubview(btn)
            btn.snp_makeConstraints(closure: { (make) in
                make.top.bottom.equalTo(btnView)
                make.centerX.equalTo(btnView)
                make.width.equalTo(80)
            })
            
            let titleLabel = UILabel.createLabel(titles[i], textAlignment: .Center, font: UIFont.systemFontOfSize(10))
            titleLabel.textColor = UIColor.lightGrayColor()
            titleLabel.backgroundColor = UIColor.whiteColor()
            titleLabel.tag = 400
            btn.addSubview(titleLabel)
            
            titleLabel.snp_makeConstraints(closure: { (make) in
                make.left.right.bottom.equalTo(btn)
                make.height.equalTo(12)
            })
            //默认选中第一个按钮
            if i == 0 {
                btn.selected = true
                titleLabel.textColor = UIColor.redColor()
            }
        }
    }
    
    func showTabBar() {
        UIView.animateWithDuration(0.25) { [weak self] in
            self!.bgView?.hidden = false
        }
    }
    
    func hideTabBar() {
        UIView.animateWithDuration(0.25) { [weak self] in
            self!.bgView?.hidden = true
        }
    }
    
    func btnClick(curBtn: UIButton) {
        let index = curBtn.tag-100
        //1.1 获取取消选中之前的按钮
        let lastBtn = bgView?.viewWithTag(100+selectedIndex) as! UIButton
        lastBtn.selected = false
        lastBtn.userInteractionEnabled = true
        
        let lastLabel = lastBtn.viewWithTag(400) as! UILabel
        lastLabel.textColor = UIColor.lightGrayColor()
        
        //1.2选中当前按钮
        curBtn.selected = true
        selectedIndex = index
        curBtn.userInteractionEnabled = false
        let  curLabel = curBtn.viewWithTag(400) as! UILabel
        curLabel.textColor = UIColor.redColor()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}
