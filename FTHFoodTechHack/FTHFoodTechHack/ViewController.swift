import UIKit
import SwiftyJSON
import Alamofire
import FlatUIKit
import SCLAlertView
import RealmSwift
import BRYXBanner

class ViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
				
        self.createUserAccountIfNeeded()
        
        self.view.backgroundColor = UIColor.white
        self.navigationItem.hidesBackButton = true
        //self.navigationItem.title = "Fresh Fridge"
        
        var imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 150, height: 40))
        imageView.contentMode = .scaleAspectFit
        
        let logo = UIImage(named: "logo")
        imageView = UIImageView(image:logo)
        self.navigationItem.titleView = imageView
        
        let seeButton = UIButton(frame: CGRect(x: 0, y: (self.navigationController?.navigationBar.frame.maxY)!, width: self.view.bounds.size.width, height: self.view.bounds.size.height/4))
        seeButton.backgroundColor = UIColor.red
        seeButton.setBackgroundImage(#imageLiteral(resourceName: "seecontent"), for: UIControlState.normal)
        seeButton.addTarget(self, action: #selector(didTapSeeButton), for: .touchUpInside)
        
        //adding buttonLabel
        let seeButtonLabel = UILabel(frame:CGRect(x: 0, y: 0, width: seeButton.frame.size.width, height: seeButton.frame.size.height))
        seeButtonLabel.text = "冷蔵庫の中身を見る"
        seeButtonLabel.textColor = UIColor.white
        seeButtonLabel.font = UIFont.boldSystemFont(ofSize: CGFloat(25))
        seeButtonLabel.textAlignment = NSTextAlignment.center
        seeButtonLabel.backgroundColor = UIColor.lightGray.withAlphaComponent(0.5)
        seeButton.addSubview(seeButtonLabel)
        self.view.addSubview(seeButton)
        
        let addButton = UIButton(frame: CGRect(x: 0, y:seeButton.frame.maxY + 1, width: self.view.bounds.size.width, height: self.view.bounds.size.height/4))
        addButton.backgroundColor = UIColor.red
        addButton.setBackgroundImage(#imageLiteral(resourceName: "addcontent"), for: UIControlState.normal)
        addButton.addTarget(self, action: #selector(didTapAddButton), for: .touchUpInside)
        
        let addButtonLabel = UILabel(frame:CGRect(x:0, y:0, width: addButton.frame.size.width, height: addButton.frame.size.height))
        addButtonLabel.text = "冷蔵庫に食材を追加する"
        addButtonLabel.textColor = UIColor.white
        addButtonLabel.font = UIFont.boldSystemFont(ofSize: CGFloat(25))
        addButtonLabel.textAlignment = NSTextAlignment.center
        addButtonLabel.backgroundColor = UIColor.lightGray.withAlphaComponent(0.5)
        addButton.addSubview(addButtonLabel)
        self.view.addSubview(addButton)
        
        let recButton = UIButton(frame: CGRect(x: 0, y: addButton.frame.maxY + 1, width: self.view.bounds.size.width, height: self.view.bounds.size.height/4))
        recButton.backgroundColor = UIColor.red
        recButton.setBackgroundImage(#imageLiteral(resourceName: "seerecomendation"), for: UIControlState.normal)
        recButton.addTarget(self, action: #selector(didTapRecommendButton), for: .touchUpInside)
        
        let recButtonLabel = UILabel(frame:CGRect(x:0, y:0, width: self.view.bounds.size.width, height: self.view.bounds.size.height/4))
        recButtonLabel.text = "おすすめレシピを見る"
        recButtonLabel.textColor = UIColor.white
        recButtonLabel.font = UIFont.boldSystemFont(ofSize: CGFloat(25))
        recButtonLabel.textAlignment = NSTextAlignment.center
        recButtonLabel.backgroundColor = UIColor.lightGray.withAlphaComponent(0.5)
        recButton.addSubview(recButtonLabel)
        self.view.addSubview(recButton)
        
        let addDeviceQRButton = FUIButton(frame:CGRect(x:50, y:recButton.frame.maxY + 30, width: (self.view.bounds.size.width - 100)/2, height: 50))
        addDeviceQRButton.shadowColor = UIColor.red
        addDeviceQRButton.buttonColor = UIColor(red: (252/255.0), green: (114/255.0), blue: (84/255.0), alpha: 1.0)
        addDeviceQRButton.setTitle("タブレット", for: .normal)
        addDeviceQRButton.setTitleColor(UIColor.white, for: .normal)
        addDeviceQRButton.addTarget(self, action: #selector(didTapQrButton), for: .touchUpInside)
        self.view.addSubview(addDeviceQRButton)
        
        let addLineButton = FUIButton(frame:CGRect(x:addDeviceQRButton.frame.maxX + 10, y:recButton.frame.maxY + 30, width: (self.view.bounds.size.width - 100)/2, height: 50))
        addLineButton.buttonColor = UIColor(red: (252/255.0), green: (114/255.0), blue: (84/255.0), alpha: 1.0)
        addLineButton.setTitle("LineBot追加", for: .normal)
        addLineButton.setTitleColor(UIColor.white, for: .normal)
        addLineButton.addTarget(self, action: #selector(didTapLineButton), for: .touchUpInside)
        self.view.addSubview(addLineButton)
        
        //set alertView
        /*
        let realm = try! Realm()
        var data : [ RealmFood ] = []
        data = realm.objects(RealmFood.self).sorted(byProperty: "date").filter { $0.name.characters.count > 0 }
        
        let banner = Banner(title: data[0].name + "がもうすぐ賞味期限切れです！", subtitle:String(-1 * data[0].price) + "円", image: UIImage(named: "Icon"), backgroundColor: UIColor.red)
        banner.dismissesOnTap = true
        banner.show(duration: 3.0)
 */
    }
    
    func didTapSeeButton(_ sender:UIButton!){
        let seeViewController = FTHSeeUIViewController()
        self.navigationController?.pushViewController(seeViewController, animated: true)
    }
    
    func didTapAddButton(_ sender: UIButton) {
        let addViewController = FTHAddViewController()
        self.navigationController?.pushViewController(addViewController, animated: true)
    }
    
    func didTapQrButton(_ sender: UIButton){
        let addQRViewController = FTHRegisterDeviceViewController()
        self.navigationController?.pushViewController(addQRViewController, animated: true)
        
    }
    
    func didTapLineButton(_ dsender:UIButton){
        let ud = UserDefaults.standard
        let familyToken = ud.object(forKey: "family-token") as! String
        SCLAlertView().showInfo("ラインと連携", subTitle: "消費期限をお知らせして欲しいグループにLINE bot(@sok3197j)を招待して、下記の文字列をコピーして投稿して下さい。" + "familytoken:\(familyToken)")
    }
    func didTapRecommendButton(_ sender: UIButton) {
        let recViewController = FTHRecommendViewController()
        self.navigationController?.pushViewController(recViewController, animated: true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func createUserAccountIfNeeded() {
        let ud = UserDefaults.standard
        
        if (ud.string(forKey: "x-access-token") != nil) { return }
        
        Alamofire.request("https://app.uthackers-app.tk/user/add", method: .post, parameters: [:], encoding: JSONEncoding.default).responseJSON { response in
            guard let object = response.result.value else { return }
            let json = JSON(object)
            
            ud.set(json["user"]["access_token"].string!, forKey: "x-access-token")
            ud.set(json["family"]["token"].string!, forKey: "family-token")
        }
    }
    
    func showFamilyTokenDialog() {
        let ud = UserDefaults.standard
        let familyToken = ud.object(forKey: "family-token") as! String
        
        let alert = UIAlertController(title: "消費期限をお知らせして欲しいグループにLINE bot(@sok3197j)を招待して、下記の文字列をコピーして投稿して下さい。", message: "familytoken:\(familyToken)", preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { _ in
            self.dismiss(animated: true, completion: nil)
        }))
        
        self.present(alert, animated: true, completion: nil)
    }
}

