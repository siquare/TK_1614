import UIKit
import MGSwipeTableCell
import RealmSwift

class FTHSeeUIViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    //var fthRefrigeratorModel = FTHRefrigeratorModel()
    var backBtn: UIBarButtonItem!
    //let mySections: NSArray = ["賞味期限間近の食品", "冷蔵庫内の食品"]
    var tableViewData : [(name:String, date:NSDate, price:Int)] = []
    
    fileprivate var myTableView: UITableView!
    
    override func viewDidLoad() {
        
        let realm = try! Realm()
        for food in realm.objects(RealmFood.self).sorted(byProperty: "date") {
            self.tableViewData.append((name:food.name, date:food.date, price:food.price))
        }
        
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
            
            //crashes when multiple objects are deleted at the same time. need to be fized before demo. 
            /*
            if (indexPath as NSIndexPath).section == 0 {
                self.fthRefrigeratorModel.expiringFoodStocks.remove(at:indexPath.row)
            } else {
                self.fthRefrigeratorModel.normalFoodStocks.remove(at: indexPath.row)
                
            }
            self.myTableView.deleteRows(at:[indexPath], with: .automatic)
 */
            return true
        })]
        
        cell.leftButtons = [MGSwipeButton(title: "LINEに送る", icon: UIImage(named:"fav.png"), backgroundColor: UIColor.green, callback: {
            (sender: MGSwipeTableCell!) -> Bool in
            /*TODO(totem):lineに伝送するやつお願いします。商品名はcell.textLabel?.textで情報が取れます。
             i.e.             
             print("%s", cell.textLabel?.text) ->"ほうれん草"
             */
            return true
            })]
        cell.leftSwipeSettings.transition = MGSwipeTransition.rotate3D
        return cell
    }
    
    func onClick() {
        let home = ViewController()
        self.navigationController?.pushViewController(home, animated: true)
    }
    
    
    @IBAction func didTapBackButton(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
}
