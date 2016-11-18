import UIKit
import FlatUIKit

class FTHConfrimationTableCell: UITableViewCell {
    var nameTextField = FTHCustoizedTextField(frame:CGRect.zero, isDate:false)
    var dateTextField = FTHCustoizedTextField(frame:CGRect.zero, isDate:true)
    var priceTextField =  FTHCustoizedTextField(frame:CGRect.zero, isDate:false)
	
    override init(style:UITableViewCellStyle, reuseIdentifier reusedIdentifier:String!){
        let reuseIdentifier = reusedIdentifier
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        
        //TODO(AkariAsai):CustomizedTextFieldクラスに置き換え
        self.layer.backgroundColor = UIColor.DefaultRed.cgColor
        nameTextField.frame = CGRect(x:10, y:frame.minY + 5, width:frame.size.width/4, height:frame.size.height - 10)
        addSubview(nameTextField)
        
        dateTextField.frame = CGRect(x:(self.nameTextField.frame.maxX) + 30, y:frame.minY + 5, width:frame.size.width/2 - 20, height:frame.size.height - 10)
        self.addSubview(dateTextField)

        priceTextField.frame = CGRect(x:(self.dateTextField.frame.maxX) + 30, y:frame.minY + 5, width:frame.size.width/4, height:frame.size.height - 10)
        self.addSubview(priceTextField)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func changedDateEvent(sender:AnyObject?, textField:FUITextField){
        let dateSelecter: UIDatePicker = sender as! UIDatePicker
        textField.text = self.stringFromDate(date: dateSelecter.date as NSDate, format: "yyyy-MM-dd")
    }
    
    func dateFromString(string: String, format: String) -> NSDate {
        let formatter: DateFormatter = DateFormatter()
        formatter.dateFormat = format
        return formatter.date(from: string)! as NSDate
    }
    
    func stringFromDate(date: NSDate, format: String) -> String {
        let formatter: DateFormatter = DateFormatter()
        formatter.dateFormat = format
        return formatter.string(from: date as Date)
    }
    
}
