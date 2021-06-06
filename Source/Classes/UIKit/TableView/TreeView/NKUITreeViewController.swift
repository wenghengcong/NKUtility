//
//  NKUITreeViewController.swift
//  Alamofire
//
//  Created by Hunt on 2021/3/30.
//

import Foundation

public protocol NKTreeViewControllerDelegate : NSObjectProtocol {
    func getChildren(forTreeViewNodeItem item:AnyObject, with indexPath:IndexPath) -> [AnyObject]
    func willExpandTreeViewNode(treeViewNode:NKTreeViewNode, atIndexPath: IndexPath)
    func willCollapseTreeViewNode(treeViewNode:NKTreeViewNode, atIndexPath: IndexPath)
}

public class NKTreeViewController:NSObject  {
    
    var treeViewNodes:[NKTreeViewNode] = []
    var indexPathsArray:[IndexPath] = []
    weak var treeViewControllerDelegate:NKTreeViewControllerDelegate?
    
    init(treeViewNodes : [NKTreeViewNode]) {
        self.treeViewNodes = treeViewNodes
    }
    
    //MARK: Tree View Nodes Functions
    func addTreeViewNode(with item:AnyObject){
        let treeViewNode = NKTreeViewNode(item: item)
        treeViewNodes.append(treeViewNode)
    }
    
    func getTreeViewNode(atIndex index: Int) -> NKTreeViewNode
    {
        if treeViewNodes.indices.contains(index){
            return treeViewNodes[index]
        }
        return treeViewNodes.last!
    }
    
    func index(of treeViewNode: NKTreeViewNode) -> Int? {
        return treeViewNodes.firstIndex(of: treeViewNode)
    }
    
    func insertTreeViewNode(parent parentTreeViewNode:NKTreeViewNode, with item:AnyObject, to index : Int)
    {
        let treeViewNode = NKTreeViewNode(item: item)
        treeViewNode.parentNode = parentTreeViewNode
        treeViewNodes.insert(treeViewNode, at: index)
    }
    
    func removeTreeViewNodesAtRange(from start:Int , to end:Int)
    {
        if start < treeViewNodes.count && end < treeViewNodes.count {
            treeViewNodes.removeSubrange(start ... end)
        }
    }
    
    func setExpandTreeViewNode(atIndex index:Int){
        treeViewNodes[index].expand = true
    }
    
    func setCollapseTreeViewNode(atIndex index:Int){
        treeViewNodes[index].expand = false
    }
    
    func setLevelTreeViewNode(atIndex index:Int, to level:Int){
        treeViewNodes[index].level = level + 1
    }
    
    // MARK: Expand Rows
    
    func addIndexPath(withRow row:Int){
        let indexPath = IndexPath(row: row , section: 0)
        indexPathsArray.append(indexPath)
    }
    
    func expandRows(atIndexPath indexPath:IndexPath, with selectedTreeViewNode:NKTreeViewNode){
        let children = self.treeViewControllerDelegate?.getChildren(forTreeViewNodeItem: selectedTreeViewNode.item, with: indexPath)
        indexPathsArray = [IndexPath]()
        var row = indexPath.row + 1
        
        if (children?.count)! > 0 {
            self.treeViewControllerDelegate?.willExpandTreeViewNode(treeViewNode: selectedTreeViewNode, atIndexPath: indexPath)
            setExpandTreeViewNode(atIndex: indexPath.row)
        }
        
        for item in children!{
            addIndexPath(withRow: row)
            insertTreeViewNode(parent: selectedTreeViewNode, with: item, to: row)
            setLevelTreeViewNode(atIndex: row, to: selectedTreeViewNode.level)
            row += 1
        }
    }
    
    // MARK: Collapse Rows
    func removeIndexPath(withRow row:inout Int, and indexPath:IndexPath){
        let treeViewNode = getTreeViewNode(atIndex: row)
        let children = self.treeViewControllerDelegate?.getChildren(forTreeViewNodeItem: treeViewNode.item, with: indexPath)
        
        let index = IndexPath(row: row , section: indexPath.section)
        indexPathsArray.append(index)
        row += 1
        
        if (treeViewNode.expand) {
            for _ in children!{
                removeIndexPath(withRow: &row, and: indexPath)
            }
        }
    }
    
