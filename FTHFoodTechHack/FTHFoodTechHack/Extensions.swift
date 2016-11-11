//
//  UIColor.swift
//  FTHFoodTechHack
//
//  Created by KARASAWAHIROAKI on 2016/11/12.
//  Copyright © 2016年 浅井紀子. All rights reserved.
//

import Foundation
import UIKit

extension UIColor {
	class var DefaultRed : UIColor { return UIColor(red: 252/255.0, green: 114/255.0, blue: 84/255.0, alpha: 1.0) }
}

extension NSDate {
	class func stringFromDate(date: NSDate, format: String) -> String {
		let formatter: DateFormatter = DateFormatter()
		formatter.dateFormat = format
		return formatter.string(from: date as Date)
	}
	
	class func dateFromString(string: String, format: String) -> NSDate {
		let formatter: DateFormatter = DateFormatter()
		formatter.dateFormat = format
		return formatter.date(from: string)! as NSDate
	}

}

extension NSObject {
	func tap(blk: (AnyObject) -> Void) -> Self {
		blk(self as NSObject)
		return self
	}
}
