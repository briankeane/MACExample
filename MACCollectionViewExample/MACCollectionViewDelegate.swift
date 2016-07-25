//
//  MACCollectionViewDelegate.swift
//  MACCollectionViewExample
//
//  Created by Brian D Keane on 7/25/16.
//  Copyright © 2016 Brian D Keane. All rights reserved.
//

import Foundation
import UIKit

@objc protocol MACCollectionViewDelegate
{
    optional func collectionView(collectionView: MACCollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) -> Void
    optional func collectionView(collectionView: MACCollectionView, didDeselectItemAtIndexPath indexPath: NSIndexPath) -> Void
    func textFieldChanged(updatedText:String) -> Void
}