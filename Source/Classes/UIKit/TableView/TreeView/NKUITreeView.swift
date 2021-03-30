//
//  NKUITreeView.swift
//  Alamofire
//
//  Created by Hunt on 2021/3/30.
//

import Foundation
import UIKit

@objc
public protocol NKTreeViewDataSource : NSObjectProtocol{
    func treeView(_ treeView:NKTreeView, atIndexPath indexPath:IndexPath, withTreeViewNode treeViewNode:NKTreeViewNode) -> UITableViewCell
    func treeViewSelectedNodeChildren(for treeViewNodeItem:AnyObject) -> [AnyObject]
    func treeViewDataArray() -> [AnyObject]
}

@objc
public protocol NKTreeViewDelegate : NSObjectProtocol{
    
    func treeView(_ treeView: NKTreeView, heightForRowAt indexPath: IndexPath, withTreeViewNode treeViewNode:NKTreeViewNode) -> CGFloat
    func treeView(_ treeView: NKTreeView, didSelectRowAt treeViewNode:NKTreeViewNode, atIndexPath indexPath:IndexPath)
    func treeView(_ treeView: NKTreeView, didDeselectRowAt treeViewNode:NKTreeViewNode, atIndexPath indexPath: IndexPath)
    func willExpandTreeViewNode(treeViewNode:NKTreeViewNode, atIndexPath: IndexPath)
    func didExpandTreeViewNode(treeViewNode:NKTreeViewNode, atIndexPath: IndexPath)
    func willCollapseTreeViewNode(treeViewNode:NKTreeViewNode, atIndexPath: IndexPath)
    func didCollapseTreeViewNode(treeViewNode:NKTreeViewNode, atIndexPath: IndexPath)
    
}

public class NKTreeView: UITableView {
    
    @IBOutlet open weak var treeViewDataSource:NKTreeViewDataSource?
    @IBOutlet open weak var treeViewDelegate: NKTreeViewDelegate?
    fileprivate var treeViewController = NKTreeViewController(treeViewNodes: [])
    fileprivate var selectedTreeViewNode:NKTreeViewNode?
    public var collapseNoneSelectedRows = false
    fileprivate var mainDataArray:[NKTreeViewNode] = []
    
    
    override public init(frame: CGRect, style: UITableView.Style) {
        super.init(frame: frame, style: style)
        commonInit()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    func commonInit(){
        super.delegate = self
        super.dataSource = self
        treeViewController.treeViewControllerDelegate = self as NKTreeViewControllerDelegate
        self.backgroundColor = UIColor.clear
    }
    
    override public func reloadData() {
        
        guard let treeViewDataSource = self.treeViewDataSource else {
            mainDataArray = [NKTreeViewNode]()
            return
        }
        
        mainDataArray = [NKTreeViewNode]()
        treeViewController.treeViewNodes.removeAll()
        for item in treeViewDataSource.treeViewDataArray() {
            treeViewController.addTreeViewNode(with: item)
        }
        mainDataArray = treeViewController.treeViewNodes
        
        super.reloadData()
    }

    public func reloadDataWithoutChangingRowStates() {
        
        guard let treeViewDataSource = self.treeViewDataSource else {
            mainDataArray = [NKTreeViewNode]()
            return
        }
        
        if (treeViewDataSource.treeViewDataArray()).count > treeViewController.treeViewNodes.count {
            mainDataArray = [NKTreeViewNode]()
            treeViewController.treeViewNodes.removeAll()
            for item in treeViewDataSource.treeViewDataArray() {
                treeViewController.addTreeViewNode(with: item)
            }
            mainDataArray = treeViewController.treeViewNodes
        }
        super.reloadData()
    }
    
    fileprivate func deleteRows() {
        if treeViewController.indexPathsArray.count > 0 {
            self.beginUpdates()
            self.deleteRows(at: treeViewController.indexPathsArray, with: .automatic)
            self.endUpdates()
        }
    }
    
    public func deleteRow(at indexPath:IndexPath) {
        self.beginUpdates()
        self.deleteRows(at: [indexPath], with: .automatic)
        self.endUpdates()
    }
    
    fileprivate func insertRows() {
        if treeViewController.indexPathsArray.count > 0 {
            self.beginUpdates()
            self.insertRows(at: treeViewController.indexPathsArray, with: .automatic)
            self.endUpdates()
        }
    }
    
    fileprivate func collapseRows(for treeViewNode: NKTreeViewNode, atIndexPath indexPath: IndexPath ,completion: @escaping () -> Void) {
        guard let treeViewDelegate = self.treeViewDelegate else { return }
        if #available(iOS 11.0, *) {
            self.performBatchUpdates({
                deleteRows()
            }, completion: { (complete) in
                treeViewDelegate.didCollapseTreeViewNode(treeViewNode: treeViewNode, atIndexPath:indexPath)
                completion()
            })
        } else {
            CATransaction.begin()
            CATransaction.setCompletionBlock({
                treeViewDelegate.didCollapseTreeViewNode(treeViewNode: treeViewNode, atIndexPath: indexPath)
                completion()
            })
            deleteRows()
            CATransaction.commit()
        }
    }
    
