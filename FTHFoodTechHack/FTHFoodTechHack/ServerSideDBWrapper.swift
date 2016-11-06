//
//  ServerSideDBWrapper.swift
//  FTHFoodTechHack
//
//  Created by KARASAWAHIROAKI on 2016/11/05.
//  Copyright © 2016年 浅井紀子. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

class ServerSideDBWrapper {
	static func deleteRemoteData(_ item : FTHFoodModel) {
		let accessToken = self.getAccessToken()
		
		Alamofire.request("https://app.uthackers-app.tk/item/delete", method: .post, parameters: [
			"user_item_id": [ item.id ]
		], encoding: JSONEncoding.default, headers: [ "x-access-token" : accessToken ]).responseJSON { response in
			print("Status Code: \(response.result.isSuccess)")
		}
	}
	
	/*
	parameters format is ...
	
	{ "user_item": [
		{
			"item_id": null,
			"item_name": "かぼちゃ",
			"expire_date": "2017-01-01"
		},
		{
			"item_id": 3,
			"item_name": "か↓き↑",
			"expire_date": "2017-01-01",
			"price": 100
		}
	]
	}
	*/
	static func addItems(_ parameters : Parameters, callback : @escaping ([ FTHFoodModel ]) -> Void) {
		let accessToken = self.getAccessToken()

		Alamofire.request("https://app.uthackers-app.tk/item/add", method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: [ "x-access-token" : accessToken ]).responseJSON { response in
			print("Status Code: \(response.result.isSuccess)")

			guard let object = response.result.value else { return }
			let json = JSON(object)
			var table : [ FTHFoodModel ] = []
			
			json["user_item"].arrayValue.forEach {
				let id = Int($0["user_item_id"].string!)!
				let name = $0["item_name"].string!
				let date = self.dateFromString(string: $0["expire_date"].string!, format: "yyyy-MM-dd")
				let price = $0["price"].intValue
				
				table.append(FTHFoodModel(name: name, date: date, price: price, id: id))
			}
			
			callback(table)
		}
	}
	
	static func getAccessToken() -> String {
		let ud = UserDefaults.standard
		return ud.object(forKey: "x-access-token") as! String
	}
	
	static func dateFromString(string: String, format: String) -> NSDate {
		let formatter: DateFormatter = DateFormatter()
		formatter.dateFormat = format
		return formatter.date(from: string)! as NSDate
	}
}
