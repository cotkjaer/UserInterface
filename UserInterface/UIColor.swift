//
//  UIColor.swift
//  Silverback
//
//  Created by Christian Otkjær on 06/10/15.
//  Copyright © 2015 Christian Otkjær. All rights reserved.
//

import UIKit

// MARK: - opaque

public extension UIColor
{
    var alpha : CGFloat { return rgba.alpha }
    
    var opaque : Bool { return alpha > 0.9999 }
}

// MARK: - RGB

private let FF = CGFloat(0xFF)

public extension UIColor
{
    convenience init(rgb:UInt)
    {
        let red:CGFloat = CGFloat((rgb & 0xFF0000) >> 16)/FF;
        let green:CGFloat = CGFloat((rgb & 0xFF00) >> 8)/FF;
        let blue:CGFloat = CGFloat(rgb & 0xFF)/FF;
        
        self.init(red: red, green: green, blue: blue, alpha: 1.0)
    }
    
    convenience init(r:Int, g:Int, b: Int)
    {
        self.init(
            red: CGFloat(r)/FF,
            green: CGFloat(g)/FF,
            blue: CGFloat(b)/FF,
            alpha: 1)
    }
    
    var red : CGFloat { return rgba.red }
    var green : CGFloat { return rgba.green }
    var blue : CGFloat { return rgba.blue }
    
    var rgb : (red:CGFloat, green:CGFloat, blue:CGFloat) { let tmp = rgba; return (red: tmp.red, green: tmp.green, blue: tmp.blue) }
    
    var rgba : (red:CGFloat, green:CGFloat, blue:CGFloat, alpha:CGFloat) {
        var red : CGFloat = 0
        var green : CGFloat = 0
        var blue: CGFloat = 0
        var alpha : CGFloat = 0
        
        getRed(&red, green: &green, blue: &blue, alpha: &alpha)
        
        return (red, green, blue, alpha)
    }
    
    var white : CGFloat
        {
            let rgb = self.rgb
            return (rgb.red + rgb.green + rgb.blue) / CGFloat(3)
    }
}

// MARK: - HSB

public extension UIColor
{
    var hsba : (CGFloat, CGFloat, CGFloat, CGFloat)? {
        var hue : CGFloat = 0
        var saturation : CGFloat = 0
        var brightness : CGFloat = 0
        var alpha : CGFloat = 0
        
        if getHue(&hue, saturation: &saturation, brightness: &brightness, alpha: &alpha)
        {
            return (hue, saturation, brightness, alpha)
        }
        
        return nil
    }
    
    fileprivate var hsbComponents : (CGFloat, CGFloat, CGFloat, CGFloat)
        {
            var h : CGFloat = 0
            var s : CGFloat = 0
            var b : CGFloat = 0
            var a : CGFloat = 0
            
            getHue(&h, saturation: &s, brightness: &b, alpha: &a)
            
            return (h,s,b,a)
    }
    
    var hue: CGFloat { return hsbComponents.0 }
    
    func withHue(_ hue: CGFloat) -> UIColor
    {
        let hsba = hsbComponents
        
        return UIColor(hue: hue, saturation: hsba.1, brightness: hsba.2, alpha: hsba.3)
    }
    
    var saturation: CGFloat { return hsbComponents.1 }
    
    func withSaturation(_ saturation: CGFloat) -> UIColor
    {
        let hsba = hsbComponents
        
        return UIColor(hue: hsba.0, saturation: saturation, brightness: hsba.2, alpha: hsba.3)
    }
    
    var brightness: CGFloat { return hsbComponents.2 }
    
    func withBrightness(_ brightness: CGFloat) -> UIColor
    {
        let hsba = hsbComponents
        
        return UIColor(hue: hsba.0, saturation: hsba.1, brightness: brightness, alpha: hsba.3)
    }
}

//MARK: - Brightness

public extension UIColor
{
    //MARK: - Brightness
    
    var isBright: Bool { return brightness > 0.75 }
    
    var isDark: Bool { return brightness < 0.25 }
    
    func brighterColor(_ factor: CGFloat = 0.5) -> UIColor
    {
        return withBrightness(brightness + (1 - brightness) * factor)
    }
    
