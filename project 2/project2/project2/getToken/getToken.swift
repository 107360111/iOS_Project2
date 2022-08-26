//
//  getToken.swift
//  project2
//
//  Created by mmslab406-mini2018-2 on 2022/8/26.
//

import Foundation

class postToken : Codable {
    var access_token: String
}

var Token: postToken?

let client_id: String = "t107360111-a7d9198a-e356-493d"  //使用者id
let client_secret: String = "a156d47f-8ec0-4bc9-b11e-9d3c691e36a1"  //使用者secret

let semaphore = DispatchSemaphore (value: 0)

var authorization = ""

func getToken() -> String {
    
    let parameters = "grant_type=client_credentials&client_id=\(client_id)&client_secret=\(client_secret)"
    
    let postData = parameters.data(using: .utf8)
    
    var request = URLRequest(url: URL(string: "https://tdx.transportdata.tw/auth/realms/TDXConnect/protocol/openid-connect/token")!, timeoutInterval: Double.infinity)
    request.addValue("application/x-www-form-urlencoded", forHTTPHeaderField: "content-type")
    
    request.httpMethod = "POST"
    
    request.httpBody = postData
    
    let task = URLSession.shared.dataTask(with: request) { data, response, error in
        guard let data = data else {
            print(String(describing: error))
            semaphore.signal()
            return
        }
        Token = try? JSONDecoder().decode(postToken.self, from: data)
        authorization = Token?.access_token ?? ""
        
        semaphore.signal()
    }
    task.resume()
    semaphore.wait()
    
    return "Bearer \(authorization)"
}
