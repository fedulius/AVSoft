import UIKit

class RegisterViewController: UIViewController {

    @IBOutlet weak var loginTextField: UITextField!

    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var checkPasswordTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    @IBAction func registerButton(_ sender: Any) {
        let login = loginTextField.text
        let password = passwordTextField.text
        let chek = checkPasswordTextField.text
        
        if (login != nil && password != nil && chek != nil) {
            if password == chek {
                Persistance.shared.userLogin = login
                Persistance.shared.userPassword = password
                dismiss(animated: true, completion: nil)
            }
        }
    }
}
