import UIKit

protocol CustomViewDelegate: NSObjectProtocol {
    func editButtonPressed(_ customView: UIView)
    func showButtonPressed(_ customView: UIView)
}

@IBDesignable class CustomView: UIView {
        
    weak var delegate: CustomViewDelegate?
    
    var isSetuped = false
    
    private let toolBar = UIToolbar()
    private let editButton = UIButton()
    private let viewButton = UIButton()
    private let aboutButton = UIButton()
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let w = frame.size.width
        let h = frame.size.height
        
        toolBar.frame = CGRect(x: 0, y: 0, width: w, height: h)
        
        editButton.frame = CGRect(x: 0, y: 10, width: w, height: 50)
        editButton.setTitle("Редактирование", for: .normal)
        editButton.addTarget(self, action: #selector(editMethod(_:)), for: .touchUpInside)
        
        viewButton.frame = CGRect(x: 0, y: 70, width: w, height: 50)
        viewButton.setTitle("Просмотр", for: .normal)
        viewButton.addTarget(self, action: #selector(viewMethod(_:)), for: .touchUpInside)
        
        
        aboutButton.frame = CGRect(x: 0, y: 130, width: w, height: 50)
        aboutButton.setTitle("О программе", for: .normal)
        
        if isSetuped { return }
        isSetuped = true
        
        for v in [editButton, aboutButton, viewButton] {
            v.setTitleColor(.systemBlue, for: .normal)
            v.setTitleColor(.lightGray, for: .highlighted)
            toolBar.addSubview(v)
        }
        
        self.addSubview(toolBar)
    }
    
    @objc func editMethod(_ sender: UIButton) {
        delegate?.editButtonPressed(self)
    }
    
    @objc func viewMethod(_ sender: UIButton) {
        delegate?.showButtonPressed(self)
    }

}
