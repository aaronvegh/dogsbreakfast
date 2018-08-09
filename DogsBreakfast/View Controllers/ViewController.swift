//
//  ViewController.swift
//  DogsBreakfast
//
//  Created by Aaron Vegh on 2018-08-08.
//  Copyright © 2018 Aaron Vegh. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchField: UISearchBar!
    
    private let delayTime = 0.5
    private var recipes = [Recipe]()
    private var maxFailureCount: Int = 3
    private var loadFailures: Int = 0
    
    private lazy var operationQueue: DogsBreakfastOperationQueue = {
       let operationQueue = DogsBreakfastOperationQueue()
        operationQueue.maxConcurrentOperationCount = 1
        return operationQueue
    }()

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destination = segue.destination as? WebViewController {
            if
                let selectedPath = tableView.indexPathForSelectedRow,
                let recipeURL = recipes[selectedPath.row].url {
                destination.url = recipeURL
            }
        }
    }
}

extension ViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return recipes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: DogsBreakfastResultCell.identifier, for: indexPath) as? DogsBreakfastResultCell else { return UITableViewCell() }
        let recipe = recipes[indexPath.row]
        cell.configure(with: recipe)

        return cell
    }
}

extension ViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 65 // magic numbers are bad! But look, "magic" is right there in the name!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.performSegue(withIdentifier: "loadWebView", sender: self)
    }
}

extension ViewController: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        /// If a previous request is in flight, cancel it
        NSObject.cancelPreviousPerformRequests(withTarget: self, selector: #selector(self.reload(_:)), object: searchBar)
        /// Fire request with a delay
        perform(#selector(self.reload(_:)), with: searchBar, afterDelay: delayTime)
    }
    
    @objc func reload(_ searchBar: UISearchBar) {
        guard let text = searchBar.text else { return }
        
        /// Modularize this a bit so we can re-run it in the event of failure
        func runSearch(text: String) {
            let op = DogsBreakfastOperation(query: text)
            op.completedData = { result in
                DispatchQueue.main.async {
                    switch result {
                    case .success(let recipes):
                        self.recipes = recipes
                        self.tableView.reloadData()
                    case .failure:
                        self.loadFailures += 1
                        if self.loadFailures < self.maxFailureCount {
                            /// Make followup requests take EXPONENTIALLY LONGER... ish.
                            let modifier = TimeInterval(pow(Double(self.loadFailures), Double(2)))
                            DispatchQueue.main.asyncAfter(deadline: .now() + modifier) {
                                runSearch(text: text)
                            }
                        } else {
                            self.showAlert(title: "Sorry, we can't load recipes now.", message: "Now *that* is a dog's breakfast!")
                        }
                    }
                }
            }
            operationQueue.addOperation(op)
        }
        
        runSearch(text: text)
    }
}

