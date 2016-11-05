import UIKit
import MGSwipeTableCell
import RealmSwift
import Alamofire
import BRYXBanner

class FTHSeeUIViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    var fthRefrigeratorModel = FTHRefrigeratorModel()
    var backBtn: UIBarButtonItem!
    var realm: Realm?
    let defaultRedColor = UIColor(red: (252/255.0), green: (114/255.0), blue: (84/255.0), alpha: 1.0)
    //let mySections: NSArray = ["賞味期限間近の食品", "冷蔵庫内の食品"]
    var tableViewData : [FTHFoodModel] = []
    
    fileprivate var myTableView: UITableView!
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        self.realm = try! Realm()
        for realmFood in (self.realm?.objects(RealmFood.self).sorted(byProperty: "date"))! {
            let food = FTHFoodModel(object: realmFood)
            self.tableViewData.append(food)
        }
        
        self.view.backgroundColor = UIColor.white
        // Do any additional setup after loading the view, typically from a nib.
        self.title = "冷蔵庫の中身を見る"
        self.navigationItem.leftBarButtonItem = backBtn
        
        myTableView = UITableView(frame:CGRect(x:20, y: 50, width:self.view.bounds.width - 40, height:self.view.bounds.height - 100))
        myTableView.register(UITableViewCell.self, forCellReuseIdentifier: "FoodCell")
        myTableView.dataSource = self
        myTableView.delegate = self
        myTableView.separatorColor = UIColor.clear
        
        self.view.addSubview(myTableView)
        
        //アプリ内通知
        let banner = Banner(title: tableViewData[0].name + "がもうすぐ賞味期限切れです！", subtitle:String(-1 * tableViewData[0].price) + "円", image: UIImage(named: "Icon"), backgroundColor: UIColor.red)
        banner.dismissesOnTap = true
        banner.show(duration: 3.0)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    //set secton nums
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.tableViewData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell =  MGSwipeTableCell(style: UITableViewCellStyle.subtitle, reuseIdentifier: "FoodCell")
        cell.contentView.layer.borderColor = defaultRedColor.cgColor
        cell.contentView.layer.borderWidth = 2.0
        cell.contentView.layer.cornerRadius = 5.0
        
        //賞味期限近かったら色を変える
        if self.isGettingBad(date: self.tableViewData[indexPath.row].date){
            cell.contentView.layer.backgroundColor = UIColor.yellow.cgColor
        } else {
            cell.contentView.layer.backgroundColor = UIColor.clear.cgColor
        }
        
        //initialize cell's textLabel.それぞれの項目alignmentさせるためにtextLabel使っています
        let foodModel = self.tableViewData[indexPath.row]
        let nameLabel = UILabel(frame: CGRect(x: 10, y: 0, width: 150, height:40))
        nameLabel.text = foodModel.name
        cell.addSubview(nameLabel)
        let dateLabel = UILabel(frame: CGRect(x: self.myTableView.center.x - 30, y: 0, width: 150, height:40))
        dateLabel.text = "あと" + String(self.calculateBestBeforeDate(date: foodModel.date)) + "日"
        cell.addSubview(dateLabel)
        let priceLabel = UILabel(frame: CGRect(x: self.myTableView.frame.maxX - 100, y: 0, width: 150, height:40))
        priceLabel.text = String(foodModel.price) + "円"
        cell.addSubview(priceLabel)
         
        //implemented left and right buttons to enable users to remove/send line to fams.
        cell.rightButtons = [MGSwipeButton(title: "削除する", icon: UIImage(named:"check.png"), backgroundColor: UIColor.red, callback: {
            (sender: MGSwipeTableCell!) -> Bool in
            	
            self.myTableView.deleteRows(at:[indexPath], with: .automatic)
            
            return true
        })]
        
        return cell
    }

	func deleteRemoteData(_ item : FTHFoodModel) {
		let accessToken = self.getAccessToken()
		
		Alamofire.request("https://app.uthackers-app.tk/item/delete", method: .post, parameters: [
			"user_item_id": [ item.id ]
		], encoding: JSONEncoding.default, headers: [ "x-access-token" : accessToken ]).responseJSON { response in
			print("Status Code: \(response.result.isSuccess)")
		}
	}
    
    //あと何日もつか計算
    func calculateBestBeforeDate (date:NSDate) -> Int {
        let now = NSDate()
        let span = date.timeIntervalSince(now as Date)
        return Int(span)/60/60/24
    }
    
    //3にち以内に賞味期限切れるならtrue返す。せるの背景色捜査のため
    func isGettingBad(date:NSDate) -> Bool {
        if (self.calculateBestBeforeDate(date: date) < 3){
            return true
        }
        return false
    }

	func getAccessToken() -> String {
		let ud = UserDefaults.standard
		return ud.object(forKey: "x-access-token") as! String
	}
    
}