    func darkerColor(_ factor: CGFloat = 0.5) -> UIColor
    {
        return withBrightness(brightness - (brightness) * factor)
    }
}

//MARK: - Image

public extension UIColor
{
    func image(size: CGSize? = nil) -> UIImage
    {
        let size = size ?? CGSize(width: 1, height: 1)
        
        UIGraphicsBeginImageContextWithOptions(size, opaque, 0)
        defer { UIGraphicsEndImageContext() }
        
        setFill()
        
        UIBezierPath(rect: CGRect(origin: .zero, size: size)).fill()
        
        return UIGraphicsGetImageFromCurrentImageContext()!
    }
}

//MARK: - Named

private let NamedColors = [
    "aliceblue" : UIColor(r:240, g:248, b:255),
    "antiquewhite" : UIColor(r:250, g:235, b:215),
    "aqua" : UIColor(r:0, g:255, b:255),
    "aquamarine" : UIColor(r:127, g:255, b:212),
    "azure" : UIColor(r:240, g:255, b:255),
    "beige" : UIColor(r:245, g:245, b:220),
    "bisque" : UIColor(r:255, g:228, b:196),
    "black" : UIColor(r:0, g:0, b:0),
    "blanchedalmond" : UIColor(r:255, g:235, b:205),
    "blue" : UIColor(r:0, g:0, b:255),
    "blueviolet" : UIColor(r:138, g:43, b:226),
    "brown" : UIColor(r:165, g:42, b:42),
    "burlywood" : UIColor(r:222, g:184, b:135),
    "cadetblue" : UIColor(r:95, g:158, b:160),
    "chartreuse" : UIColor(r:127, g:255, b:0),
    "chocolate" : UIColor(r:210, g:105, b:30),
    "coral" : UIColor(r:255, g:127, b:80),
    "cornflowerblue" : UIColor(r:100, g:149, b:237),
    "cornsilk" : UIColor(r:255, g:248, b:220),
    "crimson" : UIColor(r:220, g:20, b:60),
    "cyan" : UIColor(r:0, g:255, b:255),
    "darkblue" : UIColor(r:0, g:0, b:139),
    "darkcyan" : UIColor(r:0, g:139, b:139),
    "darkgoldenrod" : UIColor(r:184, g:134, b:11),
    "darkgray" : UIColor(r:169, g:169, b:169),
    "darkgreen" : UIColor(r:0, g:100, b:0),
    "darkgrey" : UIColor(r:169, g:169, b:169),
    "darkkhaki" : UIColor(r:189, g:183, b:107),
    "darkmagenta" : UIColor(r:139, g:0, b:139),
    "darkolivegreen" : UIColor(r:85, g:107, b:47),
    "darkorange" : UIColor(r:255, g:140, b:0),
    "darkorchid" : UIColor(r:153, g:50, b:204),
    "darkred" : UIColor(r:139, g:0, b:0),
    "darksalmon" : UIColor(r:233, g:150, b:122),
    "darkseagreen" : UIColor(r:143, g:188, b:143),
    "darkslateblue" : UIColor(r:72, g:61, b:139),
    "darkslategray" : UIColor(r:47, g:79, b:79),
    "darkslategrey" : UIColor(r:47, g:79, b:79),
    "darkturquoise" : UIColor(r:0, g:206, b:209),
    "darkviolet" : UIColor(r:148, g:0, b:211),
    "deeppink" : UIColor(r:255, g:20, b:147),
    "deepskb" : UIColor(r:0, g:191, b:255),
    "dimgray" : UIColor(r:105, g:105, b:105),
    "dimgrey" : UIColor(r:105, g:105, b:105),
    "dodgerblue" : UIColor(r:30, g:144, b:255),
    "firebrick" : UIColor(r:178, g:34, b:34),
    "floralwhite" : UIColor(r:255, g:250, b:240),
    "forestgreen" : UIColor(r:34, g:139, b:34),
    "fuchsia" : UIColor(r:255, g:0, b:255),
    "gainsboro" : UIColor(r:220, g:220, b:220),
    "ghostwhite" : UIColor(r:248, g:248, b:255),
    "gold" : UIColor(r:255, g:215, b:0),
    "goldenrod" : UIColor(r:218, g:165, b:32),
    "gray" : UIColor(r:128, g:128, b:128),
    "grey" : UIColor(r:128, g:128, b:128),
    "green" : UIColor(r:0, g:128, b:0),
    "greenyellow" : UIColor(r:173, g:255, b:47),
    "honeydew" : UIColor(r:240, g:255, b:240),
    "hotpink" : UIColor(r:255, g:105, b:180),
    "indianred" : UIColor(r:205, g:92, b:92),
    "indigo" : UIColor(r:75, g:0, b:130),
    "ivory" : UIColor(r:255, g:255, b:240),
    "khaki" : UIColor(r:240, g:230, b:140),
    "lavender" : UIColor(r:230, g:230, b:250),
    "lavenderblush" : UIColor(r:255, g:240, b:245),
    "lawngreen" : UIColor(r:124, g:252, b:0),
    "lemonchiffon" : UIColor(r:255, g:250, b:205),
    "lightblue" : UIColor(r:173, g:216, b:230),
    "lightcoral" : UIColor(r:240, g:128, b:128),
    "lightcyan" : UIColor(r:224, g:255, b:255),
    "lightgoldenrodyellow" : UIColor(r:250, g:250, b:210),
    "lightgray" : UIColor(r:211, g:211, b:211),
    "lightgreen" : UIColor(r:144, g:238, b:144),
    "lightgrey" : UIColor(r:211, g:211, b:211),
    "lightpink" : UIColor(r:255, g:182, b:193),
    "lightsalmon" : UIColor(r:255, g:160, b:122),
    "lightseagreen" : UIColor(r:32, g:178, b:170),
    "lightskb" : UIColor(r:135, g:206, b:250),
    "lightslategray" : UIColor(r:119, g:136, b:153),
    "lightslategrey" : UIColor(r:119, g:136, b:153),
    "lightsteelblue" : UIColor(r:176, g:196, b:222),
    "lightyellow" : UIColor(r:255, g:255, b:224),
    "lime" : UIColor(r:0, g:255, b:0),
    "limegreen" : UIColor(r:50, g:205, b:50),
    "linen" : UIColor(r:250, g:240, b:230),
    "magenta" : UIColor(r:255, g:0, b:255),
    "maroon" : UIColor(r:128, g:0, b:0),
    "mediumaquamarine" : UIColor(r:102, g:205, b:170),
    "mediumblue" :  UIColor(r:0, g:0, b:205),
    "mediumorchid" : UIColor(r:186, g:85, b:211),
    "mediumpurple" : UIColor(r:147, g:112, b:219),
    "mediumseagreen" : UIColor(r:60, g:179, b:113),
    "mediumslateblue" : UIColor(r:123, g:104, b:238),
    "mediumspringgreen" : UIColor(r:0, g:250, b:154),
    "mediumturquoise" : UIColor(r:72, g:209, b:204),
    "mediumvioletred" : UIColor(r:199, g:21, b:133),
    "midnightblue" : UIColor(r:25, g:25, b:112),
    "mintcream" : UIColor(r:245, g:255, b:250),
    "mistyrose" : UIColor(r:255, g:228, b:225),
    "moccasin" : UIColor(r:255, g:228, b:181),
    "navajowhite" : UIColor(r:255, g:222, b:173),
    "navy" : UIColor(r:0, g:0, b:128),
    "oldlace" : UIColor(r:253, g:245, b:230),
    "olive" : UIColor(r:128, g:128, b:0),
    "olivedrab" : UIColor(r:107, g:142, b:35),
    "orange" : UIColor(r:255, g:165, b:0),
    "orangered" : UIColor(r:255, g:69, b:0),
    "orchid" : UIColor(r:218, g:112, b:214),
    "palegoldenrod" : UIColor(r:238, g:232, b:170),
    "palegreen" : UIColor(r:152, g:251, b:152),
    "paleturquoise" : UIColor(r:175, g:238, b:238),
    "palevioletred" : UIColor(r:219, g:112, b:147),
    "papayawhip" : UIColor(r:255, g:239, b:213),
    "peachpuff" : UIColor(r:255, g:218, b:185),
    "peru" : UIColor(r:205, g:133, b:63),
    "pink" : UIColor(r:255, g:192, b:203),
    "plum" : UIColor(r:221, g:160, b:221),
    "powderblue" : UIColor(r:176, g:224, b:230),
    "purple" : UIColor(r:128, g:0, b:128),
    "red" : UIColor(r:255, g:0, b:0),
    "rosybrown" : UIColor(r:188, g:143, b:143),
    "royalblue" : UIColor(r:65, g:105, b:225),
    "saddlebrown" : UIColor(r:139, g:69, b:19),
    "salmon" : UIColor(r:250, g:128, b:114),
    "sandybrown" : UIColor(r:244, g:164, b:96),
    "seagreen" : UIColor(r:46, g:139, b:87),
    "seashell" : UIColor(r:255, g:245, b:238),
    "sienna" : UIColor(r:160, g:82, b:45),
    "silver" : UIColor(r:192, g:192, b:192),
    "skb" : UIColor(r:135, g:206, b:235),
    "slateblue" : UIColor(r:106, g:90, b:205),
    "slategray" : UIColor(r:112, g:128, b:144),
    "slategrey" : UIColor(r:112, g:128, b:144),
    "snow" : UIColor(r:255, g:250, b:250),
    "springgreen" : UIColor(r:0, g:255, b:127),
    "steelblue" : UIColor(r:70, g:130, b:180),
    "tan" : UIColor(r:210, g:180, b:140),
    "teal" : UIColor(r:0, g:128, b:128),
    "thistle" : UIColor(r:216, g:191, b:216),
    "tomato" : UIColor(r:255, g:99, b:71),
    "turquoise" : UIColor(r:64, g:224, b:208),
    "violet" : UIColor(r:238, g:130, b:238),
    "wheat" : UIColor(r:245, g:222, b:179),
    "white" : UIColor(r:255, g:255, b:255),
    "whitesmoke" : UIColor(r:245, g:245, b:245),
    "yellow" : UIColor(r:255, g:255, b:0),
    "yellowgreen" : UIColor(r:154, g:205, b:50),
    "warmYellow" : UIColor(r: 255, g: 221, b: 18),
    "alice" : UIColor(r: 20, g: 150, b: 187)
    
]

