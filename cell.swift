//: A UIKit based Playground for presenting user interface
  
import UIKit
import PlaygroundSupport

class MyViewController : UITableViewController {
    override func loadView() {
        let view = UIView()
        view.backgroundColor = .white

        let label = UILabel()
        label.frame = CGRect(x: 150, y: 200, width: 200, height: 20)
        label.text = "Hello World!"
        label.textColor = .black
        
        view.addSubview(label)
        self.view = view
        self.tableView.register(self.classForCoder, forCellReuseIdentifier: "1")
        self.tableView.dequeueReusableCell(withIdentifier: "1")
    }
}

enum DisplayType {
    case Displaying
    case NotDisplay
}

protocol MyCellProtocol:class {
    init()
    
    var displayType:DisplayType {get set}
    
    var name:String {get set}
}

class MyCellExample : MyCellProtocol {
    static let Identifier = "MyCellExampleIdentifier"
    
    private var myName = ""
    
    private var myDisplayType = DisplayType.NotDisplay
    
    required init() {
        myName = "MyCell:\(arc4random())"
    }
    
    var displayType: DisplayType {
        get {
            return myDisplayType
        }
        set {
            myDisplayType = newValue
        }
    }
    
    var name: String {
        get {
            return myName
        }
        set {
            myName = newValue
        }
    }
}

class AnotherCellExample : MyCellProtocol {
    static let Identifier = "AnotherCellExampleIdentifier"
    
    private var myName = ""
    
    private var myDisplayType = DisplayType.NotDisplay
    
    required init() {
        myName = "AnotherCell:\(arc4random())"
    }
    
    var displayType: DisplayType {
        get {
            return myDisplayType
        }
        set {
            myDisplayType = newValue
        }
    }
    
    var name: String {
        get {
            return myName
        }
        set {
            myName = newValue
        }
    }
}

class CellManager {
    var list:[MyCellProtocol] = []
    var cellType:MyCellProtocol.Type
    
    init(type:MyCellProtocol.Type) {
        cellType = type
    }
    
    func getNotDisplayCellInstance() -> MyCellProtocol {
        for item in list {
            if item.displayType == .NotDisplay {
                item.displayType = .Displaying
                return item
            }
        }
        let instance = cellType.init()
        instance.displayType = .Displaying
        list.append(instance)
        return instance
    }
}

class MyTableView {
    var typeDic:[String:MyCellProtocol.Type] = [:]
    var cellDic:[String:CellManager] = [:]
    
    func register(cellType:MyCellProtocol.Type,forCellReuseIdentifier:String) {
        typeDic[forCellReuseIdentifier] = cellType
        cellType.init()
    }
    
    func dequeueReusableCell(withIdentifier:String) -> MyCellProtocol? {
        guard let type = typeDic[withIdentifier] else {
            return nil
        }
        var manager:CellManager! = cellDic[withIdentifier]
        if manager == nil {
            manager = CellManager.init(type: type)
            cellDic[withIdentifier] = manager
        }
        return manager.getNotDisplayCellInstance()
    }
    
}

let tableView = MyTableView()
tableView.register(cellType: MyCellExample.self, forCellReuseIdentifier: MyCellExample.Identifier)
tableView.register(cellType: AnotherCellExample.self, forCellReuseIdentifier: AnotherCellExample.Identifier)

let cell1 = tableView.dequeueReusableCell(withIdentifier: MyCellExample.Identifier)!
let cell2 = tableView.dequeueReusableCell(withIdentifier: AnotherCellExample.Identifier)!
let cell3 = tableView.dequeueReusableCell(withIdentifier: MyCellExample.Identifier)!
let cell4 = tableView.dequeueReusableCell(withIdentifier: AnotherCellExample.Identifier)!

//这里模拟向下滚动回收了cell,又新显示了cell

cell1.displayType = DisplayType.NotDisplay

let cell5 = tableView.dequeueReusableCell(withIdentifier: MyCellExample.Identifier)!

cell3.displayType = DisplayType.NotDisplay

let cell6 = tableView.dequeueReusableCell(withIdentifier: MyCellExample.Identifier)!



print(cell1.name)
print(cell2.name)
print(cell3.name)
print(cell4.name)
print(cell5.name)
print(cell6.name)
print(tableView.cellDic[MyCellExample.Identifier]?.list.count)
print(tableView.cellDic[AnotherCellExample.Identifier]?.list.count)

