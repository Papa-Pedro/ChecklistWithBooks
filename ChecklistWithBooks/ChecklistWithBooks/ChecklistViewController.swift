
import UIKit

class ChecklistViewController: UITableViewController, AddItemViewControllerDelegate {
 
    var items: [ChecklistItem]
  /*  var row0item: ChecklistItem
    var row1item: ChecklistItem
    var row2item: ChecklistItem
    var row3item: ChecklistItem
    var row4item: ChecklistItem*/
  /*  var row0checked = false
    var row1checked = true
    var row2checked = true
    var row3checked = false
    var row4checked = true*/
    //инициализация массива данных
    required init?(coder aDecoder: NSCoder) {
        items = [ChecklistItem]() //проверяем
        super.init(coder: aDecoder)
        loadChecklistItems()
        /*items = [ChecklistItem]()
        let row0item = ChecklistItem()
        row0item.text = "Walk the dog"
        row0item.checked = false
        items.append(row0item)
        let row1item = ChecklistItem()
        row1item.text = "Brush my teeth"
        row1item.checked = true
        items.append(row1item)
        let row2item = ChecklistItem()
        row2item.text = "Learn iOS development"
        row2item.checked = true
        items.append(row2item)
        let row3item = ChecklistItem()
        row3item.text = "Soccer practice"
        row3item.checked = false
        items.append(row3item)
        let row4item = ChecklistItem()
        row4item.text = "Eat ice cream"
        row4item.checked = true
        items.append(row4item)
        let row5item = ChecklistItem()
        row5item.text = "Watching a series"
        row5item.checked = true
        items.append(row5item)
        super.init(coder: aDecoder)
        print("Documents folder is \(documentsDirectiry())")
        print("Data file path is \(dataFilePath())")*/
    }
    /*
    @IBAction func addItem() { //добавляет новую строку в массив
        let newRowIndex = items.count //узнаем индекс нового элемента
        
        let item = ChecklistItem()
        item.text = "I am a new row"
        item.checked = false
        items.append(item)
        
        let indexPath = IndexPath(row: newRowIndex, section: 0)
        let indexPaths = [indexPath]
        tableView.insertRows(at: indexPaths, with: .automatic)
    }*/
    
    func addItemViewControllerDidCancel(_ controller: ItemDetailViewController) {
        dismiss(animated: true, completion: nil) //закрытие методаAddItem screen
    }
    //делегат добавление элемента
    func addItemViewController(_ controller: ItemDetailViewController, didFinishAdding item: ChecklistItem) {
        let newRowIndex = items.count
        items.append(item) //вставляем объект в массив
        //на экран
        let indexPath = IndexPath(row: newRowIndex, section: 0)
        let indexPaths = [indexPath]
        tableView.insertRows(at: indexPaths, with: .automatic)
        
        dismiss(animated: true, completion: nil)//переход изAddItemViewController сюда
        saveChecklistItem()
    }
    
