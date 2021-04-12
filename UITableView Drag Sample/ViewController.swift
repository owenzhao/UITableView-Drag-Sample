//
//  ViewController.swift
//  UITableView Drag Sample
//
//  Created by zhaoxin on 2021/4/12.
//

import UIKit

class ViewController: UIViewController {
    lazy private var items = [
        "one",
        "two",
        "three",
        "four",
        "five"
    ]
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dragInteractionEnabled = true
        tableView.dataSource = self
        tableView.dragDelegate = self
    }


}

// MARK: - UITableViewDataSource
extension ViewController:UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        cell.textLabel?.text = items[indexPath.row]
        
        return cell
    }
    
//    func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
//        return true
//    }
    
    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        guard sourceIndexPath != destinationIndexPath else {
            return
        }
        
        let item = items[sourceIndexPath.row]
        
        if sourceIndexPath.row < destinationIndexPath.row {
            items.insert(item, at: destinationIndexPath.row + 1)
            items.remove(at: sourceIndexPath.row)
        } else {
            items.remove(at: sourceIndexPath.row)
            items.insert(item, at: destinationIndexPath.row)
        }
        
        items.forEach {
            print($0)
        }
        print()
    }
}

// MARK: - UITableViewDragDelegate
extension ViewController:UITableViewDragDelegate {
    func tableView(_ tableView: UITableView, itemsForBeginning session: UIDragSession, at indexPath: IndexPath) -> [UIDragItem] {
        // return [] // return [] won't stop the table view from draging. However, Apple wants us to do it on our own.
        
        return [UIDragItem(itemProvider: NSItemProvider(object: items[indexPath.row] as NSItemProviderWriting))]
    }
}