extension UIColor
{
    public static let alice = UIColor(r: 20, g: 150, b: 187)
    public static let aliceblue = UIColor(r:240, g:248, b:255)
    public static let antiquewhite = UIColor(r:250, g:235, b:215)
    public static let aqua = UIColor(r:0, g:255, b:255)
    public static let aquamarine = UIColor(r:127, g:255, b:212)
    public static let azure = UIColor(r:240, g:255, b:255)
    public static let beige = UIColor(r:245, g:245, b:220)
    public static let bisque = UIColor(r:255, g:228, b:196)
    public static let blanchedalmond = UIColor(r:255, g:235, b:205)
    public static let blueviolet = UIColor(r:138, g:43, b:226)
    public static let burlywood = UIColor(r:222, g:184, b:135)
    public static let cadetblue = UIColor(r:95, g:158, b:160)
    public static let chartreuse = UIColor(r:127, g:255, b:0)
    public static let chocolate = UIColor(r:210, g:105, b:30)
    public static let coral = UIColor(r:255, g:127, b:80)
    public static let cornflowerblue = UIColor(r:100, g:149, b:237)
    public static let cornsilk = UIColor(r:255, g:248, b:220)
    public static let crimson = UIColor(r:220, g:20, b:60)
    public static let darkblue = UIColor(r:0, g:0, b:139)
    public static let darkcyan = UIColor(r:0, g:139, b:139)
    public static let darkgoldenrod = UIColor(r:184, g:134, b:11)
    public static let darkgray = UIColor(r:169, g:169, b:169)
    public static let darkgreen = UIColor(r:0, g:100, b:0)
    public static let darkgrey = UIColor(r:169, g:169, b:169)
    public static let darkkhaki = UIColor(r:189, g:183, b:107)
    public static let darkmagenta = UIColor(r:139, g:0, b:139)
    public static let darkolivegreen = UIColor(r:85, g:107, b:47)
    public static let darkorange = UIColor(r:255, g:140, b:0)
    public static let darkorchid = UIColor(r:153, g:50, b:204)
    public static let darkred = UIColor(r:139, g:0, b:0)
    public static let darksalmon = UIColor(r:233, g:150, b:122)
    public static let darkseagreen = UIColor(r:143, g:188, b:143)
    public static let darkslateblue = UIColor(r:72, g:61, b:139)
    public static let darkslategray = UIColor(r:47, g:79, b:79)
    public static let darkslategrey = UIColor(r:47, g:79, b:79)
    public static let darkturquoise = UIColor(r:0, g:206, b:209)
    public static let darkviolet = UIColor(r:148, g:0, b:211)
    public static let deeppink = UIColor(r:255, g:20, b:147)
    public static let deepskb = UIColor(r:0, g:191, b:255)
    public static let dimgray = UIColor(r:105, g:105, b:105)
    public static let dimgrey = UIColor(r:105, g:105, b:105)
    public static let dodgerblue = UIColor(r:30, g:144, b:255)
    public static let firebrick = UIColor(r:178, g:34, b:34)
    public static let floralwhite = UIColor(r:255, g:250, b:240)
    public static let forestgreen = UIColor(r:34, g:139, b:34)
    public static let fuchsia = UIColor(r:255, g:0, b:255)
    public static let gainsboro = UIColor(r:220, g:220, b:220)
    public static let ghostwhite = UIColor(r:248, g:248, b:255)
    public static let gold = UIColor(r:255, g:215, b:0)
    public static let goldenrod = UIColor(r:218, g:165, b:32)
    public static let grey = UIColor(r:128, g:128, b:128)
    public static let greenyellow = UIColor(r:173, g:255, b:47)
    public static let honeydew = UIColor(r:240, g:255, b:240)
    public static let hotpink = UIColor(r:255, g:105, b:180)
    public static let indianred = UIColor(r:205, g:92, b:92)
    public static let indigo = UIColor(r:75, g:0, b:130)
    public static let ivory = UIColor(r:255, g:255, b:240)
    public static let khaki = UIColor(r:240, g:230, b:140)
    public static let lavender = UIColor(r:230, g:230, b:250)
    public static let lavenderblush = UIColor(r:255, g:240, b:245)
    public static let lawngreen = UIColor(r:124, g:252, b:0)
    public static let lemonchiffon = UIColor(r:255, g:250, b:205)
    public static let lightblue = UIColor(r:173, g:216, b:230)
    public static let lightcoral = UIColor(r:240, g:128, b:128)
    public static let lightcyan = UIColor(r:224, g:255, b:255)
    public static let lightgoldenrodyellow = UIColor(r:250, g:250, b:210)
    public static let lightgray = UIColor(r:211, g:211, b:211)
    public static let lightgreen = UIColor(r:144, g:238, b:144)
    public static let lightgrey = UIColor(r:211, g:211, b:211)
    public static let lightpink = UIColor(r:255, g:182, b:193)
    public static let lightsalmon = UIColor(r:255, g:160, b:122)
    public static let lightseagreen = UIColor(r:32, g:178, b:170)
    public static let lightskb = UIColor(r:135, g:206, b:250)
    public static let lightslategray = UIColor(r:119, g:136, b:153)
    public static let lightslategrey = UIColor(r:119, g:136, b:153)
    public static let lightsteelblue = UIColor(r:176, g:196, b:222)
    public static let lightyellow = UIColor(r:255, g:255, b:224)
    public static let lime = UIColor(r:0, g:255, b:0)
    public static let limegreen = UIColor(r:50, g:205, b:50)
    public static let linen = UIColor(r:250, g:240, b:230)
    public static let maroon = UIColor(r:128, g:0, b:0)
    public static let mediumaquamarine = UIColor(r:102, g:205, b:170)
    public static let mediumblue = UIColor(r:0, g:0, b:205)
    public static let mediumorchid = UIColor(r:186, g:85, b:211)
    public static let mediumpurple = UIColor(r:147, g:112, b:219)
    public static let mediumseagreen = UIColor(r:60, g:179, b:113)
    public static let mediumslateblue = UIColor(r:123, g:104, b:238)
    public static let mediumspringgreen = UIColor(r:0, g:250, b:154)
    public static let mediumturquoise = UIColor(r:72, g:209, b:204)
    public static let mediumvioletred = UIColor(r:199, g:21, b:133)
    public static let midnightblue = UIColor(r:25, g:25, b:112)
    public static let mintcream = UIColor(r:245, g:255, b:250)
    public static let mistyrose = UIColor(r:255, g:228, b:225)
    public static let moccasin = UIColor(r:255, g:228, b:181)
    public static let navajowhite = UIColor(r:255, g:222, b:173)
    public static let navy = UIColor(r:0, g:0, b:128)
    public static let oldlace = UIColor(r:253, g:245, b:230)
    public static let olive = UIColor(r:128, g:128, b:0)
    public static let olivedrab = UIColor(r:107, g:142, b:35)
    public static let orangered = UIColor(r:255, g:69, b:0)
    public static let orchid = UIColor(r:218, g:112, b:214)
    public static let palegoldenrod = UIColor(r:238, g:232, b:170)
    public static let palegreen = UIColor(r:152, g:251, b:152)
    public static let paleturquoise = UIColor(r:175, g:238, b:238)
    public static let palevioletred = UIColor(r:219, g:112, b:147)
    public static let papayawhip = UIColor(r:255, g:239, b:213)
    public static let peachpuff = UIColor(r:255, g:218, b:185)
    public static let peru = UIColor(r:205, g:133, b:63)
    public static let pink = UIColor(r:255, g:192, b:203)
    public static let plum = UIColor(r:221, g:160, b:221)
    public static let powderblue = UIColor(r:176, g:224, b:230)
    public static let rosybrown = UIColor(r:188, g:143, b:143)
    public static let royalblue = UIColor(r:65, g:105, b:225)
    public static let saddlebrown = UIColor(r:139, g:69, b:19)
    public static let salmon = UIColor(r:250, g:128, b:114)
    public static let sandybrown = UIColor(r:244, g:164, b:96)
    public static let seagreen = UIColor(r:46, g:139, b:87)
    public static let seashell = UIColor(r:255, g:245, b:238)
    public static let sienna = UIColor(r:160, g:82, b:45)
    public static let silver = UIColor(r:192, g:192, b:192)
    public static let slateblue = UIColor(r:106, g:90, b:205)
    public static let slategray = UIColor(r:112, g:128, b:144)
    public static let slategrey = UIColor(r:112, g:128, b:144)
    public static let snow = UIColor(r:255, g:250, b:250)
    public static let springgreen = UIColor(r:0, g:255, b:127)
    public static let steelblue = UIColor(r:70, g:130, b:180)
    public static let tan = UIColor(r:210, g:180, b:140)
    public static let teal = UIColor(r:0, g:128, b:128)
    public static let thistle = UIColor(r:216, g:191, b:216)
    public static let tomato = UIColor(r:255, g:99, b:71)
    public static let turquoise = UIColor(r:64, g:224, b:208)
    public static let violet = UIColor(r:238, g:130, b:238)
    public static let wheat = UIColor(r:245, g:222, b:179)
    public static let whitesmoke = UIColor(r:245, g:245, b:245)
    public static let yellowgreen = UIColor(r:154, g:205, b:50)
    public static let warmYellow = UIColor(r: 255, g: 221, b: 18)
}

extension UIColor
{
    public convenience init?(named: String)
    {
        if let rgb = NamedColors[named.lowercased()]?.rgb
        {
            self.init(red:rgb.red, green: rgb.green, blue: rgb.blue, alpha: 1)
        }
        
        return nil
    }
    
    var name : String?
        {
            return NamedColors.first { (name, color) -> Bool in
                return color == self
                }?.0
    }
}
