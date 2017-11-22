//
//  VolumesViewController.swift
//  Scripture Map
//
//  Created by Gavin Nitta on 11/9/17.
//  Copyright © 2017 Gavin Nitta. All rights reserved.
//

import UIKit

class VolumesViewController : UITableViewController {
    
    // MARK: - Constants
    private struct Storyboard {
        static let VolumeIdentifier = "VolumeCell"
        static let ShowBooksSegueIdentifier = "Show Books"
    }
    
    var volumes: [String] = GeoDatabase.sharedGeoDatabase.volumes()
    
    // MARK: - Segue
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == Storyboard.ShowBooksSegueIdentifier {
            if let destVC = segue.destination as? BooksViewController {
                if let indexPath = tableView.indexPathForSelectedRow {
                    destVC.books = GeoDatabase.sharedGeoDatabase.booksForParentId(indexPath.row + 1)
                    destVC.title = volumes[indexPath.row]
                }
            }
        }
    }

    // MARK: - Table View Delegate
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Storyboard.VolumeIdentifier, for: indexPath)
        cell.textLabel?.text = volumes[indexPath.row]
        return cell
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return volumes.count
    }
}
