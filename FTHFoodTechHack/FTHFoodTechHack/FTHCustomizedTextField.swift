import UIKit
import FlatUIKit

class FTHCustoizedTextField: FUITextField {
    let defaultRedColor = UIColor(red: (252/255.0), green: (114/255.0), blue: (84/255.0), alpha: 1.0)
    
    init(frame: CGRect, isDate: Bool) {
        super.init(frame: frame)
        self.textFieldColor = UIColor.clear
        self.backgroundColor = UIColor.white
        self.borderColor = defaultRedColor
        self.borderWidth = 2.0
        self.cornerRadius = 3.0
        self.layer.cornerRadius = 3.0
        self.layer.borderColor = UIColor.gray.cgColor
        self.layer.borderWidth = 1.0
        
        if (isDate == true){
            let myDatePicker = UIDatePicker()
            myDatePicker.addTarget(self, action: #selector(changedDateEvent), for: UIControlEvents.valueChanged)
            myDatePicker.datePickerMode = UIDatePickerMode.date
            self.inputView = myDatePicker
        }
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func changedDateEvent(sender:AnyObject?){
        let dateSelecter: UIDatePicker = sender as! UIDatePicker
        self.text = self.stringFromDate(date: dateSelecter.date as NSDate, format: "yyyy年MM月dd日")
    }
    
    func stringFromDate(date: NSDate, format: String) -> String {
        let formatter: DateFormatter = DateFormatter()
        formatter.dateFormat = format
        return formatter.string(from: date as Date)
    }
}
