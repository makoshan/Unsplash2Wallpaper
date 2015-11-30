import UIKit
import Alamofire
import SwiftyJSON
import Kingfisher
import  MJRefresh

class ThemeList {
    var id:String!
    var keyword:String?
    var smallUrl:String?
    var fullsizeUrl:String?
    var width:Int?
    var height:Int?
    var color:String!
    var downloads:Int!
    var likes:Int!
}

class MainViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UIScrollViewDelegate,PECropViewControllerDelegate {
    
    //@IBOutlet weak var tableViews: UITableView!
    let Url : String = "http://133.130.125.179:8080/unsplashs/"
    let key : String = "29a307bccd8555abb09dcd36bbc3e014bad09e75e18c18ae369eb338b2a01f4a"
    let perPage:String = "5"
    var themeLists:[ThemeList] = []
    var selectedRow:Int?
    var page:Int = 1
    var controller=PECropViewController()
    var tumblrHUD:AMTumblrHud=AMTumblrHud()
    @IBOutlet weak var tableViews: UITableView!
    
    let refresh:UIRefreshControl=UIRefreshControl()
    override func viewDidLoad() {
        super.viewDidLoad()
        UIApplication.sharedApplication().statusBarStyle = .LightContent
        let height=UIDevice.deviceScreenHeight/2-10
        let width=UIDevice.deviceScreenWidth/2-26
        self.tumblrHUD=AMTumblrHud(frame: CGRectMake(width, height, 55, 20))
        self.tumblrHUD.hudColor=UIColor.UIColorFromRGB(0xF1F2F3)
        self.view.addSubview(tumblrHUD)
        tumblrHUD.hidden=true
        tableViews.delegate = self
        tableViews.dataSource = self
        setBackground(page)
        self.setNavigationBar()
        // 设置回调（一旦进入刷新状态，就调用target的action，也就是调用self的loadNewData方法）
        let header:MJRefreshGifHeader = MJRefreshGifHeader(refreshingTarget: self, refreshingAction: "loadNewData")
        // 设置自动切换透明度(在导航栏下面自动隐藏)
        header.automaticallyChangeAlpha = false
        // 隐藏时间
        header.lastUpdatedTimeLabel?.hidden=true
        // 设置header
        self.tableViews.mj_header = header
        // 设置footer
        self.tableViews.mj_footer = MJRefreshAutoNormalFooter(refreshingTarget: self, refreshingAction: "loadNewData")
    }
    func loadNewData(){
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, Int64(2 * Double(NSEC_PER_SEC))), dispatch_get_main_queue()) { () -> Void in
            // 刷新表格
            self.tableViews.reloadData()
            // 拿到当前的下拉刷新控件，结束刷新状态
            self.tableViews.mj_header.endRefreshing()
        }
        
    }
    
    
    //设置toolbar点击事件
    func setNavigationBar(){
        self.navigationController?.navigationBar.setBackgroundImage(UIDevice.imageWithColor(UIColor.UIColorFromRGB(0xFFB212).colorWithAlphaComponent(1)) , forBarMetrics: UIBarMetrics.Default)
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.themeLists.count
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        //        let width = CGFloat(self.themeLists[indexPath.row].width!)
        //        let height = CGFloat(self.themeLists[indexPath.row].height!)
        //
        //        let newWidth = self.view.bounds.width
        //        let newHeight = (height / width) * newWidth
        //        if height > 0 {
        //            return CGFloat(newHeight)
        //        } else {
        //            return 200.0
        //        }
        return 220.0
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("cell")!
        
        if let backgroundUrl = self.themeLists[indexPath.row].smallUrl {
            let imageView = NSBundle.mainBundle().loadNibNamed("ImageList", owner: self, options: nil)[0] as! ImageList
            
            imageView.frame = cell.bounds
            let  placeholder=UIDevice.imageWithColor(UIColor.UIColorFromRGB(0xFFFFFF).colorWithAlphaComponent(1))
            imageView.imageViewDetail.kf_setImageWithURL(NSURL(string: backgroundUrl)!, placeholderImage: placeholder, optionsInfo: [.Transition(ImageTransition.Fade(0.2))], completionHandler: { action in
                UIApplication.sharedApplication().networkActivityIndicatorVisible = false
            })
            
            imageView.tag=2
            cell.addSubview(imageView)
            
            
        }
        
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        UIApplication.sharedApplication().networkActivityIndicatorVisible = true
        tumblrHUD.hidden=false
        tumblrHUD.showAnimated(true)
        if let backgroundUrl = self.themeLists[indexPath.row].fullsizeUrl {
            let images=UIImageView()
            images.frame=CGRect(x: 0, y: 0, width: 1242, height:1242)
            images.kf_setImageWithURL(NSURL(string: backgroundUrl)!, placeholderImage:  nil, optionsInfo: [.Transition(ImageTransition.Fade(0.2))], completionHandler: { action in
                self.tumblrHUD.hidden=true
                self.tumblrHUD.showAnimated(false)
                UIApplication.sharedApplication().networkActivityIndicatorVisible = false
                self.openEditor(images)
            })
            
            
        }
        
    }
    
    func openEditor(images:UIImageView){
        self.controller=PECropViewController()
        self.controller.delegate=self
        self.controller.image=images.image
        self.controller.cropAspectRatio=640.0/1136.0
        self.controller.keepingCropAspectRatio=false
        let navigationController=UINavigationController(rootViewController: self.controller)
        self.presentViewController(navigationController, animated: false, completion: nil)
    }
    
    func cropViewController(controller: PECropViewController!, didFinishCroppingImage croppedImage: UIImage!, btn button: UIButton!) {
        if button.tag==200{
            print("save")
            let imageData=UIImagePNGRepresentation(croppedImage)
            UIImageWriteToSavedPhotosAlbum(UIImage(data: imageData!)!, nil, nil, nil)
            let alertView=UIAlertView(title: "", message: "保存成功", delegate: self, cancelButtonTitle: "取消")
            alertView.alertViewStyle = .Default
            alertView.addButtonWithTitle("打开相册")
            alertView.show()
            
        }else{
            print("look")
            let lockScreenController = PreviewViewController(image: croppedImage)
            lockScreenController.modalPresentationStyle=UIModalPresentationStyle.FormSheet
            controller.presentViewController(lockScreenController, animated: false, completion: nil)
            
        }
    }
    func cropViewController(controller: PECropViewController!, didFinishCroppingImage croppedImage: UIImage!) {
    }
    
    func cropViewControllerDidCancel(controller: PECropViewController!) {
        controller.dismissViewControllerAnimated(true, completion: nil)
        
    }
    func alertView(alertView: UIAlertView, clickedButtonAtIndex buttonIndex: Int) {
        switch buttonIndex {
        case 1:
            UIApplication.sharedApplication().openURL(NSURL(string: "photos-redirect://")!)
        default:
            print("a")
        }
    }
    
    func setBackground(page: Int) {
        tumblrHUD.hidden=false
        tumblrHUD.showAnimated(true)
        var jsonData:JSON?
        UIApplication.sharedApplication().networkActivityIndicatorVisible = true
        Alamofire.request(.GET, self.Url+String(self.page), parameters: nil)
            .responseJSON(completionHandler: { req, _, result in
                print(req)
                UIApplication.sharedApplication().networkActivityIndicatorVisible = false
                if result.value != nil {
                    jsonData = JSON(result.value!)
                    for (_, subJson):(String, JSON) in jsonData! {
                        let themeList:ThemeList = ThemeList()
                        themeList.id = subJson["id"].stringValue
                       
                        themeList.smallUrl = subJson["fullurl"].stringValue+"-thumb"
                        themeList.fullsizeUrl = subJson["fullurl"].stringValue+"-full"
                        print(themeList.fullsizeUrl)
                        
                        self.themeLists.append(themeList)
                        
                        self.tableViews.insertRowsAtIndexPaths([NSIndexPath(forRow: self.themeLists.count-1, inSection: 0)], withRowAnimation: UITableViewRowAnimation.None)
                        self.tableViews.reloadRowsAtIndexPaths([NSIndexPath(forRow: self.themeLists.count-1, inSection: 0)], withRowAnimation: UITableViewRowAnimation.Left)
                    
                    }
                    self.tumblrHUD.hidden=true
                    self.tumblrHUD.showAnimated(false)
                    
                    
                }
                
            })
        
    }
    
    func scrollViewDidEndDecelerating(scrollView: UIScrollView) {
        let bottomEdge = scrollView.contentOffset.y + scrollView.frame.size.height
        if bottomEdge >= scrollView.contentSize.height {
            setBackground(++page)
        }
    }
    
    
    
    
}
