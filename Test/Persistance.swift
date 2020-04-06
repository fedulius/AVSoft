import Foundation

class Persistance {
    static let shared = Persistance()
    
    private let keyForLogin = "Persistance.keyForLogin"
    private let keyForPassword = "Persistance.keyForPassword"
    
    var userLogin: String? {
        set { UserDefaults.standard.set(newValue, forKey: keyForLogin) }
        get { return UserDefaults.standard.string(forKey: keyForLogin)}
    }
    
    var userPassword: String? {
        set { UserDefaults.standard.set(newValue, forKey: keyForPassword) }
        get { return UserDefaults.standard.string(forKey: keyForPassword)}
    }
}
