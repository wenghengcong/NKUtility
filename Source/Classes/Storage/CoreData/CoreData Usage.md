# 参考文档
https://developer.apple.com/library/archive/documentation/DataManagement/Conceptual/CloudKitQuickStart/Introduction/Introduction.html#//apple_ref/doc/uid/TP40014987-CH1-SW1
https://github.com/DeveloperErenLiu/CoreDataPDF
https://developer.apple.com/library/archive/navigation/#section=Technologies&topic=CloudKit
https://s0developer0apple0com.icopy.site/


# 业务指南
BS_开头的实体，表示Business，即业务实体
DS_开头，表示基本的数据结构

##  新增对象
1. 新增对象，假如不保存的话，有几种方式：
（1）保存到main context，但是不保存时，使用 rollback
（2）保存到 childe contenx，不保存时，不适用 child context save即可
（3）


# 开发工具
查看 core data 
https://betamagic.nl/products/coredatalab.html 收费软件
https://github.com/ChristianKienle/Core-Data-Editor 开源软件

# 第三方库
## TMLPersistentContainer
https://github.com/johnfairh/TMLPersistentContainer
version: 5.0.1
Shortest-path multi-step Core Data migrations in Swift

## MagicalRecord
https://github.com/magicalpanda/MagicalRecord


## CoreStore
不支持 cloudkit，很遗憾

## JSQCoreDataKit
A swifter Core Data stack 
https://github.com/jessesquires/JSQCoreDataKit
version: 9.0.3
pod 'JSQCoreDataKit'

## Sync
JSON to Core Data and back https://github.com/3lvis/Sync
pod 'Sync'

## JSON 库
https://github.com/gonzalezreal/Groot
https://github.com/Yalantis/FastEasyMapping


## 查询
https://github.com/KrakenDev/PrediKit
https://github.com/ftchirou/PredicateKit
NSPredicate 的便捷

PredicateKit 库更好用


# 概念

##  Core Data

### NSManagedObjectContext
数据库操作：NSManagedObjectContext被管理的对象上下文（对数据直接操作）NSManagedObjectContext等同于一个容器，用来存储从数据库中转换出来的所有的 OC 对象。我们的增删改查操作直接对这个类使用来获得或者修改需要的 OC 对象，它能够调用 NSPersistentStoreCoordinator类实现对数据库的同步，这个对象有点像SQLite对象(用来管理.xcdatamodeld中的数据)。
负责数据和应用库之间的交互(CRUD，即增删改查、保存等接口都是用这个对象调用)。每个 NSManagedObjectContext 和其他 NSManagedObjectContext都是完全独立的。所有的NSManagedObject（个人理解：实体数据）都存在于NSManagedObjectContext中。每个NSManagedObjectContext都知道自己管理着哪些NSManagedObject（实体数据）可以通过TA去访问底层的框架对象集合，这些对象集合统称为持久化堆栈（persistence stack）——它在应用程序和外部数据存储的对象之间提供访问通道

### NSManagedObject
NSManagedObject的工作模式有点类似于NSDictionary对象,通过键-值对来存取所有的实体属性. NSManagedObject：数据库中的数据转换而来的OC对象
setValue:forkey:存储属性值(属性名为key);
valueForKey:获取属性值(属性名为key).
每个NSManagedObject都知道自己属于哪个NSManagedObjectContext 用于插入数据使用：获得实体，改变实体各个属性值，保存后就代表插入


### NSEntityDescription
NSEntityDescription 用来描述实体(Entity) 表格结构： 相当于数据库中的一个表，TA描述一种抽象数据类型
通过Core Data从数据库中取出的对象,默认情况下都是NSManagedObject对象.
+insertNewObjectForEntityForName:inManagedObjectContext: 工厂方法，根据给定的 Entity 描述，生成相应的 NSManagedObject 对象，并插入到 ManagedObjectContext 中
Model * model = [NSEntityDescription insertNewObjectForEntityForName:@“CoreDataMode” inManagedObjectContext:self.managedObjectContext];
通过上面的代码可以得到model这个表的实例，然后可以使用这个实例去为表中的属性赋值
model.title = @“标题”;
model.content = @“内容”;

### NSPersistentStoreCoordinator
NSPersistentStoreCoordinator 持久化存储库，CoreData的存储类型（比如SQLite数据库就是其中一种）。
用来将对象管理部分和持久化部分捆绑在一起，负责相互之间的交流
用来设置CoreData存储类型和存储路径
使用 Core Data document 类型的应用程序，通常会从磁盘上的数据文中中读取或存储数据，这写底层的读写就由 Persistent Store Coordinator 来处理。一 般我们无需与它直接打交道来读写文件，Managed Object Context 在背后已经为我们调用 Persistent Store Coordinator 做了这部分工作
NSPersistentStoreCoordinator：通过解析结果去实现数据库和 OC 对象之间的相互转换，主要是操作数据库的，我们一般用不上，由系统处理


### NSManagedObjectModel
NSManagedObjectModel Core Data的模型文件，有点像SQLite的.sqlite文件(表示一个.xcdatamodeld文件)应用程序的数据模型，数据库中所有表格和他们之间的联系
NSManagedObjectModel：负责读取解析 .momod 文件
NSManagedObjectModel * model = [self managedObjectModel];//获取实例
NSDictionary * entities = [model entitiesByName];//entitiesByName 得到所有的表的名字
NSEntityDescription * entity = [entities valueForKey:@“CoreDataModel”];//从里面找出名为 Student 的表


