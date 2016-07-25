//
//  MACCollectionViewController.swift
//  MACCollectionViewExample
//
//  Created by Brian D Keane on 7/25/16.
//  Copyright © 2016 Brian D Keane. All rights reserved.
//

import UIKit

private let reuseIdentifier = "Cell"

class MACCollectionViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout, UITextFieldDelegate {
    
    var delegate:MACCollectionViewDelegate?
    var dataSource:MACCollectionViewDataSource?
    var searchTextField:UITextField?
    
    
    var unselectedChosenItemBorderColor:CGColor = UIColor.blackColor().CGColor
    var unselectedChosenItemBorderWidth:CGFloat = 2.0
    var unselectedChosenItemCornerRadius:CGFloat = 10
    
    var selectedChosenItemBackgroundColor = UIColor.blueColor()
    var selectedChosenItemTextColor = UIColor.whiteColor()
    var unselectedChosenItemBackgroundColor = UIColor.whiteColor()
    var unselectedChosenItemTextColor = UIColor.blueColor()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.registerCells()
        
        // Register cell classes
        self.collectionView!.registerClass(UICollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        self.collectionView!.registerNib(UINib(nibName: "TextEntryCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "TextEntryCollectionViewCell")
        self.collectionView!.registerNib(UINib(nibName: "ChosenItemCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "ChosenItemCollectionViewCell")
    }

    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
    }

    //------------------------------------------------------------------------------
    
    func registerCells()
    {
        NSNotificationCenter.defaultCenter().addObserverForName(UITextFieldTextDidChangeNotification, object: nil, queue: NSOperationQueue.mainQueue()) { (notification) in
            self.textFieldChanged()
        }
        
        NSNotificationCenter.defaultCenter().addObserverForName("BackspacePressedEvent", object: nil, queue: NSOperationQueue.mainQueue()) { (notification) in
            self.backspacePressed()
        }
    }
    
    //------------------------------------------------------------------------------
    
    func textFieldChanged()
    {
        if let textField = self.searchTextField
        {
            if let delegate = self.delegate
            {
                delegate.textFieldChanged(textField.text!)
                self.collectionView!.collectionViewLayout.invalidateLayout() // resizes textField cell
            }
        }
    }
    
    //------------------------------------------------------------------------------
    
    func backspacePressed()
    {
        if (self.searchTextField?.text?.characters.count == 0)
        {
            if let dataSource = self.dataSource
            {
                let numberOfItems = dataSource.numberOfChosenItems(self.collectionView as! MACCollectionView)
                if (numberOfItems > 0)
                {
                    if let selectedIndexPaths = self.collectionView!.indexPathsForSelectedItems()
                    {
                        // IF nothing is selected... select the last chosenItem
                        if (selectedIndexPaths.count == 0)
                        {
                            let indexPath = NSIndexPath(forItem: numberOfItems-1, inSection: 0)
                            //self.deselectAll()
                            self.collectionView!.selectItemAtIndexPath(indexPath, animated: false, scrollPosition: .None)
                            if let cell = self.collectionView!.cellForItemAtIndexPath(indexPath) as? ChosenItemCollectionViewCell
                            {
                                self.colorizeSelectedChosenItemCollectionViewCell(cell)
                                delegate?.collectionView?(self.collectionView as! MACCollectionView, didSelectItemAtIndexPath: indexPath)
                            }
                        }
                        // ELSE delete selected item
                        else
                        {
                            var indexes = selectedIndexPaths.map({$0.item})
                            print("test.count: \(indexes.count)")
                            self.dataSource?.willRemoveItemsAtIndexPaths(selectedIndexPaths)
                            self.collectionView!.performBatchUpdates({
                                self.collectionView!.deleteItemsAtIndexPaths(selectedIndexPaths)
                                for i in 0..<indexes.count
                                {
                                    let cell = self.collectionView!.cellForItemAtIndexPath(NSIndexPath(forItem: i, inSection: 0))
                                    cell?.sizeToFit()
                                }
                                }, completion: { (completed) in
                                    self.collectionView!.collectionViewLayout.invalidateLayout()
                            })
                            
                            
                        }
                    }
                }
                
            }
        }
    }
    
    // MARK: UICollectionViewDataSource
    
    //------------------------------------------------------------------------------
    
    override func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int
    {
        return 1
    }

    //------------------------------------------------------------------------------
    
    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    {
        if (self.dataSource == nil)
        {
            return 1  // always an extra for textField
        }
        else
        {
            return self.dataSource!.numberOfChosenItems(self.collectionView as! MACCollectionView) + 1  // + 1 is for textField holder cell
        }
    }
    
    //------------------------------------------------------------------------------

    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell
    {
        // IF it is the textField
        if (indexPath.item == self.collectionView(self.collectionView!, numberOfItemsInSection: 0))
        {
            return self.createTextEntryCollectionViewCell(indexPath)
        }
        else
        {
            return self.createChosenItemsCell(indexPath)
        }
    }
    
    //------------------------------------------------------------------------------
    
    func createTextEntryCollectionViewCell(indexPath:NSIndexPath) -> TextEntryCollectionViewCell
    {
        let cell = self.collectionView!.dequeueReusableCellWithReuseIdentifier("TextEntryCollectionViewCell", forIndexPath: indexPath) as! TextEntryCollectionViewCell
        cell.textField.text = ""
        self.setupTextField(cell.textField)
        return cell
    }
    
    //------------------------------------------------------------------------------
    
    func createChosenItemsCell(indexPath:NSIndexPath) -> ChosenItemCollectionViewCell
    {
        let cell = self.collectionView!.dequeueReusableCellWithReuseIdentifier("ChosenItemCollectionViewCell", forIndexPath: indexPath) as! ChosenItemCollectionViewCell
        
        var title = ""
        if let dataSource = self.dataSource
        {
            title = dataSource.titleForItemAtIndexPath(indexPath)
        }
        
        cell.label.text = title
        
        self.formatChosenItemCollectionViewCell(cell)
        return cell
    }
    
    //------------------------------------------------------------------------------
    
    func formatChosenItemCollectionViewCell(cell:ChosenItemCollectionViewCell)
    {
        cell.contentView.layer.borderColor = self.unselectedChosenItemBorderColor
        cell.contentView.layer.borderWidth = self.unselectedChosenItemBorderWidth
        cell.contentView.layer.cornerRadius = self.unselectedChosenItemCornerRadius
        
        if (cell.selected)
        {
            self.colorizeSelectedChosenItemCollectionViewCell(cell)
        }
        else
        {
            self.colorizeUnselectedChosenItemCollectionViewCell(cell)
        }
    }
    
    //------------------------------------------------------------------------------
    
    func colorizeSelectedChosenItemCollectionViewCell(cell:ChosenItemCollectionViewCell)
    {
        cell.contentView.backgroundColor = self.selectedChosenItemBackgroundColor
        cell.label.textColor = self.selectedChosenItemTextColor
    }
    
    //------------------------------------------------------------------------------
    
    func colorizeUnselectedChosenItemCollectionViewCell(cell:ChosenItemCollectionViewCell)
    {
        cell.contentView.backgroundColor = self.unselectedChosenItemBackgroundColor
        cell.label.textColor = self.unselectedChosenItemTextColor
    }
    
    //------------------------------------------------------------------------------
    
    func setupTextField(textField:UITextField)
    {
        self.searchTextField = textField
        self.searchTextField?.delegate = self
        self.searchTextField?.becomeFirstResponder()
    }
    
    //------------------------------------------------------------------------------
    
    override func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath)
    {
        self.deselectAll()
        self.collectionView!.selectItemAtIndexPath(indexPath, animated: false, scrollPosition: .None)
        if let cell = self.collectionView!.cellForItemAtIndexPath(indexPath) as? ChosenItemCollectionViewCell
        {
            self.delegate?.collectionView?(self.collectionView as! MACCollectionView, didSelectItemAtIndexPath: indexPath)
            self.colorizeSelectedChosenItemCollectionViewCell(cell)
        }
    }
    
    //------------------------------------------------------------------------------
    
    func deselectAll()
    {
        if let dataSource = self.dataSource
        {
            for i in 0..<dataSource.numberOfChosenItems(self.collectionView as! MACCollectionView)
            {
                if let cell = self.collectionView?.cellForItemAtIndexPath(NSIndexPath(forItem: i, inSection: 0)) as? ChosenItemCollectionViewCell
                {
                    self.collectionView?.deselectItemAtIndexPath(NSIndexPath(forItem: i, inSection: 0), animated: false)
                    self.delegate?.collectionView?(self.collectionView as! MACCollectionView, didSelectItemAtIndexPath: NSIndexPath(forItem: i, inSection: 0))
                }
            }
        }
    }
    
    //------------------------------------------------------------------------------
    
    func textFieldShouldReturn(textField: UITextField) -> Bool
    {
        if let dataSource = self.dataSource
        {
            dataSource.handleReturnKeypress(self.collectionView! as! MACCollectionView)
        }
        return true
    }
    
    
    //------------------------------------------------------------------------------
    
    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool
    {
        // if it's the first letter
        if (self.searchTextField!.text?.characters.count == 0)
        {
            self.deselectAll()
        }
        return true
    }
    
    //------------------------------------------------------------------------------
    
    func reloadData()
    {
        dispatch_async(dispatch_get_main_queue())
        {
            self.collectionView!.reloadData()
//            self.collectionViewHeightConstraint.constant = self.collectionView.collectionViewLayout.collectionViewContentSize().height + self.collectionView.contentInset.top + self.collectionView.contentInset.bottom
            self.focusOnTextField()
        }
        return
    }
    
    //------------------------------------------------------------------------------
    
    func focusOnTextField()
    {
        delay(0.1) {
            self.searchTextField?.becomeFirstResponder()
            
        }
    }
    
    //------------------------------------------------------------------------------
    
    func calculateLabelSize(text:String) -> CGSize
    {
        let minimumWidth = CGFloat(10.0)
        let minimumHeight = CGFloat(20.0)
        let font = UIFont.systemFontOfSize(CGFloat(17.0))
        let fontAttributes = [NSFontAttributeName: font] as [String:AnyObject] // it says name, but a UIFont works
        var size = (text as NSString).sizeWithAttributes(fontAttributes)
        
        //size.height = 30.0
        if (size.height < minimumHeight)
        {
            size.height = minimumHeight
        }
        
        if (size.width < minimumWidth)
        {
            size.width = minimumWidth
        }
        
        // pad left and right
        size.width += 3.0
        return size
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize
    {
        var text:String = ""
        if let dataSource = self.dataSource
        {
            // IF it's the textField
            if (indexPath.item == dataSource.numberOfChosenItems(self.collectionView as! MACCollectionView))
            {
                if let textField = self.searchTextField
                {
                    text = textField.text!
                }
                else
                {
                    text = "0"
                }

            }
            else
            {
               text = dataSource.titleForItemAtIndexPath(indexPath)
            }
        }
        return self.calculateLabelSize(text)
    }
    
    
    // MARK: UICollectionViewDelegate

    /*
    // Uncomment this method to specify if the specified item should be highlighted during tracking
    override func collectionView(collectionView: UICollectionView, shouldHighlightItemAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment this method to specify if the specified item should be selected
    override func collectionView(collectionView: UICollectionView, shouldSelectItemAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
    override func collectionView(collectionView: UICollectionView, shouldShowMenuForItemAtIndexPath indexPath: NSIndexPath) -> Bool {
        return false
    }

    override func collectionView(collectionView: UICollectionView, canPerformAction action: Selector, forItemAtIndexPath indexPath: NSIndexPath, withSender sender: AnyObject?) -> Bool {
        return false
    }

    override func collectionView(collectionView: UICollectionView, performAction action: Selector, forItemAtIndexPath indexPath: NSIndexPath, withSender sender: AnyObject?) {
    
    }
    */

}
