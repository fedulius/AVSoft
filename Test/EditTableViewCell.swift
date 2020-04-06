import UIKit

protocol ButtonDelegate {
    func deleteSetionButton(_ view: EditTableViewCell, _ section: Int)
    func addRowButton(_ view: EditTableViewCell, _ section: Int)
}

protocol ChangeDelegate {
    func checkFunc(_ view: EditTableViewCell, _ row: Int, _ array: [String], _ name: String)
}

class EditTableViewCell: UITableViewCell {

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var sectionButton: UIButton!
    @IBOutlet weak var rowButton: UIButton!
    
    var delegate: ButtonDelegate?
    var secondDelegate: ChangeDelegate?
    
    var sectionNumber: Int!
    
    var rowNumber: Int!
    var array: [String]!
    var name: String!
        
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    
    override func prepareForReuse() {
        rowButton.isHidden = true
        nameLabel.text = nil
    }
    
    @IBAction func sectionButton(_ sender: Any) {
        delegate?.deleteSetionButton(self, sectionNumber)
    }
    
    @IBAction func rowButtonAction(_ sender: Any) {
        delegate?.addRowButton(self, sectionNumber)
        secondDelegate?.checkFunc(self, rowNumber, array, name)
    }
}
