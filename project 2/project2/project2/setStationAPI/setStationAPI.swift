//
//  setStationAPI.swift
//  project2
//
//  Created by mmslab406-mini2018-2 on 2022/8/26.
//

import Foundation

var stationAPIData: [Station]?

let stationURL = "https://tdx.transportdata.tw/api/basic/v2/Rail/THSR/Station?%24top=30&%24format=JSON"

func getStationAPI(access_token: String) {
    if let url: URL = URL(string: stationURL) {
        var request = URLRequest(url: url)
        request.httpMethod = "GET"

        request.setValue(access_token, forHTTPHeaderField: "Authorization")
        request.setValue("application/json", forHTTPHeaderField: "accept")
        
        dump(request)
        let task = URLSession.shared.dataTask(with: request){ data, response, error in
            if let error = error {
                print("\nAPI未成功上傳, 原因是：\(error.localizedDescription)\n")
                return
            } else if let data = data {
                print("\n成功接收車站API資料\n")
                DispatchQueue.main.async {
                    do {
                        let data = try JSONDecoder().decode([Station].self, from: data)
//                            dump(data)
                        stationAPIData = data
                        
                        setAnnotation()
                    } catch {
                        print(error)
                    }
                }
            }
        }
        task.resume()
    }
}
