//
//  ViewController.swift
//  MACCollectionViewExample
//
//  Created by Brian D Keane on 7/22/16.
//  Copyright © 2016 Brian D Keane. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, MACCollectionViewDataSource, MACCollectionViewDelegate
{
    
    @IBOutlet weak var collectionViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var collectionView: MACCollectionView!
    @IBOutlet weak var tableView: UITableView!
    
    var searchTextField:UITextField?
    var macCollectionViewController:MACCollectionViewController!
    
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
        self.macCollectionViewController = MACCollectionViewController()
        self.addChildViewController(macCollectionViewController)
        self.view.addSubview(macCollectionViewController.view)
        self.macCollectionViewController.dataSource = self
        self.macCollectionViewController.delegate = self
        self.macCollectionViewController.collectionView = self.collectionView
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
    
    func numberOfChosenItems(macCollectionView: MACCollectionView) -> Int {
        return self.selected.count
    }
    
    //------------------------------------------------------------------------------
    
    func titleForItemAtIndexPath(indexPath: NSIndexPath) -> String
    {
        return self.selected[indexPath.item]
    }
    
    //------------------------------------------------------------------------------
    
    func textFieldChanged(updatedText: String)
    {
        self.performSearch(updatedText)
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
    
    func handleReturnKeypress(macCollectionView: MACCollectionView)
    {
        if (self.searchResults.count > 0)
        {
            self.selected.append(self.searchResults[self.searchResults.count-1])
            self.macCollectionViewController.reloadData()
        }
    }
    
    //------------------------------------------------------------------------------
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath)
    {
        let newSelected = self.searchResults[indexPath.row]
        self.selected.append(newSelected)
        self.macCollectionViewController.reloadData()
    }
    
    //------------------------------------------------------------------------------
    
    func willRemoveItemsAtIndexPaths(indexPaths: [NSIndexPath]) {
        var indexes:Array<Int> = indexPaths.map({$0.item}).reverse()   // reverse so decrementing
        for i in 0..<indexes.count
        {
            self.selected.removeAtIndex(indexes[i])
        }
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
