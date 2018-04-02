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
    
    @IBOutlet weak var tableView: UITableView!
    
    let data = TrendsData()

    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.delegate = self
        tableView.dataSource = data

        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        data.reload() {(error: NSError?) in
            DispatchQueue.main.async {
                UIApplication.shared.isNetworkActivityIndicatorVisible = false
                if let loadError = error {
                    self.presentError(error: loadError)
                } else {
                    self.tableView.reloadData()
                }
            }
        }
    }
    
    func presentError(error: NSError) {
        let alert = UIAlertController(title: "Error", message: "\(error)", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "Default action"), style: .cancel))
        present(alert, animated: true, completion: nil)
    }

}

