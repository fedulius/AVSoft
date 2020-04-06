import UIKit

class MainViewController: UIViewController, CreateAndWrite {
    
    @IBOutlet weak var editButton: UIButton!
    @IBOutlet weak var customView: CustomView!
    @IBOutlet weak var widthConstraint: NSLayoutConstraint!
    
    var file: String = "file2.plist"
    let panGestureRecognizer = UIPanGestureRecognizer()
    var url: URL?
    var panGestureAnturePoint: CGPoint?
    var check: NSDictionary?
    var dataSource = [DataS()]
    let text: NSDictionary = [:]
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        customView.delegate = self
        view.backgroundColor = .orange
        customView.translatesAutoresizingMaskIntoConstraints = false
        panGestureRecognizer.addTarget(self, action: #selector(panMethod(_:)))
        panGestureRecognizer.maximumNumberOfTouches = 1
        
        editButton.isHidden = true
        customView.addGestureRecognizer(panGestureRecognizer)
                
        url = getFileUrl(file)

        if getDataFromFile(url!) == nil {
            addTextIntoFile(text, url!)
            check = getDataFromFile(url!)
        } else {
            check = getDataFromFile(url!)
        }
        refactoring()
    }
    
    @IBAction func editButtonAction(_ sender: Any) {
        UIView.animate(withDuration: 0.3) {
            self.editButton.isHidden = true
            self.customView.isHidden = false
            self.customView.alpha = 1.0
            self.widthConstraint.constant = 175
        }
    }
    
    @objc func panMethod(_ gestureRecognizer: UIPanGestureRecognizer) {
        guard panGestureRecognizer === gestureRecognizer else { assert(false); return}
        
        switch gestureRecognizer.state {
        case .began:
            panGestureAnturePoint = gestureRecognizer.location(in: view)
        case .changed:
            guard panGestureAnturePoint != nil else { assert(false); return }
            let gesturePoint = gestureRecognizer.location(in: view)
            
            if widthConstraint.constant < 200 && widthConstraint.constant > 150 {
                widthConstraint.constant += gesturePoint.x - panGestureAnturePoint!.x
                self.panGestureAnturePoint = gesturePoint
            }
            else if widthConstraint.constant >= 200 {
                widthConstraint.constant = 199
            }
            else if widthConstraint.constant <= 150 && panGestureAnturePoint!.x > 50 {
                widthConstraint.constant = 151
            }
            else {
                UIView.animate(withDuration: 0.3) {
                    self.widthConstraint.constant = 0
                    self.customView.alpha = 0
                    self.editButton.isHidden = false
                }
            }
        default:
            break
        }
    }
    
    func refactoring() {
        for (key, value) in check! {
            dataSource.append(DataS(sectionName: key as? String, sectionObj: value as? [String]))
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "editSegue" {
            let vc = segue.destination as! EditViewController
            self.check = getDataFromFile(url!)
            vc.dataSource = self.dataSource
            vc.variable = self.check as! [String : [String]]
        }
        else if segue.identifier == "showSegue" {
            let vc = segue.destination as! ShowViewController
            vc.dataSourse = self.dataSource
        }
    }
}

extension MainViewController: CustomViewDelegate{
    func editButtonPressed(_ customView: UIView) {
        performSegue(withIdentifier: "editSegue", sender: self)
    }
    
    func showButtonPressed(_ customView: UIView) {
        performSegue(withIdentifier: "showSegue", sender: self)
    }
}
