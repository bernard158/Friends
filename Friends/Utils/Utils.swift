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
    var accessoryType:UITableViewCellAccessoryType
    var deletable:Bool

    init() {
        self.sujet = ""
        self.objectRef = nil as AnyObject?
        self.title = ""
        self.placeHolder = ""
        self.label = ""
        self.cellIdentifier = ""
        self.photoData = Data()
        accessoryType = UITableViewCellAccessoryType.none
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
func currencyFormatter() ->  NumberFormatter {
    let formatter = NumberFormatter()
    formatter.numberStyle = .currency
    return formatter
}

public func attrStr(str: String, lineSpacing: CGFloat = 6.0, fontSize:CGFloat = 14.0)   -> NSAttributedString {
    let style = NSMutableParagraphStyle()
    style.lineSpacing = lineSpacing // change line spacing between paragraph like 36 or 48
    
    let myAttributes = [ NSAttributedStringKey.font: UIFont(name: "Helvetica", size: fontSize)!, NSAttributedStringKey.paragraphStyle: style ]
    let attrString = NSAttributedString(string: str, attributes: myAttributes)
    
    return attrString
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


