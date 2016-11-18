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

class Regexp {
	let internalRegexp: NSRegularExpression
	let pattern: String
	
	init(_ pattern: String) {
		self.pattern = pattern
		self.internalRegexp = try! NSRegularExpression(pattern: pattern, options: NSRegularExpression.Options.caseInsensitive)
	}
	
	func isMatch(input: String) -> Bool {
		let matches = self.internalRegexp.matches(in: input, options: [], range: NSMakeRange(0, input.characters.count))
		return matches.count > 0
	}
	
	func matches(input: String) -> [String]? {
		let matches = self.internalRegexp.matches(in: input, options: [], range: NSMakeRange(0, input.characters.count))
		var results: [String] = []
		
		for i in 0 ..< matches.count {
			results.append((input as NSString).substring(with: matches[i].range) )
		}
		
		return results
	}
}

extension URL {
	func queries() -> Dictionary<String, String> {
		var dict : Dictionary<String, String> = [:]
		let pairs = self.query?.components(separatedBy: "&") ?? []
		
		for pair in pairs {
			let elements = pair.components(separatedBy: "=")
			let key = elements[0]
			let val = elements[1]
			
			dict[key] = val
		}
		
		return dict
	}
}
