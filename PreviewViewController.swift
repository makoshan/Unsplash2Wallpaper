//
//  PreviewViewController.swift
//  BeautifulBackground
//
//  Created by ShanMako on 15/11/20.
//  Copyright © 2015年 jinjunhyuk. All rights reserved.
//

import UIKit

class PreviewViewController: UIViewController{
    let image:UIImage
    
    init(image:UIImage){
        self.image=image
     
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        UIApplication.sharedApplication().setStatusBarHidden(true, withAnimation: UIStatusBarAnimation.None)
        
        let images = UIImageView(frame: CGRect(x: 0, y: 0, width: UIDevice.deviceScreenWidth, height: UIDevice.deviceScreenHeight))
       
        images.userInteractionEnabled=true
        let single: UITapGestureRecognizer=UITapGestureRecognizer(target: self, action: "cancel")
        images.addGestureRecognizer(single)
        
        let finalSize=CGSize(width: UIDevice.deviceScreenWidth, height: UIDevice.deviceScreenHeight)
        UIGraphicsBeginImageContextWithOptions(finalSize, false, 1)
        self.image.drawInRect(CGRectMake(0, 0, finalSize.width,finalSize.height))
        let size=CGRectMake(0, 0, UIDevice.deviceScreenWidth, UIDevice.deviceScreenHeight)
        UIImage(named: "Home")!.drawInRect(size)
        let outPutImage:UIImage=UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
         images.image=outPutImage
        self.view.addSubview(images)
    }
    func cancel(){
        self.dismissViewControllerAnimated(true, completion: nil)
    
    }
    

}