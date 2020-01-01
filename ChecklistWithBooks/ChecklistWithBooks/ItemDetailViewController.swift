import Foundation

import UIKit
//cоздаем делегаты для общения между экранами
protocol AddItemViewControllerDelegate: class {
    func addItemViewControllerDidCancel(_ controller: ItemDetailViewController)
    func addItemViewController(_ controller: ItemDetailViewController, didFinishAdding item: ChecklistItem)
    func addItemViewController(_ controller: ItemDetailViewController, didFinishEditing item: ChecklistItem)
}

class ItemDetailViewController: UITableViewController, UITextFieldDelegate {
    weak var delegete: AddItemViewControllerDelegate? //объявление делегатов
    //авто появление клавиатуры работает до того как пользователь увидит экран
    var itemToEdit: ChecklistItem?//элемент который передается
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let item = itemToEdit { //если он не 0
            title = "Edit Item" //изменим титл
            textField.text = item.text //напишем в ячейкус
            doneBarButton.isEnabled = true //делаем кнопку ячейка видимой
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        textField.becomeFirstResponder()
    }
    //отвечает за выбор ячейки
    override func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        return nil
    }
    //привязали кнопку выбора
    @IBOutlet weak var doneBarButton: UIBarButtonItem!
    //cвязали кнопку
    @IBOutlet weak var textField: UITextField!
    
    //кнопка сancel
    @IBAction func cancel() {
        delegete?.addItemViewControllerDidCancel(self)
    }
    //добавить элемент текстовое поле
    @IBAction func done() {
        if let item = itemToEdit { //выполняем код itemToEdit
            item.text = textField.text!
            //item.checked = false
            delegete?.addItemViewController(self, didFinishEditing: item) //вызываем новый метод
        } else {
            let item = ChecklistItem()
            item.text = textField.text!
            item.checked = false
            delegete?.addItemViewController(self, didFinishAdding: item)
        }
        
        //print("Contents of the text field: \(textField.text!)")
        //dismiss(animated: true, completion: nil) //перевод на прошлый экран
    }
    //метод делегата UITextField - вызывается когда пользователь изменяет текст
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        //каким будет новый текст?
        let oldText = textField.text! as NSString
        let newText = oldText.replacingCharacters(in: range, with: string) as NSString
        
        doneBarButton.isEnabled = (newText.length > 0)
        /*if newText.length > 0 {
            doneBarButton.isEnabled = true
        } else {
            doneBarButton.isEnabled = false
        }*/
        return true
    }

}
