//
//  ViewController.swift
//  Top50
//
//  Created by slava litskevich on 30.03.18.
//  Copyright © 2018 slava litskevich. All rights reserved.
//

import UIKit
import TwitterKit

class ViewController: UIViewController, UITableViewDelegate {
    
    let kBerlinWOEID = 638242
    let kGlobalWOEID = 1
    
    @IBOutlet weak var reloadButton: UIBarButtonItem!
    @IBOutlet weak var tableView: UITableView!
    
    let data = TrendsData()

    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.delegate = self
        tableView.dataSource = data
        
        loadData()
    }
    
    func loadData() {
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        reloadButton.isEnabled = false
        data.reload() {[weak self](error: Error?) in
            DispatchQueue.main.async {
                UIApplication.shared.isNetworkActivityIndicatorVisible = false
                self?.reloadButton.isEnabled = true
                if let loadError = error {
                    self?.presentError(error: loadError)
                }
                self?.title = self?.data.location?.name
                self?.tableView.reloadData()
            }
        }
    }
    
    @IBAction func reload() {
        loadData()
    }
    
    func presentError(error: Error) {
        let alert = UIAlertController(title: "Error", message: error.localizedDescription, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "Default action"), style: .cancel))
        present(alert, animated: true, completion: nil)
    }
}
