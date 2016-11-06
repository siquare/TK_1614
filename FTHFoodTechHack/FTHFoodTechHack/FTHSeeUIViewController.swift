import UIKit
import MGSwipeTableCell
import Alamofire

class FTHSeeUIViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    var fthRefrigeratorModel = FTHRefrigeratorModel()
    var backBtn: UIBarButtonItem!
    let mySections: NSArray = ["賞味期限間近の食品", "冷蔵庫内の食品"]
    fileprivate var myTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
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
        return mySections.count
    }
    //set sectiontitle
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return mySections[section] as? String
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return fthRefrigeratorModel.expiringFoodStocks.count
        } else if section == 1 {
            return fthRefrigeratorModel.normalFoodStocks.count
        } else {
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell =  MGSwipeTableCell(style: UITableViewCellStyle.subtitle, reuseIdentifier: "FoodCell")

        if (indexPath as NSIndexPath).section == 0 {
            cell.textLabel?.text = fthRefrigeratorModel.expiringFoodStocks[(indexPath as NSIndexPath).row].name + " Expiration date : "+String(describing: fthRefrigeratorModel.expiringFoodStocks[(indexPath as NSIndexPath).row].date)
        } else if (indexPath as NSIndexPath).section == 1 {
            cell.textLabel?.text = fthRefrigeratorModel.normalFoodStocks[(indexPath as NSIndexPath).row].name + " Expiration date : "+String(describing: fthRefrigeratorModel.normalFoodStocks[(indexPath as NSIndexPath).row].date)
        }
        
        //implemented left and right buttons to enable users to remove/send line to fams.
        cell.rightButtons = [MGSwipeButton(title: "削除する", icon: UIImage(named:"check.png"), backgroundColor: UIColor.red, callback: {
            (sender: MGSwipeTableCell!) -> Bool in
			
			if (indexPath as NSIndexPath).section == 0 {
				self.deleteRemoteData(self.fthRefrigeratorModel.expiringFoodStocks[indexPath.row])
			} else {
				self.deleteRemoteData(self.fthRefrigeratorModel.normalFoodStocks[indexPath.row])
			}

            //crashes when multiple objects are deleted at the same time. need to be fized before demo.
            if (indexPath as NSIndexPath).section == 0 {
                self.fthRefrigeratorModel.expiringFoodStocks.remove(at:indexPath.row)
            } else {
                self.fthRefrigeratorModel.normalFoodStocks.remove(at: indexPath.row)
            }
			
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
	    
    @IBAction func didTapBackButton(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
}
