import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var loginTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var progressBar: UIProgressView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loginTextField.placeholder = "Enter your login"
        passwordTextField.placeholder = "Enter your password"
    }
    
    @IBAction func enterButton(_ sender: Any) {
        let login = loginTextField.text ?? ""
        let password = passwordTextField.text ?? ""
        if login == Persistance.shared.userLogin && password == Persistance.shared.userPassword {
            UIView.animate(withDuration: 1.6) {
                self.progressBar.progress = 1.0
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(5)) {
                self.performSegue(withIdentifier: "toMainScreen", sender: self)
            }
        }
        else if login == "" || password == "" {
            let str = "Введите логин и пароль."
            UIView.animate(withDuration: 0.6) {
                self.progressBar.progress = 1
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(5)) {
                self.warningAlert(str)
                self.progressBar.progress = 0
            }
        }
        else {
            let str = "Вы ввели неправильный логин или пароль."
           UIView.animate(withDuration: 0.6) {
                self.progressBar.progress = 1
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(5)) {
                self.warningAlert(str)
                self.progressBar.progress = 0
            }
        }
    }
    
    func warningAlert(_ name: String) {
        let alert = UIAlertController(title: name, message: nil, preferredStyle: .alert)
        
        let okAction = UIAlertAction(title: "Хорошо", style: .cancel, handler: nil)
        
        alert.addAction(okAction)
        sleep(1)
        present(alert, animated: true, completion: nil)
    }
    
//    func isValidEmail(_ email: String) -> Bool {
//        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
//        let emailPred = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
//        return emailPred.evaluate(with: email)
//    }
//
//    func isValidPassword(_ password: String) -> Bool {
//        if password.count > 8 {
//
//        }
//        return true
//    }
}

