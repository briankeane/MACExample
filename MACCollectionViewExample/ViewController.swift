//
//  ViewController.swift
//  MACCollectionViewExample
//
//  Created by Brian D Keane on 7/22/16.
//  Copyright © 2016 Brian D Keane. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    
    @IBOutlet weak var macCollectionView: MACCollectionView!
    @IBOutlet weak var tableView: UITableView!
    
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.tableView.delegate = self
        self.tableView.dataSource = self
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
        return self.words.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = self.tableView.dequeueReusableCellWithIdentifier("TableViewCell", forIndexPath: indexPath) as! TableViewCell
        cell.label.text = self.words[indexPath.row]
        return cell
    }
    
    

}

