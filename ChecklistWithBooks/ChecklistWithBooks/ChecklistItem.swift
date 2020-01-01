import Foundation

class ChecklistItem: NSObject, NSCoding {
    
    var text = ""
    var checked: Bool = false
    
    //для сохранения
    func encode(with aCoder: NSCoder) {
        aCoder.encode(text, forKey: "Text")
        aCoder.encode(checked, forKey: "Checked")
    }
    //для загрузки
    required init?(coder aDecoder: NSCoder) {
        text = aDecoder.decodeObject(forKey: "Text") as! String
        checked = aDecoder.decodeBool(forKey: "Checked")
        super.init()
    }
    override init(){
        super.init()
    }
    
    func toggleChecked() {
        checked = !checked
    }

}
