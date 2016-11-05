import UIKit
import RealmSwift
import WebKit
import FlatUIKit

class FTHRecommendViewController: UIViewController, WKNavigationDelegate, UITextFieldDelegate {
    var _webkitview:WKWebView?
    var realm: Realm?
    let defaultRedColor = UIColor(red: (252/255.0), green: (114/255.0), blue: (84/255.0), alpha: 1.0)
    var fthRefrigeratorModel = FTHRefrigeratorModel()
    var additionalFoodtextField = FUITextField()
    var bestBeforeFood : RealmFood?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "おすすめレシピを見る"
        self.view.backgroundColor = UIColor.white
        self.realm = try! Realm()
        bestBeforeFood = (self.realm?.objects(RealmFood.self).sorted(byProperty:"date").first)!
        
        let bestBeforeDateLabel = UILabel(frame: CGRect(x: 10, y: 80, width: self.view.bounds.size.width, height: 50))
        bestBeforeDateLabel.textAlignment = NSTextAlignment.left
        let labeltext: [String] = ["賞味期限間近の食品：", (bestBeforeFood?.name)!]
        bestBeforeDateLabel.text = labeltext.joined(separator: " ")
        self.view.addSubview(bestBeforeDateLabel)
        
        
        let otherFoodLabel = UILabel(frame: CGRect(x: 10, y: 130, width: 150, height: 50))
        otherFoodLabel.textAlignment = NSTextAlignment.left
        otherFoodLabel.text = "食品を追加する: "
        self.view.addSubview(otherFoodLabel)
        
        self.additionalFoodtextField = FUITextField(frame: CGRect(x: otherFoodLabel.frame.maxX, y: otherFoodLabel.frame.minY, width: self.view.bounds.size.width - otherFoodLabel.frame.maxX - 10, height: 50))
        additionalFoodtextField.delegate = self
        self.additionalFoodtextField.textFieldColor = UIColor.clear
        self.additionalFoodtextField.layer.borderColor = UIColor.gray.cgColor
        self.additionalFoodtextField.layer.borderWidth = 1.0
        self.view.addSubview(additionalFoodtextField)
        
        let trybutton = FUIButton()
        trybutton.frame = CGRectMake(30, otherFoodLabel.frame.maxY + 10, self.view.frame.size.width - 60, 50)
        trybutton.buttonColor = defaultRedColor
        trybutton.shadowColor = UIColor.red
        trybutton.shadowHeight = 3.0
        trybutton.cornerRadius = 6.0
        
        trybutton.titleLabel?.textColor = UIColor.black
        
        trybutton.setTitle("追加する", for: UIControlState())
        trybutton.addTarget(self, action: #selector(didTapAddSearchButton), for:.touchUpInside)
        self.view.addSubview(trybutton)
        
        //using WKWebview to show the recomendation recipies though Rakuten recipi.
        _webkitview?.navigationDelegate = self
        
        self._webkitview = WKWebView(frame:CGRectMake(10, trybutton.frame.maxY + 10, self.view.bounds.size.width - 10, self.view.bounds.size.height))
        
        self.showWebViewWithKeyWords(keywords: [(self.bestBeforeFood?.name)!])
    }
    
    func didTapAddSearchButton(sender: UIButton){
        var keywords = [self.bestBeforeFood?.name]
        if (self.additionalFoodtextField.text != nil){
            keywords.append(self.additionalFoodtextField.text)
        }
        self.showWebViewWithKeyWords(keywords: keywords as! [String])
    }
    
    func showWebViewWithKeyWords(keywords:[String]){
        var urlstring = "http://recipe.rakuten.co.jp/search/"
        for keyword in keywords{
            urlstring += keyword
        }
        let url = NSURL(string:urlstring.addingPercentEncoding(withAllowedCharacters:NSCharacterSet.urlQueryAllowed)!)
        let req = NSURLRequest(url:url as! URL)
        self._webkitview!.load(req as URLRequest)
        self.view.addSubview(_webkitview!)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func didTapBackButton(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.endEditing(true)
        return false
    }
    
    func CGRectMake(_ x: CGFloat, _ y: CGFloat, _ width: CGFloat, _ height: CGFloat) -> CGRect {
        return CGRect(x: x, y: y, width: width, height: height)
    }
    
}
