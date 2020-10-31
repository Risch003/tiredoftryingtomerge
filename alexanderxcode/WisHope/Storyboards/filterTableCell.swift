
import UIKit

protocol CellTapDelegate {
    func cellClicked(didClicCellof tableCell: filterTableCell)
}

class filterTableCell: UITableViewCell {

    @IBOutlet weak var cellLabel: UILabel!
    @IBOutlet weak var cellSwitch: UISwitch!

    @IBAction func cellSwitchClicked(_ sender: Any) {
       
        let indexPath :NSIndexPath = (self.superview! as! UITableView).indexPath(for: self)! as NSIndexPath

        if !cellSwitch.isSelected{MapBottomSheetController.checkedFilters.append(indexPath.row)
        }else{
            if let index = MapBottomSheetController.checkedFilters.firstIndex(of: indexPath.row){
                MapBottomSheetController.checkedFilters.remove(at: index)
            }
        }
        cellSwitch.isSelected = !cellSwitch.isSelected
    }
        
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
   
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func prepareForReuse() {
       super.prepareForReuse()
     }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
}
