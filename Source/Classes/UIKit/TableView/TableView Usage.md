
#  SwipeCellKit
Swipeable UITableViewCell/UICollectionViewCell  
https://github.com/SwipeCellKit/SwipeCellKit
version: 2.7.1
pod 'SwipeCellKit'


# 状态图、占位、空数据 
## HGNKPlaceholders
Nice library to show placeholders and Empty States for any UITableView/UICollectionView in your project
https://github.com/HamzaGhazouani/HGNKPlaceholders
version: 0.5.0
pod 'HGNKPlaceholders'

TODO: 优化的
1. 支持 Action Button 的位置是距离顶部还是底部
2. 支持多操作按钮的逻辑
3. 支持 title \subtitle\actiontitle 自定义（已经支持）

## StatefulViewController

下面这幅图表示了状态迁移
https://github.com/aschuch/StatefulViewController/blob/master/Resources/decision_tree.png

## DZNEmptyDataSet



# 表格
https://github.com/evrencoskun/TableView


# 骨架屏
https://github.com/Juanpe/SkeletonView


# 静态表格
https://github.com/xmartlabs/Eureka 



# 目录视图
https://github.com/BackWorld/TreeTableView 提供实现思路
https://github.com/gringoireDM/LNZTreeView
https://github.com/genkernel/TreeView
https://github.com/cenksk/NKTreeView    最终采用
https://github.com/partho-maple/PBTreeView      挺好的实现
https://github.com/KiranJasvanee/InfinityExpandableTableTree    
https://github.com/Augustyniak/RATreeView       star 数很多，不过是 oc


# 索引视图
https://github.com/mindz-eye/MYTableViewIndex

# 分割线
* 分割线问题一：多余的分割线
在动态 cell 中，会有多余的分割线，只要将 tableview.tableFooterView 设置为空即可
```
self.tableView.tableFooterView = UIView()
```

或者
```
tableView.sectionFooterHeight = 0.f;
tableView.sectionHeaderHeight = 0.f;

```


* 问题二：隐藏分割线
```
tableView.separatorStyle = .none
```

或者直接调整分割线的属性
```
separatorInset.right = .greatestFiniteMagnitude

subviews.forEach { (view) in
    if type(of: view).description() == "_UITableViewCellSeparatorView" {
        view.isHidden = true
       }
   }

```


* 问题三：调整分割线位置
```
tableView.separatorInset
```



* 问题四：调整分割线无效
https://stackoverflow.com/questions/25770119/ios-8-uitableview-separator-inset-0-not-working
参考：https://stackoverflow.com/a/25877725/4124634

最佳实践
```
import UIKit

extension UITableViewCell {

  override public var layoutMargins: UIEdgeInsets {
    get { return UIEdgeInsets.zero }
    set { }
  }

}
```
