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
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.collectionView.dataSource = self
        self.collectionView.delegate = self
        self.collectionView.registerNib(UINib(nibName: "TextEntryCellCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "TextEntryCellCollectionViewCell")
        self.collectionView.registerNib(UINib(nibName: "SelectedCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "SelectedCell")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return self.searchResults.count
    }
    
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
            cell.label.text = self.selected[indexPath.row]
            cell.contentView.layer.borderColor = UIColor.blackColor().CGColor
            cell.contentView.layer.borderWidth = 2.0
            cell.contentView.layer.cornerRadius = 10
            
            return cell
        }
    }

    func setupTextField(textField:UITextField)
    {
        self.searchTextField = textField
        self.searchTextField?.delegate = self
        self.searchTextField?.becomeFirstResponder()
    }
    
    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
        let newTextValue = (self.searchTextField!.text! as NSString).stringByReplacingCharactersInRange(range, withString: string) as String
        self.performSearch(newTextValue)
        return true
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        if (self.searchResults.count > 0)
        {
            self.selected.append(self.searchResults[0])
            self.collectionView.reloadData()
            self.focusOnTextField()
        }
        return true
    }
    
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
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let newSelected = self.searchResults[indexPath.row]
        self.selected.append(newSelected)
        dispatch_async(dispatch_get_main_queue())
        {
            self.collectionView.reloadData()
            self.focusOnTextField()
        }
        
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        var text:String
        if (indexPath.row == self.selected.count)
        {
            if let textField = self.searchTextField
            {
                text = "0000000000000000"
            }
            else
            {
                text = "0000000000000000"
            }
        }
        else
        {
            text = self.selected[indexPath.row]
        }
        
        return self.calculateLabelSize(text)
    }

    func focusOnTextField()
    {
        delay(0.1) {
            self.searchTextField?.becomeFirstResponder()
            
        }
    }
    
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

