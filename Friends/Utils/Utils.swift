//
//  Utils.swift
//  Friends
//
//  Created by bernard on 22/11/2014.
//  Copyright (c) 2014 bernard. All rights reserved.
//

import Foundation
import UIKit

// MARK: - Classes
//---------------------------------------------------------------------------
class Ligne {
    var sujet: String
    var objectRef: AnyObject?
    var title: String
    var placeHolder: String
    var label: String
    var cellIdentifier: String
    var photoData: Data
    var accessoryType:UITableViewCell.AccessoryType
    var deletable:Bool
    
    init() {
        self.sujet = ""
        self.objectRef = nil as AnyObject?
        self.title = ""
        self.placeHolder = ""
        self.label = ""
        self.cellIdentifier = ""
        self.photoData = Data()
        accessoryType = UITableViewCell.AccessoryType.none
        deletable = false
    }
    
}

//---------------------------------------------------------------------------
class Section {
    let sectionTitle: String
    var lignes: [Ligne]
    
    init(title: String) {
        self.sectionTitle = title
        self.lignes = []
    }
}

// MARK: - Fonctions
func colorWithHexString (hex:String, alpha: CGFloat = 1.0) -> UIColor {
    return UIColor.gray
    
    /*xxx
     var cString:NSString = hex.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet()).uppercased()
     
     if (cString.hasPrefix("#")) {
     cString = (cString as NSString).substring(from: 1)
     }
     
     if (countElements(cString) != 6) {
     return UIColor.gray
     }
     
     var rString = (cString as NSString).substring(to: 2)
     var gString = ((cString as NSString).substring(from: 2) as NSString).substring(to: 2)
     var bString = ((cString as NSString).substring(from: 4) as NSString).substring(to: 2)
     
     var r:CUnsignedInt = 0, g:CUnsignedInt = 0, b:CUnsignedInt = 0;
     Scanner(string: rString).scanHexInt32(&r)
     Scanner(string: gString).scanHexInt32(&g)
     Scanner(string: bString).scanHexInt32(&b)
     
     
     return UIColor(red: CGFloat(r) / 255.0, green: CGFloat(g) / 255.0, blue: CGFloat(b) / 255.0, alpha: alpha)
     */
}

//---------------------------------------------------------------------------
// themeColor01 : arrière plan tableViews master
func themeColor01(_ alpha: CGFloat = 1.0) -> UIColor {
    //return colorWithHexString("#fdebce", alpha: alpha)
    return colorWithHexString(hex: "#ffffff", alpha: alpha)
}

//---------------------------------------------------------------------------
// themeColor02 : bandeaux app
func themeColor02() -> UIColor {
    //return colorWithHexString("#3e1934")
    return colorWithHexString(hex: "#ffffff")
}

//---------------------------------------------------------------------------
// themeColor03 : bandeaux listes
func themeColor03() -> UIColor {
    //return colorWithHexString("#623f59")
    return colorWithHexString(hex: "#cccccc")
}

//---------------------------------------------------------------------------
// themeColor04 : sélection listes master
func themeColor04() -> UIColor {
    //return colorWithHexString("#8da8a1")
    return colorWithHexString(hex: "#efefef")
}

//---------------------------------------------------------------------------
// themeColor05 : non utilisée
func themeColor05() -> UIColor {
    return colorWithHexString(hex: "#460a02")
}

//---------------------------------------------------------------------------
func scaledImageRound(_ image: UIImage, dim: CGFloat, borderWidth: CGFloat, borderColor: UIColor, imageView: UIImageView) -> UIImage{
    let tailleImage = dim as CGFloat
    let coefW = tailleImage / image.size.width
    let coefH = tailleImage / image.size.height
    let coef = coefH > coefW ? coefW : coefH
    let size = image.size.applying(CGAffineTransform(scaleX: coef, y: coef))
    let hasAlpha = false
    let scale: CGFloat = 0.0 // Automatically use scale factor of main screen
    UIGraphicsBeginImageContextWithOptions(size, !hasAlpha, scale)
    image.draw(in: CGRect(origin: CGPoint.zero, size: size))
    //let scaledImage = UIGraphicsGetImageFromCurrentImageContext()
    
    let newSize = CGSize(width: dim, height: dim)
    let scaledImage = squareImageWithImage(image, newSize: newSize)
    //une bordure blanche
    imageView.backgroundColor = borderColor
    let corner = tailleImage / 2.00 as CGFloat
    imageView.layer.cornerRadius = corner
    imageView.clipsToBounds = true
    imageView.layer.borderWidth = borderWidth as CGFloat
    imageView.layer.borderColor = UIColor.white.cgColor
    
    return scaledImage
    
}

