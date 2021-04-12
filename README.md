# The Simplest Sample for Dragging Operation on UITableView
One of my friend requires an app feature for Poster 2 which requires drag operation on UITableView.

I did a research and found two resolutions. They all worked. However, they were all too complex. I wanted to find the simplest way to implemented the operation. Here it is.

## Theory
There are two ways to do the tricks. One is to use  `UITableViewDiffableDataSource`, the other is to use `UITableViewDataSource`. This article is focus on the latter. If you want to know the prior, just find the link at the end of this article.

```swift
override func viewDidLoad() {
    super.viewDidLoad()
    
    tableView.dragInteractionEnabled = true
    tableView.dataSource = self
    tableView.dragDelegate = self
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

// MARK: - UITableViewDragDelegate
extension ViewController:UITableViewDragDelegate {
    func tableView(_ tableView: UITableView, itemsForBeginning session: UIDragSession, at indexPath: IndexPath) -> [UIDragItem] {
        // return [] // return [] won't stop the table view from draging. However, Apple wants us to do it on our own.
        
        return [UIDragItem(itemProvider: NSItemProvider(object: items[indexPath.row] as NSItemProviderWriting))]
    }
}
```

<br>

> `tableView.dragInteractionEnabled = true` this line must not be the last line of the three-line code, or the drag operation won't work.
> 
> In [docs](https://developer.apple.com/documentation/uikit/uitableviewdragdelegate/2897492-tableview), Apple says "Return an empty array to indicate that you do not want the specified row to be dragged." This requirement is for you to implement. Even if you return [] here, the drag operation still works.

The above code is enough for UITableView dragging operation. When you drag, the cell that you drag will move to the destination you drop. However, like all other operations on UITableView, you need to keep the model's consistence with the UI.

```swift
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
```

## References
Sample For UITableViewDiffableDataSource [catalyst_reorder_example](https://github.com/johnpdavis/catalyst_reorder_example)

Apple's Official Sample [Adopting Drag and Drop in a Table View](https://developer.apple.com/documentation/uikit/drag_and_drop/adopting_drag_and_drop_in_a_table_view)

[My Own Sample](https://github.com/owenzhao/UITableView-Drag-Sample)