    fileprivate func expandRows(for treeViewNode: NKTreeViewNode, withSelected indexPath: IndexPath) {
        guard let treeViewDelegate = self.treeViewDelegate else {return}
        if #available(iOS 11.0, *) {
            self.performBatchUpdates({
                insertRows()
            }, completion: { (complete) in
                treeViewDelegate.didExpandTreeViewNode(treeViewNode: treeViewNode, atIndexPath: indexPath)
            })
        } else {
            CATransaction.begin()
            CATransaction.setCompletionBlock({
                treeViewDelegate.didExpandTreeViewNode(treeViewNode: treeViewNode, atIndexPath: indexPath)
            })
            insertRows()
            CATransaction.commit()
        }
    }
    
    func getAllCells() -> [UITableViewCell] {
        var cells = [UITableViewCell]()
        for section in 0 ..< self.numberOfSections{
            for row in 0 ..< self.numberOfRows(inSection: section){
                cells.append(self.cellForRow(at: IndexPath(row: row, section: section))!)
            }
        }
        return cells
    }
    public func expandAllRows() {
        treeViewController.expandAllRows()
        reloadDataWithoutChangingRowStates()
        
    }
    
    public func collapseAllRows() {
        treeViewController.collapseAllRows()
        reloadDataWithoutChangingRowStates()
    }
}

extension NKTreeView : UITableViewDelegate {
    
    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let treeViewNode = treeViewController.getTreeViewNode(atIndex: indexPath.row)
        return (self.treeViewDelegate?.treeView(tableView as! NKTreeView,heightForRowAt: indexPath,withTreeViewNode :treeViewNode))!
    }
    
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedTreeViewNode = treeViewController.getTreeViewNode(atIndex: indexPath.row)
        guard let treeViewDelegate = self.treeViewDelegate else { return }
        
        if let justSelectedTreeViewNode = selectedTreeViewNode {
            treeViewDelegate.treeView(tableView as! NKTreeView, didSelectRowAt: justSelectedTreeViewNode, atIndexPath: indexPath)
            var willExpandIndexPath = indexPath
            if justSelectedTreeViewNode.expand {
                treeViewController.collapseRows(for: justSelectedTreeViewNode, atIndexPath: indexPath)
                collapseRows(for: justSelectedTreeViewNode, atIndexPath: indexPath){}
            }
            else
            {
                if collapseNoneSelectedRows,
                    selectedTreeViewNode?.level == 0,
                    let collapsedTreeViewNode = treeViewController.collapseAllRowsExceptOne(),
                    treeViewController.indexPathsArray.count > 0 {
                    
                    collapseRows(for: collapsedTreeViewNode, atIndexPath: indexPath){
                        for (index, treeViewNode) in self.mainDataArray.enumerated() {
                            if treeViewNode == justSelectedTreeViewNode {
                                willExpandIndexPath.row = index
                            }
                        }
                        self.treeViewController.expandRows(atIndexPath: willExpandIndexPath, with: justSelectedTreeViewNode, openWithChildrens: false)
                        self.expandRows(for: justSelectedTreeViewNode, withSelected: indexPath)
                    }
                    
                }else{
                    treeViewController.expandRows(atIndexPath: willExpandIndexPath, with: justSelectedTreeViewNode, openWithChildrens: false)
                    expandRows(for: justSelectedTreeViewNode, withSelected: indexPath)
                }
            }
        }
    }
}

extension NKTreeView : UITableViewDataSource {
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return treeViewController.treeViewNodes.count
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let treeViewNode = treeViewController.getTreeViewNode(atIndex: indexPath.row)
        return (self.treeViewDataSource?.treeView(tableView as! NKTreeView, atIndexPath: indexPath, withTreeViewNode: treeViewNode))!
    }
}

extension NKTreeView : NKTreeViewControllerDelegate {
    public func getChildren(forTreeViewNodeItem item: AnyObject, with indexPath: IndexPath) -> [AnyObject] {
        return (self.treeViewDataSource?.treeViewSelectedNodeChildren(for: item))!
    }
    
    public func willCollapseTreeViewNode(treeViewNode: NKTreeViewNode, atIndexPath: IndexPath) {
        self.treeViewDelegate?.willCollapseTreeViewNode(treeViewNode: treeViewNode, atIndexPath: atIndexPath)
    }
    
    public func willExpandTreeViewNode(treeViewNode: NKTreeViewNode, atIndexPath: IndexPath) {
        self.treeViewDelegate?.willExpandTreeViewNode(treeViewNode: treeViewNode, atIndexPath: atIndexPath)
    }
}