//---------------------------------------------------------------------------
func squareImageWithImage(_ image: UIImage, newSize: CGSize) -> UIImage {
    var ratio: CGFloat = 0.0
    var delta: CGFloat = 0.0
    var offset: CGPoint = CGPoint(x: 0.0, y: 0.0)
    
    //make a new square size, that is the resized imaged width
    let sz = CGSize(width: newSize.width, height: newSize.width) as CGSize
    
    //figure out if the picture is landscape or portrait, then
    //calculate scale factor and offset
    if image.size.width > image.size.height {
        ratio = newSize.width / image.size.width
        delta = (ratio*image.size.width - ratio*image.size.height)
        offset = CGPoint(x: delta/2, y: 0)
    } else {
        ratio = newSize.width / image.size.height;
        delta = (ratio*image.size.height - ratio*image.size.width);
        offset = CGPoint(x: 0, y: delta/2)
    }
    
    //make the final clipping rect based on the calculated values
    let clipRect = CGRect(x: -offset.x, y: -offset.y,
                          width: (ratio * image.size.width) + delta,
                          height: (ratio * image.size.height) + delta)
    
    //for retina consideration
    if UIScreen.main.responds(to: #selector(NSDecimalNumberBehaviors.scale)) {
        UIGraphicsBeginImageContextWithOptions(sz, true, 0.0);
    } else {
        UIGraphicsBeginImageContext(sz);
    }
    UIRectClip(clipRect)
    image.draw(in: clipRect)
    let newImage = UIGraphicsGetImageFromCurrentImageContext()
    UIGraphicsEndImageContext()
    
    return newImage!;
}

//---------------------------------------------------------------------------
func resizeImage(image: UIImage, targetSize: CGSize) -> UIImage {
    let size = image.size
    
    let widthRatio  = targetSize.width  / size.width
    let heightRatio = targetSize.height / size.height
    
    // Figure out what our orientation is, and use that to form the rectangle
    var newSize: CGSize
    if(widthRatio > heightRatio) {
        newSize = CGSize(width: size.width * heightRatio, height: size.height * heightRatio)
    } else {
        newSize = CGSize(width: size.width * widthRatio,  height: size.height * widthRatio)
    }
    
    // This is the rect that we've calculated out and this is what is actually used below
    let rect = CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height)
    
    // Actually do the resizing to the rect using the ImageContext stuff
    UIGraphicsBeginImageContextWithOptions(newSize, false, 1.0)
    image.draw(in: rect)
    let newImage = UIGraphicsGetImageFromCurrentImageContext()
    UIGraphicsEndImageContext()
    
    return newImage!
}

//---------------------------------------------------------------------------
func currencyFormatter() ->  NumberFormatter {
    let formatter = NumberFormatter()
    formatter.numberStyle = .currency
    return formatter
}

//---------------------------------------------------------------------------
public func attrStr(str: String, lineSpacing: CGFloat = 6.0, fontSize:CGFloat = 14.0)   -> NSAttributedString {
    let style = NSMutableParagraphStyle()
    style.lineSpacing = lineSpacing // change line spacing between paragraph like 36 or 48
    
    if #available(iOS 13.0, *) {
        let myAttributes = [ NSAttributedString.Key.font: UIFont(name: "Helvetica", size: fontSize)!, NSAttributedString.Key.paragraphStyle: style, NSAttributedString.Key.foregroundColor: UIColor.label]
        let attrString = NSAttributedString(string: str, attributes: myAttributes)
        return attrString
        
    } else {
        let myAttributes = [ NSAttributedString.Key.font: UIFont(name: "Helvetica", size: fontSize)!, NSAttributedString.Key.paragraphStyle: style]
        let attrString = NSAttributedString(string: str, attributes: myAttributes)
        return attrString
    }
}

//---------------------------------------------------------------------------
public func strDateFormat(_ date: Date?) -> String {
    guard let date = date else { return "" }
    
    let dateFormatter = DateFormatter()
    dateFormatter.dateStyle = DateFormatter.Style.medium
    dateFormatter.timeStyle = DateFormatter.Style.none
    
    return dateFormatter.string(from: date)
}

//---------------------------------------------------------------------------
// MARK: - Extensions

//---------------------------------------------------------------------------
extension String {
    public func removeLastCR() -> String {
        var strRetour = self
        while strRetour.last == "\n" {
            strRetour = String(strRetour.dropLast())
        }
        
        return strRetour
    }
}

extension Date {
    public func componentsDMY() -> DateComponents {
        let calendar = Calendar.current
        let components: DateComponents = calendar.dateComponents([Calendar.Component.day, Calendar.Component.month, Calendar.Component.year], from: self)
        //print("Jour : \(components.day!) - Mois : \(components.month!) - Année : \(components.year!)")
        
        return components
    }
}

extension DateComponents {
    public func stringYMD() -> String? {
        var strRetour: String?
        if self.isValidDate(in: Calendar.current) {
            strRetour = String(format: "%04d-%02d-%02d", arguments: [year!, month!, day!])
        } else {
            strRetour = nil
        }
        return strRetour
    }
}


/*extension UIImage {
 func renderResizedImage (newWidth: CGFloat) -> UIImage {
 let scale = newWidth / self.size.width
 let newHeight = self.size.height * scale
 let newSize = CGSize(width: newWidth, height: newHeight)
 
 let renderer = UIGraphicsImageRenderer(size: newSize)
 
 let image = renderer.image { (context) in
 self.draw(in: CGRect(origin: CGPoint(x: 0, y: 0), size: newSize))
 }
 return image
 }*/