    func collapseRows(for treeViewNode :NKTreeViewNode, atIndexPath indexPath:IndexPath){
        guard let treeViewControllerDelegate = self.treeViewControllerDelegate else {return}
        let treeViewNodeChildren = treeViewControllerDelegate.getChildren(forTreeViewNodeItem: treeViewNode.item, with: indexPath)
        indexPathsArray = [IndexPath]()
        var row = indexPath.row + 1
        
        if treeViewNodeChildren.count > 0 {
            treeViewControllerDelegate.willCollapseTreeViewNode(treeViewNode: treeViewNode, atIndexPath: indexPath)
        }
        
        setCollapseTreeViewNode(atIndex: indexPath.row)
        
        for _ in treeViewNodeChildren{
            removeIndexPath(withRow: &row, and: indexPath)
        }
        if indexPathsArray.count > 0 {
            removeTreeViewNodesAtRange(from: (indexPathsArray.first?.row)!, to: (indexPathsArray.last?.row)!)
        }
        
    }
    
    
    @discardableResult func collapseAllRowsExceptOne() -> NKTreeViewNode?{
        indexPathsArray = [IndexPath]()
        var collapsedTreeViewNode:NKTreeViewNode? = nil
        var indexPath = IndexPath(row: 0, section: 0)
        for treeViewNode in treeViewNodes {
            if  treeViewNode.expand , treeViewNode.level == 0 {
                collapseRows(for: treeViewNode, atIndexPath: indexPath)
                collapsedTreeViewNode = treeViewNode
            }
            indexPath.row += 1
        }
        return collapsedTreeViewNode
    }
    @discardableResult
    func expandRows(atIndexPath indexPath:IndexPath, with selectedTreeViewNode:NKTreeViewNode, openWithChildrens:Bool) -> Int{
        guard let treeViewControllerDelegate = self.treeViewControllerDelegate else {return 0}
        let treeViewNodeChildren = treeViewControllerDelegate.getChildren(forTreeViewNodeItem: selectedTreeViewNode.item, with: indexPath)
        indexPathsArray = [IndexPath]()
        var row = indexPath.row + 1
        setExpandTreeViewNode(atIndex: indexPath.row)
        
        if treeViewNodeChildren.count > 0 {
            treeViewControllerDelegate.willExpandTreeViewNode(treeViewNode: selectedTreeViewNode, atIndexPath: indexPath)
            for item in treeViewNodeChildren{
                addIndexPath(withRow: row)
                insertTreeViewNode(parent: selectedTreeViewNode, with: item, to: row)
                setLevelTreeViewNode(atIndex: row, to: selectedTreeViewNode.level)
                if openWithChildrens {
                    let treeViewNode = getTreeViewNode(atIndex: row)
                    let indexPath = IndexPath(row: row, section: 0)
                    row = expandRows(atIndexPath: indexPath, with: treeViewNode, openWithChildrens: openWithChildrens)
                }else {
                    row += 1
                }
                
            }
        }
        return row
    }
    
    func collapseAllRows(){
        indexPathsArray = [IndexPath]()
        var indexPath = IndexPath(row: 0, section: 0)
        for treeViewNode in treeViewNodes {
            indexPath = getIndexPathOfTreeViewNode(treeViewNode: treeViewNode)
            if  treeViewNode.level != 0 {
                setCollapseTreeViewNode(atIndex: indexPath.row)
                treeViewNodes.remove(at: indexPath.row)
            }else{
                setCollapseTreeViewNode(atIndex: indexPath.row)
            }
        }
    }
    
    func expandAllRows() {
        indexPathsArray = [IndexPath]()
        var indexPath = IndexPath(row: 0, section: 0)
        for treeViewNode in treeViewNodes {
//            if !treeViewNode.expand {
//                
//            }
            indexPath = getIndexPathOfTreeViewNode(treeViewNode: treeViewNode)
            indexPath.row = expandRows(atIndexPath: indexPath, with: treeViewNode, openWithChildrens: true)
        }
    }
    
    func getIndexPathOfTreeViewNode(treeViewNode:NKTreeViewNode) -> IndexPath {
        for (index,node) in treeViewNodes.enumerated() {
            if treeViewNode == node {
                return IndexPath(row: index, section: 0)
            }
        }
        return IndexPath(row:0, section:0)
    }
    
}
