import UIKit

struct DataS {
    var sectionName: String?
    var sectionObj: [String]?
}

class EditViewController: UIViewController, CreateAndWrite, WorkWithDictionary {

    @IBOutlet weak var editTableView: UITableView!
    
    var edit: Bool?
    
    var dataSource: [DataS]?
    var variable: [String: [String?]] = [:]
    var sortedNames: [String] = []
    var sortedObjects: [String] = []
    var cellClass: EditTableViewCell!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        editTableView.dataSource = self
        editTableView.delegate = self
        if edit == nil {
            edit = false
        }
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        let url = getFileUrl("file2.plist")
        addTextIntoFile(variable as NSDictionary, url!)
        variable = (getDataFromFile(url!) as? [String: [String]])!
        refactoring(&dataSource!, variable as! [String : [String]])
        sortedNames = sortNames(variable)
        editTableView.reloadData()
    }
    
    //MARK: - ChangeRowAlert
    
    func changeRowAlert(_ row: Int, _ array: [String], _ name: String) {
        let alert = UIAlertController(title: "Измение", message: nil, preferredStyle: .alert)
        
        var alertTextField: UITextField!
        alert.addTextField { (text) in
            alertTextField = text
            alertTextField.text = array[row]
        }
        
        let saveButton = UIAlertAction(title: "Сохранить", style: .default) { (action) in
            guard let text = alertTextField.text, !text.isEmpty else { return }
            var i = 0
            while self.variable[name]![i] != array[row] {
                i += 1
            }
            self.variable[name]![i] = text
            self.updateValue(self.variable as! [String : [String]])
            self.refactoring(&self.dataSource!, self.variable as! [String : [String]])
            self.editTableView.reloadData()
        }
        
        let cancelAction = UIAlertAction(title: "Отменить", style: .cancel, handler: nil)

        alert.addAction(saveButton)
        alert.addAction(cancelAction)
        
        
        present(alert, animated: true, completion: nil)
    }
    
    // MARK: - AddSection
    func alertForSection() {
        let alert = UIAlertController(title: "Новый член персонала", message: "Введите имя", preferredStyle: .alert)

        var alertTextfield: UITextField!
        alert.addTextField { textField in
            alertTextfield = textField
            textField.placeholder = "Ф.И.О."
        }
        
        var catTextField: UITextField!
        alert.addTextField { text in
            catTextField = text
            catTextField.placeholder = "Значение"
        }

        let saveAction = UIAlertAction(title: "Сохранить", style: .default) { (action) in
            guard let text = alertTextfield.text, !text.isEmpty else { return }
            let catText = catTextField.text ?? "Empty"
            self.variable[text] = [catText]
            self.updateValue(self.variable as! [String : [String]])
            self.refactoring(&self.dataSource!, self.variable as! [String : [String]])
            self.sortedNames = self.sortNames(self.variable)
            self.editTableView.reloadData()
        }
        
        let cancelAction = UIAlertAction(title: "Отменить", style: .cancel, handler: nil)

        alert.addAction(saveAction)
        alert.addAction(cancelAction)

        present(alert, animated: true, completion: nil)
    }
    
    // MARK: - AlertAddRow
    func alertForRow(_ indexPathSection: Int) {
        let alert = UIAlertController(title: "Новая категория", message: "Введите данные", preferredStyle: .alert)
        
        var alertTextField: UITextField!
        alert.addTextField { textField in
            alertTextField = textField
        }
        
        let saveAction = UIAlertAction(title: "Сохранить", style: .default) { (action) in
            guard let text = alertTextField.text, !text.isEmpty else { return }
            self.variable[self.sortedNames[indexPathSection]]?.append(text)
            self.updateValue(self.variable as! [String:[String]])
            self.refactoring(&self.dataSource!, self.variable as! [String:[String]])
            self.editTableView.reloadData()
        }
        
        let canselAction = UIAlertAction(title: "Отменить", style: .cancel, handler: nil)
        
        alert.addAction(saveAction)
        alert.addAction(canselAction)
        
        present(alert, animated: true, completion: nil)
    }
    
    //MARK: - AlertDeleteSection
    func alertDeleteSection(_ indexPath: Int) {
        let alert = UIAlertController(title: "Вы уверены что хотите удалить объект целиком?", message: "Действие нельзя будет отменить", preferredStyle: .alert)
        
        let agreeAction = UIAlertAction(title: "Удалить", style: .default) { (action) in
            self.variable[self.sortedNames[indexPath]] = nil
            self.updateValue(self.variable as! [String:[String]])
            self.refactoring(&self.dataSource!, self.variable as! [String:[String]])
            self.sortedNames = self.sortNames(self.variable)
            self.editTableView.reloadData()
        }
        
        let disagree = UIAlertAction(title: "Отменить", style: .cancel, handler: nil)
        alert.addAction(agreeAction)
        alert.addAction(disagree)
        
        present(alert, animated: true, completion: nil)
    }
    
    @IBAction func addButton(_ sender: Any) {
        alertForSection()
    }
    
    @IBAction func editButton(_ sender: Any) {
        edit! = !edit!
        editTableView.reloadData()
    }
    
}

