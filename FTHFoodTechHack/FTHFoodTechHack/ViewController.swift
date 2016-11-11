import UIKit
import SwiftyJSON
import Alamofire
import FlatUIKit
import SCLAlertView


class ViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        self.createUserAccountIfNeeded()
        
        self.view.backgroundColor = UIColor.white
        self.navigationItem.hidesBackButton = true
        self.navigationItem.title = "Fresh Fridge"
        
        let seeButton = UIButton(frame: CGRect(x: 50, y: 100, width: self.view.bounds.size.width - 100, height: self.view.bounds.size.height/5))
        seeButton.backgroundColor = UIColor.red
        seeButton.setBackgroundImage(#imageLiteral(resourceName: "seecontent"), for: UIControlState.normal)
        seeButton.addTarget(self, action: #selector(didTapSeeButton), for: .touchUpInside)
        
        //adding buttonLabel
        let seeButtonLabel = UILabel(frame:CGRect(x:0, y:seeButton.frame.size.height - 50, width:seeButton.frame.width, height:50))
        seeButtonLabel.text = "冷蔵庫の中身を見る"
        seeButtonLabel.textColor = UIColor.white
        seeButtonLabel.font = UIFont.systemFont(ofSize: CGFloat(20))
        seeButtonLabel.textAlignment = NSTextAlignment.center
        seeButtonLabel.backgroundColor = UIColor.DefaultRed
        seeButton.addSubview(seeButtonLabel)
        self.view.addSubview(seeButton)
        
        let addButton = UIButton(frame: CGRect(x: 50, y: 100 + seeButton.frame.height + 30, width: self.view.bounds.size.width - 100, height: self.view.bounds.size.height/5))
        addButton.backgroundColor = UIColor.red
        addButton.setBackgroundImage(#imageLiteral(resourceName: "addcontent"), for: UIControlState.normal)
        addButton.addTarget(self, action: #selector(didTapAddButton), for: .touchUpInside)
        
        let addButtonLabel = UILabel(frame:CGRect(x:0, y:seeButton.frame.size.height - 50, width:seeButton.frame.width, height:50))
        addButtonLabel.text = "冷蔵庫に食材を追加する"
        addButtonLabel.textColor = UIColor.white
        addButtonLabel.font = UIFont.systemFont(ofSize: CGFloat(20))
        addButtonLabel.textAlignment = NSTextAlignment.center
        addButtonLabel.backgroundColor = UIColor.DefaultRed
        addButton.addSubview(addButtonLabel)
        self.view.addSubview(addButton)
        
        let recButton = UIButton(frame: CGRect(x: 50, y: addButton.frame.maxY + 30, width: self.view.bounds.size.width - 100, height: self.view.bounds.size.height/5))
        recButton.backgroundColor = UIColor.red
        recButton.setBackgroundImage(#imageLiteral(resourceName: "seerecomendation"), for: UIControlState.normal)
        recButton.addTarget(self, action: #selector(didTapRecommendButton), for: .touchUpInside)
        
        let recButtonLabel = UILabel(frame:CGRect(x:0, y:seeButton.frame.size.height - 50, width:seeButton.frame.width, height:50))
        recButtonLabel.text = "おすすめレシピを見る"
        recButtonLabel.textColor = UIColor.white
        recButtonLabel.font = UIFont.systemFont(ofSize: CGFloat(20))
        recButtonLabel.textAlignment = NSTextAlignment.center
        recButtonLabel.backgroundColor = UIColor.DefaultRed
        recButton.addSubview(recButtonLabel)
        self.view.addSubview(recButton)
        
        let addDeviceQRButton = FUIButton(frame:CGRect(x:50, y:recButton.frame.maxY + 30, width: (self.view.bounds.size.width - 100)/2, height: 50))
        addDeviceQRButton.shadowColor = UIColor.red
        addDeviceQRButton.buttonColor = UIColor(red: (252/255.0), green: (114/255.0), blue: (84/255.0), alpha: 1.0)
        addDeviceQRButton.setTitle("タブレット", for: .normal)
        addDeviceQRButton.setTitleColor(UIColor.white, for: .normal)
        addDeviceQRButton.addTarget(self, action: #selector(didTapQrButton), for: .touchUpInside)
        self.view.addSubview(addDeviceQRButton)
        
        
        
        //let alert = UIAlertController(title: "消費期限をお知らせして欲しいグループにLINE bot(@sok3197j)を招待して、下記の文字列をコピーして投稿して下さい。", message: "familytoken:\(familyToken)", preferredStyle: .alert)
        
        let addLineButton = FUIButton(frame:CGRect(x:addDeviceQRButton.frame.maxX + 10, y:recButton.frame.maxY + 30, width: (self.view.bounds.size.width - 100)/2, height: 50))
        addLineButton.buttonColor = UIColor(red: (252/255.0), green: (114/255.0), blue: (84/255.0), alpha: 1.0)
        addLineButton.setTitle("LineBot追加", for: .normal)
        addLineButton.setTitleColor(UIColor.white, for: .normal)
        addLineButton.addTarget(self, action: #selector(didTapLineButton), for: .touchUpInside)
        self.view.addSubview(addLineButton)
        
        
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

