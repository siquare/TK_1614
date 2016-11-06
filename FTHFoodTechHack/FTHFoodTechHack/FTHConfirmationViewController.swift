import UIKit
import SwiftyJSON
import FlatUIKit
import Alamofire
import RealmSwift

class FTHConfirmationViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate {
    let defaultRedColor =  UIColor(red: (252/255.0), green: (114/255.0), blue: (84/255.0), alpha: 1.0)
    var realm: Realm?
    var tableView : UITableView = UITableView()
    var tableViewData : [(name:String, date:NSDate, price:Int)]
    
    //var myScrollView: UIScrollView!
    var table : [ String : (Int, NSDate, Int) ]
    var myDatePicker : UIDatePicker
    var selectedCell : FTHConfrimationTableCell
    var toolBar : UIToolbar
    
    @available(iOS 2.0, *)
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "concell", for: indexPath as IndexPath) as! FTHConfrimationTableCell
        //set cell's delegate
        cell.nameTextField?.delegate = self
        cell.priceTextField?.delegate = self
        cell.dateTextField?.delegate = self
        
        //add datepicker and accessoryView
        cell.dateTextField?.inputAccessoryView = self.toolBar
        cell.dateTextField?.inputView = self.myDatePicker
        
        //set initial value
        let dataSource = self.tableViewData[indexPath.row]
        cell.nameTextField?.text = dataSource.name
        cell.dateTextField?.text =  self.stringFromDate(date: dataSource.date as NSDate, format: "yyyy-MM-dd")
        cell.priceTextField?.text = String(dataSource.price)
        
        return cell
    }

    @available(iOS 2.0, *)
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
         return self.table.count
    }
    
    init(table: [ String : (Int, NSDate, Int)]) {
        self.table = table
        
        let myDatePicker = UIDatePicker()
        self.myDatePicker = myDatePicker
        let toolBar = UIToolbar()
        self.toolBar = toolBar
        let selectedCell = FTHConfrimationTableCell()
        self.selectedCell = selectedCell
        self.tableViewData = []
        
        super.init(nibName:nil, bundle: nil)
        
        self.myDatePicker.addTarget(self, action: #selector(changedDateEvent), for: UIControlEvents.valueChanged)
        self.myDatePicker.datePickerMode = UIDatePickerMode.date
        
        toolBar.frame = CGRect(x:0, y:self.view.frame.size.height/6, width:self.view.frame.size.width, height:40.0)
        toolBar.layer.position = CGPoint(x: self.view.frame.size.width/2, y: self.view.frame.size.height-20.0)
        toolBar.barStyle = .blackTranslucent
        toolBar.tintColor = UIColor.white
        toolBar.backgroundColor = UIColor.black
        
        let toolBarBtn = UIBarButtonItem(title: "完了", style: .bordered, target: self, action: #selector(didTapKanryoButton))//need to implement kanryo
        
        toolBarBtn.tag = 1
        toolBar.items = [toolBarBtn]
        
        tableView.separatorColor = UIColor.clear
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        let conLabel = UILabel(frame: CGRect(x: 0, y: 50, width: self.view.bounds.size.width , height: 50))
        conLabel.textAlignment = NSTextAlignment.center
        conLabel.text = "食材の確認をしてください。"
        conLabel.backgroundColor = UIColor.white
        self.view.addSubview(conLabel)
        self.realm = try! Realm()
        super.viewDidLoad()
        self.tableView.allowsSelection = false
        self.tableView.frame = CGRect(x:0, y:100, width:self.view.frame.size.width, height:self.view.frame.size.height)
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.register(FTHConfrimationTableCell.self, forCellReuseIdentifier: "concell")
        self.view.addSubview(self.tableView)

        for (key, val) in self.table {
            self.tableViewData.append((name:key, date:val.1, price:val.0))
        }
        
        func numberOfSectionsInTableView(tableView: UITableView) -> Int {
            return 1
        }
        
        func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return self.table.count
        }
        
        func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
            let cell = tableView.dequeueReusableCell(withIdentifier: "concell", for: indexPath as IndexPath) as! FTHConfrimationTableCell
            //set cell's delegate
            cell.nameTextField?.delegate = self
            cell.priceTextField?.delegate = self
            cell.dateTextField?.delegate = self
            
            //add datepicker and accessoryView
            cell.dateTextField?.inputAccessoryView = self.toolBar
            cell.dateTextField?.inputView = self.myDatePicker
            
            //set initial value 
            let dataSource = self.tableViewData[indexPath.row]
            cell.nameTextField?.text = dataSource.name
            cell.dateTextField?.text =  self.stringFromDate(date: dataSource.date as NSDate, format: "yyyy-MM-dd")
            cell.priceTextField?.text = String(dataSource.price)
            
            return cell
        }
        
        func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        }
        
        let trybutton = FUIButton()
        trybutton.frame = CGRect(x:self.view.bounds.size.width/2 - 50, y:self.view.bounds.maxY - 100, width:100, height:50)
        trybutton.buttonColor =  defaultRedColor
        trybutton.shadowColor = UIColor.red
        trybutton.shadowHeight = 3.0
        trybutton.cornerRadius = 6.0
        
        trybutton.titleLabel?.textColor = UIColor.black
        
        trybutton.setTitle("認証する", for: UIControlState())
        trybutton.addTarget(self, action: #selector(didTapConButton), for:.touchUpInside)
        self.view.addSubview(trybutton)
    }
    
    func didTapConButton (_ sender: UIButton){
        var records : [  String : (NSDate, Int, Int) ] = [:]
        let cells = self.tableView.visibleCells as! Array<FTHConfrimationTableCell>
        
        for cell in cells {
            records[(cell.nameTextField?.text!)!] = (dateFromString(string:(cell.dateTextField?.text)!, format: "yyyy-MM-dd"),0,0)
        }
        updateRemoteDatabase(records)
        self.navigationController?.popViewController(animated: true)
        self.dismiss(animated: true, completion: nil)
    }
    
    //TODO(AkariAsai):cell上でのCustomizedTextFieldへの置き換えが終わったら削除
    func changedDateEvent(sender:AnyObject?, textField:UITextField){
        let dateSelecter: UIDatePicker = sender as! UIDatePicker
        textField.text = self.stringFromDate(date: dateSelecter.date as NSDate, format: "yyyy-MM-dd")
    }
    
    
    func updateLocalDatabase(_ records : [ String : (Int, NSDate) ]) {
        records.forEach { key, val in
            try! realm?.write {
                let foodStock = RealmFood()
                foodStock.name = key
                foodStock.id = RealmOptional<Int>(val.0)
                foodStock.date = val.1
                realm?.add(foodStock)
            }
        }
    }
    // 二番目の仮IDの情報と三番目のpriceの情報は捨てる
    func updateRemoteDatabase(_ records : [ String : (NSDate, Int, Int) ]) {
        let accessToken = getAccessToken()
        
        let user_items = records.map { key, val in
            [ "item_id" : "", "item_name" : key, "expire_date" : String(describing: val.0) ]
        }
        
        Alamofire.request("https://app.uthackers-app.tk/item/add", method: .post, parameters: [
            "user_item": user_items
            ], encoding: JSONEncoding.default, headers: [ "x-access-token" : accessToken ]).responseJSON { response in
                print("Status Code: \(response.result.isSuccess)")
                
                guard let object = response.result.value else { return }
                let json = JSON(object)
                
                var records : [ String : (Int, NSDate) ] = [:]
                
                json["user_item"].arrayValue.forEach {
                    let name = $0["user_item"].string!
                    let date = self.dateFromString(string: $0["expire_date"].string!, format: "YYYY-MM-DD")
                    let user_item_id = Int($0["user_item_id"].string!)!
                    
                    records[name] = (user_item_id, date)
                }
                self.updateLocalDatabase(records)
        }
    }
    
     //TODO(AkariAsai):cell上でのCustomizedTextFieldへの置き換えが終わったら削除
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.endEditing(true)
        return false
    }
    
    func getAccessToken() -> String {
        let ud = UserDefaults.standard
        return ud.object(forKey: "x-access-token") as! String
    }
    
     //TODO(AkariAsai):cell上でのCustomizedTextFieldへの置き換えが終わったら削除
    func stringFromDate(date: NSDate, format: String) -> String {
        let formatter: DateFormatter = DateFormatter()
        formatter.dateFormat = format
        return formatter.string(from: date as Date)
    }
    
    func dateFromString(string: String, format: String) -> NSDate {
        let formatter: DateFormatter = DateFormatter()
        formatter.dateFormat = format
        return formatter.date(from: string)! as NSDate
    }
    
    func didTapKanryoButton(sender: UIBarButtonItem) {
        let selectedDateTextField = self.findFirstResponder()
        selectedDateTextField?.resignFirstResponder()
        selectedDateTextField?.text = self.stringFromDate(date: self.myDatePicker.date as NSDate, format: "yyyy年MM月dd日")
    }

    func findFirstResponder() -> UITextField?
    {
        let cells = self.tableView.visibleCells as! Array<FTHConfrimationTableCell>
        for cell in cells {
            if cell.dateTextField?.isFirstResponder == true {
                return cell.dateTextField
            }
        }
        return nil
    }
}
