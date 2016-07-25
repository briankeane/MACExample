//
//  MacCollectionViewDataSource.swift
//  MACCollectionViewExample
//
//  Created by Brian D Keane on 7/25/16.
//  Copyright © 2016 Brian D Keane. All rights reserved.
//

import Foundation
import UIKit

protocol MACCollectionViewDataSource
{
    func numberOfChosenItems(macCollectionView:MACCollectionView) -> Int
    func titleForItemAtIndexPath(indexPath:NSIndexPath) -> String
    func willRemoveItemsAtIndexPaths(indexPaths:[NSIndexPath]) -> Void
    func handleReturnKeypress(macCollectionView:MACCollectionView) -> Void
}