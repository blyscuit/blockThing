//
//  StageTable.swift
//  BlockThing
//
//  Created by Pakin Intanate on 11/15/15.
//  Copyright © 2015 confusians. All rights reserved.
//

import Foundation

class StageTable: UITableViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 15
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        
        cell.textLabel!.text = "Text"
        
        return cell
    }
}