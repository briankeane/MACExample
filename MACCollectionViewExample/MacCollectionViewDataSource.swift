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
    func collectionView(collectionView: MACCollectionView, numberOfItemsInSection section: Int) -> Int
}