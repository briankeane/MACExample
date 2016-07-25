//
//  ViewController.swift
//  MACCollectionViewExample
//
//  Created by Brian D Keane on 7/22/16.
//  Copyright © 2016 Brian D Keane. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UICollectionViewDataSource, UICollectionViewDelegate, UITextFieldDelegate, UICollectionViewDelegateFlowLayout
{
    
    @IBOutlet weak var collectionViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var tableView: UITableView!
    
    var searchTextField:UITextField?
    
    var words = [
        "abandon",
        "abandoned",
        "ability",
        "able",
        "about",
        "above",
        "abroad",
        "absence",
        "absent",
        "absolute",
        "absolutely",
        "absorb",
        "abuse",
        "abuse",
        "academic",
        "accent",
        "accept",
        ]
    
    var searchResults:Array<String> = []
    var selected:Array<String> = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.setupTableView()
        self.setupCollectionView()
        self.setupListeners()
    }
    
    //------------------------------------------------------------------------------
    
    func setupListeners()
    {
        NSNotificationCenter.defaultCenter().addObserverForName(UITextFieldTextDidChangeNotification, object: nil, queue: NSOperationQueue.mainQueue()) { (notification) in
            self.textFieldChanged()
        }
        
        NSNotificationCenter.defaultCenter().addObserverForName("BackspacePressedEvent", object: nil, queue: NSOperationQueue.mainQueue()) { (notification) in
            self.backspacePressed()
        }
    }
    
    //------------------------------------------------------------------------------
    
    func setupTableView()
    {
        self.tableView.delegate = self
        self.tableView.dataSource = self
    }
    //------------------------------------------------------------------------------
    
    func setupCollectionView()
    {
        self.collectionView.dataSource = self
        self.collectionView.delegate = self
        self.collectionView.registerNib(UINib(nibName: "TextEntryCellCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "TextEntryCellCollectionViewCell")
        self.collectionView.registerNib(UINib(nibName: "SelectedCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "SelectedCell")
        self.collectionView.contentInset = UIEdgeInsets(top: 4, left: 4, bottom: 4, right: 4)
    }
    
    //------------------------------------------------------------------------------
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //------------------------------------------------------------------------------
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    //------------------------------------------------------------------------------
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return self.searchResults.count
    }
    
    //------------------------------------------------------------------------------
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = self.tableView.dequeueReusableCellWithIdentifier("TableViewCell", forIndexPath: indexPath) as! TableViewCell
        cell.label.text = self.searchResults[indexPath.row]
        return cell
    }
    
    //------------------------------------------------------------------------------
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.selected.count + 1
    }
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        if (indexPath.row == self.selected.count)
        {
            let cell = self.collectionView.dequeueReusableCellWithReuseIdentifier("TextEntryCellCollectionViewCell", forIndexPath: indexPath) as! TextEntryCellCollectionViewCell
            cell.textField.text = ""
            self.setupTextField(cell.textField)
            return cell
        }
        else
        {
            let cell = self.collectionView.dequeueReusableCellWithReuseIdentifier("SelectedCell", forIndexPath: indexPath) as! SelectedCollectionViewCell
            cell.label.text = self.selected[indexPath.item]
            cell.contentView.layer.borderColor = UIColor.blackColor().CGColor
            cell.contentView.layer.borderWidth = 2.0
            cell.contentView.layer.cornerRadius = 10
            self.colorizeSelectedCell(cell)
            return cell
        }
    }
    
    //------------------------------------------------------------------------------
    
    func colorizeSelectedCell(cell:SelectedCollectionViewCell)
    {
        if (cell.selected)
        {
            self.markSelectedCollectionViewCell(cell)
        }
        else
        {
            self.markUnselectedCollectionViewItem(cell)
        }
    }
    
    //------------------------------------------------------------------------------
    
    func setupTextField(textField:UITextField)
    {
        self.searchTextField = textField
        self.searchTextField?.delegate = self
        self.searchTextField?.becomeFirstResponder()
    }
    
    //------------------------------------------------------------------------------
    
    func textFieldChanged()
    {
        if let textField = self.searchTextField
        {
            self.performSearch(textField.text!)
            self.collectionView.collectionViewLayout.invalidateLayout()

        }
    }
    
    //------------------------------------------------------------------------------
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        if (self.searchResults.count > 0)
        {
            self.selected.append(self.searchResults[0])
            self.collectionView.reloadData()
            self.focusOnTextField()
        }
        return true
    }
    
    //------------------------------------------------------------------------------
    
    func performSearch(searchString:String)
    {
        searchResults = []
        for i in 0..<words.count
        {
            if (words[i].containsString(searchString))
            {
                searchResults.append(words[i])
            }
        }
        self.tableView.reloadData()
    }
    
    //------------------------------------------------------------------------------
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let newSelected = self.searchResults[indexPath.row]
        self.selected.append(newSelected)
        dispatch_async(dispatch_get_main_queue())
        {
            self.collectionView.reloadData()
            self.collectionViewHeightConstraint.constant = self.collectionView.collectionViewLayout.collectionViewContentSize().height + self.collectionView.contentInset.top + self.collectionView.contentInset.bottom
            self.focusOnTextField()
        }
    }
    
    //------------------------------------------------------------------------------
    
    func backspacePressed()
    {
        if (self.searchTextField?.text?.characters.count == 0)
        {
            if (self.selected.count > 0)
            {
                
                if let selectedIndexPaths = self.collectionView.indexPathsForSelectedItems()
                {
                    if (selectedIndexPaths.count == 0)
                    {
                        let indexPath = NSIndexPath(forItem: self.selected.count-1, inSection: 0)
                        //self.deselectAll()
                        self.collectionView.selectItemAtIndexPath(NSIndexPath(forItem: self.selected.count-1, inSection: 0), animated: false, scrollPosition: .None)
                        if let cell = self.collectionView.cellForItemAtIndexPath(indexPath) as? SelectedCollectionViewCell
                        {
                            self.markSelectedCollectionViewCell(cell)
                        }
                    }
                    else
                    {
                        var indexes = selectedIndexPaths.map({$0.item})
                        print("test.count: \(indexes.count)")
                        for i in 0..<indexes.count
                        {
                            self.selected.removeAtIndex(indexes[i])
                        }
                        self.collectionView.performBatchUpdates({
                            self.collectionView.deleteItemsAtIndexPaths(selectedIndexPaths)
                            for i in 0..<indexes.count
                            {
                                let cell = self.collectionView.cellForItemAtIndexPath(NSIndexPath(forItem: i, inSection: 0))
                                cell?.sizeToFit()
                            }
                        }, completion: { (completed) in
                                self.collectionView.collectionViewLayout.invalidateLayout()
                        })
                        
 
                    }
                }

            }
        }
    }
    
    //------------------------------------------------------------------------------
    
    func markSelectedCollectionViewCell(cell:SelectedCollectionViewCell)
    {
        cell.contentView.backgroundColor = UIColor.blueColor()
        cell.label.textColor = UIColor.whiteColor()
    }
    
    //------------------------------------------------------------------------------
    
    func markUnselectedCollectionViewItem(cell:SelectedCollectionViewCell)
    {
        cell.selected = false
        cell.contentView.backgroundColor = UIColor.whiteColor()
        cell.label.textColor = UIColor.blueColor()
        
    }
    
    //------------------------------------------------------------------------------
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        self.deselectAll()
        self.collectionView.selectItemAtIndexPath(indexPath, animated: false, scrollPosition: .None)
        if let cell = self.collectionView.cellForItemAtIndexPath(indexPath) as? SelectedCollectionViewCell
        {
            self.markSelectedCollectionViewCell(cell)
        }
    }
    
    //------------------------------------------------------------------------------
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        var text:String
        if (indexPath.item == self.selected.count)
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
            text = self.selected[indexPath.item]
        }
        
        print("self.selected: \(self.selected)")
        print("text: \(text)")
        print("item: \(indexPath.item)")
        return self.calculateLabelSize(text)
    }
    
    //------------------------------------------------------------------------------
    
    func focusOnTextField()
    {
        delay(0.1) {
            self.searchTextField?.becomeFirstResponder()
            
        }
    }
    
    //------------------------------------------------------------------------------
    
    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
        // if it's the first letter
        if (self.searchTextField!.text?.characters.count == 0)
        {
            self.deselectAll()
        }
        return true
    }
    
    //------------------------------------------------------------------------------
    
    func deselectAll()
    {
        for i in 0..<self.selected.count
        {
            if let cell = self.collectionView.cellForItemAtIndexPath(NSIndexPath(forItem: i, inSection: 0)) as? SelectedCollectionViewCell
            {
                self.collectionView.deselectItemAtIndexPath(NSIndexPath(forItem: i, inSection: 0), animated:false)
                self.markUnselectedCollectionViewItem(cell)
            }
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
}



// top level delay function from http://stackoverflow.com/questions/24034544/dispatch-after-gcd-in-swift/24318861#24318861
func delay(delay:Double, closure:()->()) {
    dispatch_after(
        dispatch_time(
            DISPATCH_TIME_NOW,
            Int64(delay * Double(NSEC_PER_SEC))
        ),
        dispatch_get_main_queue(), closure)
}

extension UIView {
    func currentFirstResponder() -> UIResponder? {
        if self.isFirstResponder() {
            return self
        }
        
        for view in self.subviews {
            if let responder = view.currentFirstResponder() {
                return responder
            }
        }
        
        return nil
    }
}
