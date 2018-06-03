//
//  BindableUITextField.swift
//  Friends
//
//  Created by bernard on 02/06/2018.
//  Copyright © 2018 bernard. All rights reserved.
//

import UIKit

//---------------------------------------------------------------------------
class BindableUITextField: UITextField {
    
    var sujet: String = ""
    
    
}

//---------------------------------------------------------------------------
class BindableUITextView: UITextView {
    
    var sujet: String = ""
    var indexPath = IndexPath(item: 0, section: 0)
    
    func addBorder() {
        layer.borderWidth = 0.5
        layer.borderColor = UIColor(white: 0.8, alpha: 1.0).cgColor
        layer.cornerRadius = 8
    }
}

//---------------------------------------------------------------------------
class EditableTextViewCell: UITableViewCell, UITextViewDelegate {
    
    // https://stackoverflow.com/questions/47033577/dynamically-resizing-an-ios-tableview-cells-which-have-a-textview-embedded-in-sw
    
    var callBack: ((UITextView) -> ())?
    
    func textViewDidChange(_ textView: UITextView) {
        // tell controller the text changed
        callBack?(textView)
    }
    
}