    func addItemViewController(_ controller: ItemDetailViewController, didFinishEditing item: ChecklistItem) {
        //проверяем есть ли индекс?
        if let index = items.index(of: item) {
            let indexPath = IndexPath(row: index, section: 0)
            if let cell = tableView.cellForRow(at: indexPath) {
                //обновление лейбла
                configureText(for: cell, with: item)
            }
        }
        dismiss(animated: true, completion: nil)
        saveChecklistItem()
    }
    //передача данных новому контролеру
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        //даем переходу уникальный индфикатор
        if segue.identifier == "AddItem" {
            //находим контролер
            let navigationController = segue.destination as! UINavigationController
            //находим AddItemViewController
            let controller = navigationController.topViewController as! ItemDetailViewController
            //мы застовляем его делегировать сюда(соед. установленно)
            controller.delegete = self
        } else if segue.identifier == "EditItem" {
            let navigationController = segue.destination as! UINavigationController
            let controller = navigationController.topViewController as! ItemDetailViewController
            //включение кнопки назад
            controller.delegete = self
            if let indexPath = tableView.indexPath(for: sender as! UITableViewCell) {
                //находим конкретную ячейку(получаем ее)
                controller.itemToEdit = items[indexPath.row]
                //получаем объект
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    //удаление строки
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        // 1
        items.remove(at: indexPath.row)
        //2
        let indexPaths = [indexPath]
        tableView.deleteRows(at: indexPaths, with: .automatic)
        saveChecklistItem()
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int { //говорим сколько будет строк компилятуру
        return items.count
    }
    //вызывается когда нажимаешь на ячейку работа с галками
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let cell = tableView.cellForRow(at: indexPath) {
            let item = items[indexPath.row]
            item.toggleChecked()
    /*        if indexPath.row == 0 { //проверка на нажитие и подготовка изменение
                row0item.checked = !row0item.checked
            } else if indexPath.row == 1 {
                row1item.checked = !row1item.checked
            } else if indexPath.row == 2 {
                row2item.checked = !row2item.checked
            } else if indexPath.row == 3 {
                row3item.checked = !row3item.checked
            } else if indexPath.row == 4 {
                row4item.checked = !row4item.checked
            }*/
            configureCheckmark(for: cell, with: item)
        }
        //добавляет анимацию выбора (cерое выделение)
        tableView.deselectRow(at: indexPath, animated: true)
        saveChecklistItem()
    }
    //работает с табличными предствлениями (Строки)
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell  = tableView.dequeueReusableCell(withIdentifier: "ChecklistItem", for: indexPath) //инициилизурем строки
        let item = items[indexPath.row]
        configureText(for: cell, with: item) //cтавит галочки
        /* if indexPath.row == 0 {  //заполняем
         label.text = row0item.text
         } else if indexPath.row == 1 {
         label.text = row1item.text
         } else if indexPath.row == 2 {
         label.text = row2item.text
         } else if indexPath.row == 3 {
         label.text = row3item.text
         } else if indexPath.row == 4 {
         label.text = row4item.text
         }*/
        configureCheckmark(for: cell, with: item) //проверка стоит галочка или нет
        return cell
    }
    //проверка на заранее поставленые флажки
    func configureCheckmark(for cell: UITableViewCell, with item: ChecklistItem) {
        //ar isChecked = false
        //let item = items[indexPath.row]
        let label = cell.viewWithTag(1001) as! UILabel
        if item.checked {
            label.text = "√" //поменяли галочки на этот символ
            //cell.accessoryType = .checkmark//есть галочка
        } else {
            label.text = "" //или пустой
            //cell.accessoryType = .none //нет
        }
    /*    if indexPath.row == 0 {
            isChecked = row0item.checked
        } else if indexPath.row == 1 {
            isChecked = row1item.checked
        } else if indexPath.row == 2 {
            isChecked = row2item.checked
        } else if indexPath.row == 3 {
            isChecked = row3item.checked
        } else if indexPath.row == 4 {
            isChecked = row4item.checked
        }
        
        if isChecked {
            cell.accessoryType = .checkmark
        } else {
            cell.accessoryType = .none
        }*/
    }

    //вызывает конкретный элемент и указывает на ячейку
    func configureText(for cell: UITableViewCell, with item: ChecklistItem) {
        let label = cell.viewWithTag(1000) as! UILabel
        label.text = item.text
    }
    //cохраниение файла
    func documentsDirectiry() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
    //создание полного пути фала который находится в каталоге документов
    func dataFilePath() -> URL {
        return documentsDirectiry().appendingPathComponent("Checklists.plist")
    }
    
    func loadChecklistItems(){
        let path = dataFilePath() //получаем путь файла
        //попробуй загрузить содержимое checklistplist в файл
        //не получится при первом запуске
        if let data = try? Data(contentsOf: path) {
            let unarchiver = NSKeyedUnarchiver(forReadingWith: data)
            items = unarchiver.decodeObject(forKey: "ChecklistItems") as! [ChecklistItem]
            unarchiver.finishDecoding()
        }
    }
    
    //функция для сохранения
    func saveChecklistItem(){
        let data = NSMutableData()
        let archiver = NSKeyedArchiver(forWritingWith: data)//cоздает файл
        archiver.encode(items, forKey: "ChecklistItems")//кодирует items из check...
        archiver.finishEncoding()
        data.write(to: dataFilePath(), atomically: true) //помещаем объект который будем записывать в файл
    }

}

