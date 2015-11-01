//
//  ViewController.swift
//  PageMenuDemoStoryboard
//
//  Created by Niklas Fahl on 12/19/14.
//  Copyright (c) 2014 CAPS. All rights reserved.
//

import UIKit
import DOFavoriteButton
import NZAlertView



class ViewController: UIViewController {
    
    var pageMenu : CAPSPageMenu?
    var region:String=""
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        
        // MARK: - UI Setup
        
    }
    
    override func viewDidLoad() {
        self.title = "Adjaranet"
        
        do{
            RestApiManager.sharedInstance.getMyRegion({
                json in let results = json
                self.region=results["country"].string!
                
                
                dispatch_async(dispatch_get_main_queue(),{
                    print(self.region)
                    if self.region=="Georgia"{
                        self.navigationController?.navigationBar.barTintColor = UIColor(red: 0.0, green: 0.514, blue: 0.792, alpha: 1)
                        self.navigationController?.navigationBar.shadowImage = UIImage()
                        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), forBarMetrics: UIBarMetrics.Default)
                        self.navigationController?.navigationBar.barStyle = UIBarStyle.Default
                        self.navigationController?.navigationBar.tintColor = UIColor.whiteColor()
                        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.whiteColor()]
                        
                        
                        
                        
                        // MARK: - Scroll menu setup
                        
                        // Initialize view controllers to display and place in array
                        var controllerArray : [UIViewController] = []
                        
                        let controller4 : TestViewController = TestViewController(nibName: "TestViewController", bundle: nil)
                        controller4.navigation=self.navigationController
                        controller4.title = "მთავარი"
                        
                        controllerArray.append(controller4)
                        let controller1 : TestTableViewController = TestTableViewController(nibName: "TestTableViewController", bundle: nil)
                        controller1.title = "ფილმები"
                        controller1.navigation=self.navigationController
                        controllerArray.append(controller1)
                        let controller3 : svc = svc(nibName: "svc", bundle: nil)
                        controller3.title = "სერიალები"
                        controller3.navigation=self.navigationController
                        controllerArray.append(controller3)
                        let controller2 : TestCollectionViewController = TestCollectionViewController(nibName: "TestCollectionViewController", bundle: nil)
                        controller2.title = "კოლექციები"
                        controller2.navigation=self.navigationController
                        controllerArray.append(controller2)
                        
                        
                        
                        // Customize menu (Optional)
                        let parameters: [CAPSPageMenuOption] = [
                            .ScrollMenuBackgroundColor(UIColor(red: 0.0, green: 0.514, blue: 0.792, alpha: 1)),
                            .ViewBackgroundColor(UIColor.whiteColor()),
                            .SelectionIndicatorColor(UIColor.whiteColor()),
                            .BottomMenuHairlineColor(UIColor.whiteColor()),
                            .MenuItemFont(UIFont(name: "HelveticaNeue", size: 15.0)!),
                            .MenuHeight(40.0),
                            .MenuItemWidth(110.0),
                            .CenterMenuItems(true)
                        ]
                        
                        
                        // Initialize scroll menu
                        self.pageMenu = CAPSPageMenu(viewControllers: controllerArray, frame: CGRectMake(0.0, 0.0, self.view.frame.width, self.view.frame.height), pageMenuOptions: parameters)
                        
                        self.view.addSubview(self.pageMenu!.view)
                    }
                })
            })
        }catch _{
            
        }
        
        
        
        
        
        
        
    }
    
    func didTapGoToLeft() {
        let currentIndex = pageMenu!.currentPageIndex
        
        if currentIndex > 0 {
            pageMenu!.moveToPage(currentIndex - 1)
        }
    }
    
    func didTapGoToRight() {
        let currentIndex = pageMenu!.currentPageIndex
        
        if currentIndex < pageMenu!.controllerArray.count {
            pageMenu!.moveToPage(currentIndex + 1)
        }
    }
}


