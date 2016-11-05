import UIKit
import MGSwipeTableCell
import RealmSwift
import Alamofire

class FTHSeeUIViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    var fthRefrigeratorModel = FTHRefrigeratorModel()
    var backBtn: UIBarButtonItem!
    var realm: Realm?
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
        backBtn = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(FTHSeeUIViewController.onClick))
        self.navigationItem.leftBarButtonItem = backBtn
        
        myTableView = UITableView(frame:CGRect(x:10, y: 50, width:self.view.bounds.width - 20, height:self.view.bounds.height - 100))
        myTableView.register(UITableViewCell.self, forCellReuseIdentifier: "FoodCell")
        myTableView.dataSource = self
        myTableView.delegate = self
        
        self.view.addSubview(myTableView)
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

        cell.textLabel?.text = self.tableViewData[indexPath.row].name + "賞味期限切れ"
         
        //implemented left and right buttons to enable users to remove/send line to fams.
        cell.rightButtons = [MGSwipeButton(title: "削除する", icon: UIImage(named:"check.png"), backgroundColor: UIColor.red, callback: {
            (sender: MGSwipeTableCell!) -> Bool in
            	
            self.myTableView.deleteRows(at:[indexPath], with: .automatic)
            
            return true
        })]
        
        return cell
    }
    
    func onClick() {
        let home = ViewController()
        self.navigationController?.pushViewController(home, animated: true)
    }
	
	func deleteRemoteData(_ item : FTHFoodModel) {
		let accessToken = self.getAccessToken()
		
		Alamofire.request("https://app.uthackers-app.tk/item/delete", method: .post, parameters: [
			"user_item_id": [ item.id ]
		], encoding: JSONEncoding.default, headers: [ "x-access-token" : accessToken ]).responseJSON { response in
			print("Status Code: \(response.result.isSuccess)")
		}
	}
	
	func getAccessToken() -> String {
		let ud = UserDefaults.standard
		return ud.object(forKey: "x-access-token") as! String
	}
    
    @IBAction func didTapBackButton(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
}
