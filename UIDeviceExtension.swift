
import UIKit
extension UIDevice {
    
    //Device Code : iPhone7,2, iPhone6,1, ...
    public var deviceCode: String {
        var sysInfo: [CChar] = Array(count: sizeof(utsname), repeatedValue: 0)
        
        let code = sysInfo.withUnsafeMutableBufferPointer {
            (inout ptr: UnsafeMutableBufferPointer<CChar>) -> String in
            uname(UnsafeMutablePointer<utsname>(ptr.baseAddress))
            //let machinePtr = advance(ptr.baseAddress, Int(_SYS_NAMELEN * 4))
            let machinePtr = ptr.baseAddress.advancedBy(Int(_SYS_NAMELEN * 4))
            
            return String.fromCString(machinePtr)!
        }
        
        return code
    }
    
    // Device Family : iPhone,iPad, ...
    public var deviceFamily: String {
        
        return UIDevice.currentDevice().model
    }
    
    //Device Model : iPhone 6, iPhone 6 plus, iPad Air, ...
    public var deviceModel: String {
        var model : String
        let deviceCode = UIDevice().deviceCode
        switch deviceCode {
        case "iPhone4,1":                               model = "iPhone 4s"
        case "iPhone5,1", "iPhone5,2":                  model = "iPHONE 5"
        case "iPhone5,3", "iPhone5,4":                  model = "iPHONE 5c"
        case "iPhone6,1", "iPhone6,2":                  model = "iPHONE 5s"
        case "iPhone7,2":                               model = "iPHONE 6 / 6s"
        case "iPhone7,1":                               model = "iPHONE 6 PLUS / 6s PLUS"
        case "iPhone8,2":                               model = "iPHONE 6 PLUS / 6s PLUS"
        case "iPhone8,1":                               model = "iPHONE 6 / 6s"
        case "i386", "x86_64":                          model = "iPHONE 6 / 6s"
        default:                                        model = "iPHONE 6 / 6s"
            
        }
        
        return model
    }
    
    
    
    
    //Device Jailbreaked or not
    public var deviceJailed: Bool {
        let path : NSString = "/Applications/Cydia.app"
        let fileExists : Bool = NSFileManager.defaultManager().fileExistsAtPath(path as String)
        return fileExists
    }
    
    //Device iOS Version : 8.1, 8.1.3, ...
    public var deviceIOSVersion: String {
        return UIDevice.currentDevice().systemVersion
    }
    
    
    
    
    
    public func applicationVersion() -> String {
        return (NSBundle.mainBundle().infoDictionary?["CFBundleShortVersionString"]) as! String
    }
    
    public func applicationBuildVersion() -> String {
        return (NSBundle.mainBundle().infoDictionary?["CFBundleVersion"]) as! String
    }
    
    public func documentPath() -> String {
        let array : Array<String> = NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.DocumentDirectory, NSSearchPathDomainMask.UserDomainMask, true)
        return array[0]
    }
    
    public func cachesPath() -> String {
        let array : Array<String> = NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.CachesDirectory, NSSearchPathDomainMask.UserDomainMask, true)
        return array[0]
    }
    
    public func gotoItunesForDownloadApp(appId : String) {
        let downloadUrl = "http://itunes.apple.com/app/id\(appId)?mt=8"
        UIApplication.sharedApplication().openURL(NSURL(string: downloadUrl)!)
    }
    
    
    //Device Screen Width and Height
    class public var deviceScreenWidth: CGFloat {
        let screenSize: CGRect = UIScreen.mainScreen().bounds
        let width = screenSize.width;
        return width
    }
    class public var deviceScreenHeight: CGFloat {
        let screenSize: CGRect = UIScreen.mainScreen().bounds
        let height = screenSize.height;
        return height
    }
    
    
    //Device Orientation String
    public var deviceOrientationString: String {
        
        var orientation : String
        
        switch UIDevice.currentDevice().orientation{
        case .Portrait:
            orientation="Portrait"
        case .PortraitUpsideDown:
            orientation="Portrait Upside Down"
        case .LandscapeLeft:
            orientation="Landscape Left"
        case .LandscapeRight:
            orientation="Landscape Right"
        case .FaceUp:
            orientation="Face Up"
        case .FaceDown:
            orientation="Face Down"
        default:
            orientation="Unknown"
        }
        
        return orientation
    }
    
    
    // is Device Landscape, is Portrait
    public var isDevicePortrait: Bool {
        return UIDevice.currentDevice().orientation.isPortrait
    }
    public var isDeviceLandscape: Bool {
        return UIDevice.currentDevice().orientation.isLandscape
    }
    
    class func imageWithColor(color:UIColor) -> UIImage{
        
        // 描述矩形
        let rect:CGRect  = CGRectMake(0, 0, 1, 1.0)
        
        // 开启位图上下文
        UIGraphicsBeginImageContext(rect.size);
        // 获取位图上下文
        let context  = UIGraphicsGetCurrentContext()
        // 使用color演示填充上下文
        CGContextSetFillColorWithColor(context, color.CGColor)
        
        // 渲染上下文
        CGContextFillRect(context, rect);
        // 从上下文中获取图片
        let theImage:UIImage = UIGraphicsGetImageFromCurrentImageContext()
        // 结束上下文
        UIGraphicsEndImageContext();
        
        return theImage;
        
    }
    
}
