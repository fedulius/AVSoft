import UIKit

class ShowViewController: UIViewController, CreateAndWrite, WorkWithDictionary {

    @IBOutlet weak var showTableView: UITableView!
    
    var dataSourse: [DataS]?
    var variable: [String: [String?]] = [:]
    var sortedNames: [String] = []
    var sortedObjects: [String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let url = getFileUrl("file2.plist")
        variable = getDataFromFile(url!) as! [String : [String?]]
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toEditVC" {
            let vc = segue.destination as! EditViewController
            vc.dataSource = self.dataSourse
            vc.variable = self.variable
            vc.edit = true
        }
    }
}

extension ShowViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        let names = sortNames(variable)
        return names.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let check = sortNames(variable)
        let sorted = sortObj(variable as! [String:[String]], check[section])
        return sorted.count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        let check = sortNames(variable)
        return check[section]
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = showTableView.dequeueReusableCell(withIdentifier: "showCell") as! ShowTableViewCell
        
        let names = sortNames(variable)
        let sortedObj = sortObj(variable as! [String : [String]], names[indexPath.section])
        
        cell.label.text = sortedObj[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "toEditVC", sender: self)
    }
    
}
