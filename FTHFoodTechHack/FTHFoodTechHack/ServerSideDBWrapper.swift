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
	static func addItems(_ parameters : Parameters, callback : @escaping ([ RealmFood ]) -> Void) {
		let accessToken = self.getAccessToken()!

		Alamofire.request("https://app.uthackers-app.tk/item/add", method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: [ "x-access-token" : accessToken ]).responseJSON { response in
			print("Status Code: \(response.result.isSuccess)")

			guard let object = response.result.value else { return }
			let json = JSON(object)
			var table : [ RealmFood ] = []
			
			json["user_item"].arrayValue.forEach {
				let realmFood = RealmFood()
				
				realmFood.id = $0["user_item_id"].intValue
				realmFood.name = $0["item_name"].string!
				realmFood.date = self.dateFromString(string: $0["expire_date"].string!, format: "yyyy-MM-dd")
				realmFood.price = $0["price"].intValue
				
				table.append(realmFood)
			}
			
			callback(table)
		}
	}
	
	static func deleteItems(_ itemIds : [ Int ]) {
		let accessToken = self.getAccessToken()!
		
		Alamofire.request("https://app.uthackers-app.tk/item/delete", method: .post, parameters: [
			"user_item_id": itemIds
		], encoding: JSONEncoding.default, headers: [ "x-access-token" : accessToken ]).responseJSON { response in
			print("Status Code: \(response.result.isSuccess)")
		}
	}
	
	static func deleteItem(_ itemId : Int) {
		self.deleteItems([ itemId ])
	}
	
	static func getAccessToken() -> String? {
		return UserDefaults.standard.string(forKey: "x-access-token")
	}
	
	static func dateFromString(string: String, format: String) -> NSDate {
		let formatter: DateFormatter = DateFormatter()
		formatter.dateFormat = format
		return formatter.date(from: string)! as NSDate
	}
	
	static func addLineUser(_ lineUserId : String) {
		let accessToken = self.getAccessToken()!
		
		Alamofire.request("https://app.uthackers-app.tk/line/user", method: .post, parameters: [
			"line_user_id": lineUserId
		], encoding: JSONEncoding.default, headers: [ "x-access-token" : accessToken ]).responseJSON { response in
			print("Status Code: \(response.result.isSuccess)")
		}
	}
	
	static func addLineGruop(_ lineGroupId : String) {
		let accessToken = self.getAccessToken()!
		
		Alamofire.request("https://app.uthackers-app.tk/line/group", method: .post, parameters: [
			"line_group_id": lineGroupId
			], encoding: JSONEncoding.default, headers: [ "x-access-token" : accessToken ]).responseJSON { response in
				print("Status Code: \(response.result.isSuccess)")
		}
	}
}
