import UIKit
import RealmSwift
import WebKit
import FlatUIKit

class FTHRecommendViewController: UIViewController, WKNavigationDelegate, UITextFieldDelegate {
    let defaultRedColor = UIColor(red: (252/255.0), green: (114/255.0), blue: (84/255.0), alpha: 1.0)
    var _webkitview:WKWebView?
    var realm: Realm?
    var additionalFoodtextField = FTHCustoizedTextField(frame:CGRect.zero, isDate:false)
    //一番正味消え限が近い食品がbestBeforeFoodとして選択される
    var bestBeforeFood : RealmFood?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "おすすめレシピ"
        self.view.backgroundColor = UIColor.white
        
        //賞味期限近い食品の取得
        self.realm = try! Realm()
        bestBeforeFood = (self.realm?.objects(RealmFood.self).sorted(byProperty:"date").first)!
        
        let bestBeforeDateLabel = UILabel(frame: CGRect(x: 30, y: 80, width: self.view.bounds.size.width, height: 50))
        bestBeforeDateLabel.textAlignment = NSTextAlignment.left
        bestBeforeDateLabel.text = "賞味期限間近の食品 " + (bestBeforeFood?.name)!
        self.view.addSubview(bestBeforeDateLabel)
        
        //他の食品も朝せて検索するとき
        let otherFoodLabel = UILabel(frame: CGRect(x: 30, y: 130, width: 150, height: 50))
        otherFoodLabel.textAlignment = NSTextAlignment.left
        otherFoodLabel.text = "食品を追加する"
        self.view.addSubview(otherFoodLabel)
        
        self.additionalFoodtextField.frame = CGRect(x: otherFoodLabel.frame.maxX, y: otherFoodLabel.frame.minY, width: self.view.bounds.size.width - otherFoodLabel.frame.maxX - 30, height: 40)
        additionalFoodtextField.delegate = self
        self.view.addSubview(additionalFoodtextField)
        
        let trybutton = FUIButton(frame : CGRect(x:30, y:otherFoodLabel.frame.maxY + 30, width:self.view.frame.size.width - 60, height:50))
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
        
        self._webkitview = WKWebView(frame:CGRect(x:10, y:trybutton.frame.maxY + 30, width:self.view.bounds.size.width - 10, height:self.view.bounds.size.height))
        //食品の配列を受け取ってqueryを作成、webView表示
        self.showWebViewWithKeyWords(keywords: [(self.bestBeforeFood?.name)!])
    }
    
    //This method will be callsed when users type additional food which will be searched with bestBefore food, builds new search query using two keywords.
    func didTapAddSearchButton(sender: UIButton){
        var keywords = [self.bestBeforeFood?.name]
        if (self.additionalFoodtextField.text != nil){
            keywords.append(self.additionalFoodtextField.text)
        }
        self.showWebViewWithKeyWords(keywords: keywords as! [String])
    }
    //build search query
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
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.endEditing(true)
        return false
    }
}
