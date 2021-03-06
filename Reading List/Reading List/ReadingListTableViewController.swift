//
//  ReadingListTableViewController.swift
//  Reading List
//
//  Created by Ryan Murphy on 5/7/19.
//  Copyright © 2019 Lambda School. All rights reserved.
//

import UIKit

    
    class ReadingListTableViewController: UITableViewController, BookTableViewCellDelegate {
        
        let bookController = BookController()
        
        override func viewDidLoad() {
            super.viewDidLoad()
        }
        
        override func viewWillAppear(_ animated: Bool) {
            super.viewWillAppear(true)
            
            tableView.reloadData()
        }
        
        func toggleHasBeenRead(for cell: BookTableViewCell) {
            
            guard let indexPath = tableView.indexPath(for: cell) else { return }
            
            let book = bookFor(indexPath: indexPath)
            bookController.updateHasBeenRead(book: book)
            
            tableView.reloadData()
        }
        
        func bookFor(indexPath: IndexPath) -> Book {
            
            if indexPath.section == 0 {
                return bookController.readBooks[indexPath.row]
            } else {
                return bookController.unreadBooks[indexPath.row]
            }
        }
        
        // MARK: - Table view data source
        
        override func numberOfSections(in tableView: UITableView) -> Int {
            return 2
        }
        
        override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            
            if section == 0 {
                return bookController.readBooks.count
            } else {
                return bookController.unreadBooks.count
            }
        }
        
        override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "BookCell", for: indexPath)
            
            guard let bookCell = cell as? BookTableViewCell else { return cell }
            bookCell.delegate = self
            //don't have to typ the index path code over and over ...
            let book = bookFor(indexPath: indexPath)
            bookCell.book = book
            
            return cell
        }
        
        override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
            
            if self.tableView(tableView, numberOfRowsInSection: section) > 0 {
                switch section {
                case 0:
                    return "Read Books"
                case 1:
                    return "Unread Books"
                default:
                    return nil
                }
            }
            
            return nil
        }
        
        override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
            
            if editingStyle == .delete {
                
                bookController.deleteBook(book: bookFor(indexPath: indexPath))
                tableView.deleteRows(at: [indexPath], with: .fade)
            }
        }
        
        // MARK: - Navigation
        
        override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
            
            if segue.identifier == "AddBook" || segue.identifier == "BookDetail" {
                
                guard let destinationViewController = segue.destination as? BookDetailViewController else { return }
                destinationViewController.bookController = bookController
               
                
                if segue.identifier == "BookDetail" {
                    
                    guard let indexPath = tableView.indexPathForSelectedRow else { return }
                  destinationViewController.book = bookFor(indexPath: indexPath)
                }
}
}
}
