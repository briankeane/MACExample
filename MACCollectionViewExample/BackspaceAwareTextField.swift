//
//  BackspaceAwareTextField.swift
//  MACCollectionViewExample
//
//  Created by Brian D Keane on 7/24/16.
//  Copyright © 2016 Brian D Keane. All rights reserved.
//

import UIKit

class BackspaceAwareTextField: UITextField {

    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    */
    
    override func deleteBackward() {
        super.deleteBackward()
        NSNotificationCenter.defaultCenter().postNotificationName("BackspacePressedEvent", object: nil)
    }

    override func insertText(text: String) {
        super.insertText(text)
    }
}
