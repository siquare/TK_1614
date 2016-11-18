import UIKit
import MGSwipeTableCell
import RealmSwift
import Alamofire
import BRYXBanner

class FTHSeeUIViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
	
	var backBtn: UIBarButtonItem!
	fileprivate var myTableView: UITableView!
	
	var realm: Realm?
    var tableViewData : [ RealmFood ] = []
	
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.realm = try! Realm()
		
		self.tableViewData = self.realm!.objects(RealmFood.self).sorted(byProperty: "date").filter { $0.name.characters.count > 0 }
			
        self.view.backgroundColor = UIColor.white
        self.title = "冷蔵庫の中身を見る"
        self.navigationItem.leftBarButtonItem = backBtn
        
        myTableView = UITableView(frame: CGRect(x:20, y: 50, width:self.view.bounds.width - 40, height:self.view.bounds.height - 100))
        myTableView.register(UITableViewCell.self, forCellReuseIdentifier: "FoodCell")
        myTableView.dataSource = self
        myTableView.delegate = self
        myTableView.separatorColor = UIColor.clear
        
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
        let cell =  MGSwipeTableCell(style: .subtitle, reuseIdentifier: "FoodCell")
		
        cell.contentView.layer.borderColor = UIColor.DefaultRed.cgColor
        cell.contentView.layer.borderWidth = 2.0
        cell.contentView.layer.cornerRadius = 5.0
        
		cell.contentView.layer.backgroundColor =
			(self.isGettingBad(date: self.tableViewData[indexPath.row].date) ? UIColor.yellow : UIColor.clear).cgColor
		
        // initialize cell's textLabel.それぞれの項目alignmentさせるためにtextLabel使っています
        let foodModel = self.tableViewData[indexPath.row]
        let nameLabel = UILabel(frame: CGRect(x: 10, y: 0, width: 150, height:40))
        nameLabel.text = foodModel.name
        cell.contentView.addSubview(nameLabel)

		let dateLabel = UILabel(frame: CGRect(x: self.myTableView.center.x - 30, y: 0, width: 150, height:40))
        dateLabel.text = "あと" + String(self.calculateBestBeforeDate(date: foodModel.date)) + "日"
        cell.contentView.addSubview(dateLabel)
		
		let priceLabel = UILabel(frame: CGRect(x: self.myTableView.frame.maxX - 100, y: 0, width: 150, height:40))
        priceLabel.text = String(foodModel.price) + "円"
        cell.contentView.addSubview(priceLabel)
		
        cell.rightButtons = [ MGSwipeButton(title: "削除する", icon: UIImage(named: "check.png"), backgroundColor: UIColor.red, callback: {
            (sender: MGSwipeTableCell!) -> Bool in
			
			ServerSideDBWrapper.deleteItem(self.tableViewData[indexPath.row].id)

			try! self.realm?.write {
				self.realm?.delete(self.tableViewData[indexPath.row])
			}
			
			self.tableViewData.remove(at: indexPath.row)
			self.myTableView.deleteRows(at: [indexPath], with: .automatic)

            return true
        })]
        
        return cell
    }
	
    @IBAction func didTapBackButton(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
	
    // 現在の日付と与えられた引数のdateの差を日数で返す
    func calculateBestBeforeDate(date: NSDate) -> Int {
		return Int(date.timeIntervalSince(NSDate() as Date)) / 60 / 60 / 24
    }
    
    func isGettingBad(date:NSDate) -> Bool {
		return self.calculateBestBeforeDate(date: date) < 3
    }
}