//MARK: - Table View Extensions
extension EditViewController: UITableViewDataSource, UITableViewDelegate {

    func numberOfSections(in tableView: UITableView) -> Int {
        let check = sortNames(variable)
        return check.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let check = sortNames(variable)
        let sorted = sortObj(variable as! [String:[String]], check[section])
        if edit == false {
            return sorted.count
        }
        else {
            return sorted.count + 1
        }
    }
    
    //MARK: - CELLS
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let sectionCell = editTableView.dequeueReusableCell(withIdentifier: "headerCell") as! EditTableViewCell
        sectionCell.backgroundColor = .lightGray
        let check = sortNames(variable)
        sectionCell.nameLabel.text = check[section]
        sectionCell.sectionNumber = section
        sectionCell.delegate = self
        
        if edit == false {
            sectionCell.sectionButton.isHidden = true
        } else {
            sectionCell.sectionButton.setTitle("Удалить объект", for: .normal)
            sectionCell.sectionButton.isHidden = false
        }
        return sectionCell
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = editTableView.dequeueReusableCell(withIdentifier: "editCell", for: indexPath) as! EditTableViewCell
        
        let check = sortNames(variable)
        let sortedArray = sortObj(variable as! [String : [String]], check[indexPath.section])
        let object = sortedArray.count
        
        if edit == false {
            cell.nameLabel.text = sortedArray[indexPath.row]
            cell.rowButton.isHidden = true
        } else {
            if object != indexPath.row {
                cell.nameLabel.text = sortedArray[indexPath.row]
                cell.rowButton.isHidden = false
                cell.rowButton.setTitle("Изменить", for: .normal)
                cell.rowNumber = indexPath.row
                cell.array = sortedArray
                cell.name = check[indexPath.section]
                cell.secondDelegate = self
            } else {
                cell.nameLabel.text = nil
                cell.rowButton.setTitle("Добавить", for: .normal)
                cell.rowButton.isHidden = false
                cell.sectionNumber = indexPath.section
                cell.delegate = self
            }
        }
        return cell
    }
    
    //MARK: - AddRow
    func tableView(_ tableView: UITableView, accessoryButtonTappedForRowWith indexPath: IndexPath) {
        alertForRow(indexPath.section)
    }
    
    //MARK: - Delete
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        let check = sortNames(variable)
        let sortedArray = sortObj(variable as! [String : [String]], check[indexPath.section])
        let object = sortedArray.count
        
        if edit == false {
            return false
        } else {
            if object > indexPath.row {
                return true
            } else {
                return false
            }
        }
    }

    //MARK: - DeleteRowsInTableView
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        let check = sortNames(variable)
        if editingStyle == .delete && edit == true {
            let section = check[indexPath.section]
            variable[section]?.remove(at: indexPath.row)
            updateValue(variable as! [String : [String]])
            refactoring(&dataSource!, variable as! [String:[String]])
            editTableView.reloadData()
        }
    }
}

extension EditViewController: ButtonDelegate, ChangeDelegate {
    func deleteSetionButton(_ view: EditTableViewCell, _ section: Int) {
        alertDeleteSection(section)
    }
    
    func addRowButton(_ view: EditTableViewCell, _ section: Int) {
        alertForRow(section)
    }
    
    func checkFunc(_ view: EditTableViewCell, _ row: Int, _ array: [String], _ name: String) {
        changeRowAlert(row, array, name)
    }
}
