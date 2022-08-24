//
//  getTokenDataModel.swift
//  project2
//
//  Created by mmslab406-mini2018-2 on 2022/8/23.
//

import Foundation

class getTokenDataModel: Codable {
    let grant_type = "client_credentials"
    let client_id = "t107360111-a7d9198a-e356-493d"
    let client_secret = "a156d47f-8ec0-4bc9-b11e-9d3c691e36a1"
}

class postToken: Codable {
    var access_token: String
}
