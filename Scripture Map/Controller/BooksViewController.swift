//
//  BooksViewController.swift
//  Scripture Map
//
//  Created by Gavin Nitta on 11/9/17.
//  Copyright © 2017 Gavin Nitta. All rights reserved.
//

import UIKit

class BooksViewController : UITableViewController {
    
    // MARK: - Constants
    private struct Storyboard {
        static let CellIdentifier = "BookCell"
        static let ShowChaptersIdentifier = "Show Chapters"
        static let ShowScriptureIdentifier = "Show Scripture"
    }
    
    // MARK: - Properties
    var books: [Book]!
    
    // MARK: - Segues
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == Storyboard.ShowScriptureIdentifier {
            if let destVC = segue.destination as? ScriptureViewController {
                if let indexPath = tableView.indexPathForSelectedRow {
                    let book = books[indexPath.row]
                    destVC.book = book
                    destVC.chapter = 0
                    destVC.title = "\(book.fullName)"
                }
            }
        } else if segue.identifier == Storyboard.ShowChaptersIdentifier {
            if let destVC = segue.destination as? ChaptersViewController {
                if let indexPath = tableView.indexPathForSelectedRow {
                    let book = books[indexPath.row]
                    destVC.book = book
                    destVC.title = "\(book.fullName)"
                }
            }
        }
    }
    
    // MARK: - Table View Data Source
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Storyboard.CellIdentifier, for: indexPath)
        cell.textLabel?.text = books[indexPath.row].fullName
        return cell
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return books.count
    }
    
    // MARK: - Table View Delegate
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let book = books[indexPath.row]
        if let _ = book.numChapters {
            performSegue(withIdentifier: Storyboard.ShowChaptersIdentifier, sender: self)
        } else {
            performSegue(withIdentifier: Storyboard.ShowScriptureIdentifier, sender: self)
        }
    }
}
