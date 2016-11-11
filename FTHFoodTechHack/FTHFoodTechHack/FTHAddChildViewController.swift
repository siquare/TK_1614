import UIKit
import RealmSwift
import FlatUIKit

class FTHAddChildViewController: UIViewController, UITextFieldDelegate, FUIAlertViewDelegate{
    let foodTextField = FTHCustoizedTextField(frame:CGRect.zero, isDate:false)
    let priceTextField = FTHCustoizedTextField(frame:CGRect.zero, isDate:false)
    var toolBar = UIToolbar()
    var dateTextField = FTHCustoizedTextField(frame:CGRect.zero, isDate:true)
    static let textFieldLeftMargin = 30
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "食材を追加する"
        self.view.backgroundColor = UIColor.white
        
        //Initialize Labels
        let foodLabel = UILabel(frame:CGRect(x: 30, y: 100, width: 80 , height: 50))
        foodLabel.textAlignment = NSTextAlignment.center
        foodLabel.text = "食材名"
        self.view.addSubview(foodLabel)
        
        let priceLabel = UILabel(frame: CGRect(x: 30, y: foodLabel.frame.maxY + 10, width: 80 , height: 50))
        priceLabel.textAlignment = NSTextAlignment.center
        priceLabel.text = "価格"
        self.view.addSubview(priceLabel)
        
        let dateLabel = UILabel(frame: CGRect(x: 30, y: priceLabel.frame.maxY + 10, width: 80 , height: 50))
        dateLabel.textAlignment = NSTextAlignment.center
        dateLabel.text = "賞味期限"
        self.view.addSubview(dateLabel)
        
        //Initialize textField for inputs
        foodTextField.frame = CGRect(x:foodLabel.frame.maxX, y:100, width:200 ,height: 50)
        foodTextField.delegate = self
        self.view.addSubview(foodTextField)
        
        priceTextField.frame = CGRect(x:foodLabel.frame.maxX,y:foodLabel.frame.maxY + 10, width:200 , height:50)
        priceTextField.delegate = self
        self.view.addSubview(priceTextField)
        
        dateTextField.frame = CGRect(x:foodLabel.frame.maxX, y:priceLabel.frame.maxY + 10, width:200 , height:50)
        dateTextField.delegate = self
        dateTextField.inputAccessoryView = toolBar
        
        //configure toolBar
        toolBar.frame = CGRect(x:0, y:self.view.frame.size.height/6, width:self.view.frame.size.width, height:40.0)
        toolBar.layer.position = CGPoint(x: self.view.frame.size.width/2, y: self.view.frame.size.height-20.0)
        toolBar.barStyle = .blackTranslucent
        toolBar.tintColor = UIColor.white
        toolBar.backgroundColor = UIColor.black
        
        let toolBarBtn = UIBarButtonItem(title: "完了", style: .bordered, target: self, action: #selector(didTapKanryoButton))
        toolBarBtn.tag = 1
        toolBar.items = [toolBarBtn]
        self.view.addSubview(dateTextField)
        
        let addbutton = FUIButton()
        addbutton.frame = CGRect(x:30, y:dateTextField.frame.maxY + 30, width:self.view.bounds.size.width - 60, height:50)
        addbutton.buttonColor =  UIColor(red: (252/255.0), green: (114/255.0), blue: (84/255.0), alpha: 1.0)
        addbutton.shadowColor = UIColor.red
        addbutton.shadowHeight = 3.0
        addbutton.cornerRadius = 6.0
        addbutton.titleLabel?.textColor = UIColor.black
        addbutton.setTitle("追加する", for: UIControlState())
        addbutton.addTarget(self, action: #selector(didTapAddButton), for:.touchUpInside)
        self.view.addSubview(addbutton)
    }

	override func didReceiveMemoryWarning() {}

    func changedDateEvent(sender:AnyObject?){
        let dateSelecter: UIDatePicker = sender as! UIDatePicker
        self.dateTextField.text = self.stringFromDate(date: dateSelecter.date as NSDate, format: "yyyy年MM月dd日")
    }

    func didTapAddButton(sender: UIButton){
        let realm = try! Realm()
		
		let name = foodTextField.text!
		let date = dateFromString(string: self.dateTextField.text!, format:"yyyy年MM月dd")
		let price = 100
		
		ServerSideDBWrapper.addItems([
			"user_item": [ [ "item_id": NSNull(), "item_name": name, "expire_date": stringFromDate(date: date, format: "yyyy-MM-dd"), "price": price ] ]
		], callback: { items in
			try! realm.write {
				items.forEach {
					realm.add($0)
				}
			}
		})
		
		let selectedTextField = self.findFirstResponder()
		selectedTextField?.resignFirstResponder()
		self.navigationController?.popViewController(animated: true)
		self.dismiss(animated: true, completion: nil)
    }
	
    func CGRectMake(_ x: CGFloat, _ y: CGFloat, _ width: CGFloat, _ height: CGFloat) -> CGRect {
        return CGRect(x: x, y: y, width: width, height: height)
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
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.endEditing(true)
        return false
    }
    
    func didTapKanryoButton(sender: UIBarButtonItem) {
        let selectedDateTextField = self.findFirstResponder()
        selectedDateTextField?.resignFirstResponder()
    }
    
    func findFirstResponder() -> UITextField?
    {
        for view in self.view.subviews{
            if view is UITextField && view.isFirstResponder == true {
                return view as? UITextField
            }
        }
        return nil
    }
}
