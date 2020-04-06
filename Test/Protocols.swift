import Foundation

protocol CreateAndWrite {
    func createWriteAndGetUrl(_ file: String,_ text: NSDictionary) -> URL?
    func getDataFromFile(_ file: URL) -> NSDictionary?
    func addTextIntoFile(_ content: NSDictionary, _ url: URL)
    func getFileUrl(_ file: String) -> URL?
    func updateValue(_ variable: [String:[String]])
    func refactoring(_ stru: inout [DataS], _ variable: [String:[String]])
}

protocol WorkWithDictionary {
    func inArrayAndSorted(_ dict: [String:[String]]) -> [String]
    func sortNames(_ variable: [String:[String?]]) -> [String]
    func sortObj(_ variable: [String:[String]], _ check: String) -> [String]
}

extension CreateAndWrite {
    
    func createWriteAndGetUrl(_ file: String, _ text: NSDictionary) -> URL? {
        if let dir = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first {
            let fileURL = dir.appendingPathComponent(file)
            text.write(to: fileURL, atomically: true)
            return fileURL
        }
        return nil
    }
    
    func getDataFromFile(_ file: URL) -> NSDictionary? {
        let text = NSDictionary(contentsOf: file)
        return text ?? nil
    }

    func addTextIntoFile(_ content: NSDictionary, _ url :URL) {
        content.write(to: url, atomically: true)
    }
    
    func getFileUrl(_ file: String) -> URL? {
        if let dir = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first {
            let url = dir.appendingPathComponent(file)
            return url
        }
        return nil
    }
    
    func updateValue(_ variable: [String:[String]]) {
        let url = getFileUrl("file2.plist")
        addTextIntoFile(variable as NSDictionary, url!)
    }
    
    func refactoring(_ stru: inout [DataS], _ variable: [String:[String]]) {
        stru.removeAll()
        for (key, value) in variable {
            stru.append(DataS(sectionName: key, sectionObj: value))
        }
    }
}

extension WorkWithDictionary {
    func inArrayAndSorted(_ dict: [String:[String]]) -> [String] {
        var keyArray: [String] = []
        for (key, _) in dict {
            keyArray.append(key)
        }
        let sorted = keyArray.sorted { $0 < $1 }
        return sorted
    }
    
    func sortNames(_ variable: [String:[String?]]) -> [String] {
        var array: [String] = []
        array = [String](variable.keys)
        array = array.sorted(by: < )
        return array
    }
    
    func sortObj(_ variable: [String:[String]], _ check: String) -> [String] {
        var array: [String] = []
        array = variable[check]!
        array = array.sorted(by: <)
        return array
    }
}
