//
//  ChaptersViewController.swift
//  Scripture Map
//
//  Created by Gavin Nitta on 11/13/17.
//  Copyright © 2017 Gavin Nitta. All rights reserved.
//

import UIKit

class ChaptersViewController : UITableViewController {
    
    // MARK: - Constants
    private struct Storyboard {
        static let CellIdentifier = "ChapterCell"
        static let ShowScriptureIdentifier = "Show Scripture"
    }
    
    // MARK: - Properties
    private weak var mapViewController: MapViewController?
    var book: Book!
    
    // MARK: - Segue
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == Storyboard.ShowScriptureIdentifier {
            if let destVC = segue.destination as? ScriptureViewController {
                if let indexPath = tableView.indexPathForSelectedRow {
                    destVC.book = book
                    destVC.chapter = indexPath.row + 1
                    destVC.title = "\(book.fullName) \(indexPath.row + 1)"
                    
                    configureDetailViewController()
                    let scriptures = GeoDatabase.sharedGeoDatabase.versesForScriptureBookId(book.id, indexPath.row + 1)
                    var locations: [(GeoPlace, GeoTag)] = []
                    for scripture in scriptures {
                        locations += GeoDatabase.sharedGeoDatabase.geoTagsForScriptureId(scripture.id)
                    }
                    mapViewController?.locations = locations
                    mapViewController?.reloadPins()
                }
            }
        }
    }
    
    // MARK: - View Controller Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configureDetailViewController()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        configureDetailViewController()
        if let mapVC = mapViewController {
            mapVC.title = "Map"
        }
    }
    
    // MARK: - Table View Data Source
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Storyboard.CellIdentifier, for: indexPath)
        cell.textLabel?.text = "Chapter \(String(indexPath.row + 1))"
        return cell
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return book.numChapters!
    }
    
    // MARK: - Table View Delegate
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: Storyboard.ShowScriptureIdentifier, sender: self)
    }
    
    // MARK: - Helpers
    func configureDetailViewController() {
        if let splitVC = splitViewController {
            if let navVC = splitVC.viewControllers.last as? UINavigationController {
                mapViewController = navVC.topViewController as? MapViewController
            } else {
                mapViewController = splitVC.viewControllers.last as? MapViewController
            }
        } else {
            mapViewController = nil
        }
    }
    
}
