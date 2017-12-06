//
//  TimeLineTableViewController.swift
//  Noteworthy
//
//  Created by Johnny Hicks on 12/4/17.
//  Copyright © 2017 Johnny Hicks. All rights reserved.
//

import UIKit
import AVFoundation

class TimeLineTableViewController: UITableViewController {
    
    var avPlayer: AVPlayer!
    var avPlayerLayer: AVPlayerLayer!
    var paused: Bool = false
    
    
    

    

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.rowHeight = 350.0
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        tableView.reloadData()
    }


    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return EntryController.shared.entries.count
    }

    override func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        guard let cell = cell as? EntryTableViewCell else { return }
        cell.avPlayer?.pause()
    }
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        guard let cell = cell as? EntryTableViewCell else { return }
        cell.avPlayer?.play()
    }
    

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "entryCell", for: indexPath) as? EntryTableViewCell else { return EntryTableViewCell() }
        
        let entries = EntryController.shared.entries
        let entry = entries[indexPath.row]
        cell.entry = entry
        return cell
    }
 


    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let ec = EntryController.shared
            let entry = ec.entries[indexPath.row]
            ec.delete(entry: entry)
            
            // Delete the row from the table view
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }



    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toEditEntry" {
            if let detailVC = segue.destination as? AddEditEntryViewController,
                let selectedRow = tableView.indexPathForSelectedRow?.row {
                
                let entry = EntryController.shared.entries[selectedRow]
                detailVC.entry = entry
            }
        }
    }
}
