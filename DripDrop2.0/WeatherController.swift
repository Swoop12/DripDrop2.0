//
//  WeatherController.swift
//  DripDrop2.0
//
//  Created by DevMountain on 12/13/18.
//  Copyright © 2018 trevorAdcock. All rights reserved.
//

import Foundation

class WeatherController{
    
    static let baseUrl = URL(string: "https://api.darksky.net/forecast")
    private static let apiSecret = "8940fc22c0ed6b892125705b44e40965"
    
    static func fetchWeatherAt(latitude: Double, longitude: Double, completion: @escaping (WeatherService?) -> Void){
        
        //1) Construct the URL Request
        guard let url = baseUrl?.appendingPathComponent(apiSecret).appendingPathComponent("\(latitude),\(longitude)") else { completion(nil) ; return }
        
        var components = URLComponents(url: url, resolvingAgainstBaseURL: true)
        components?.queryItems = [URLQueryItem(name: "exclude", value: "minutely,hourly,flags")]
        guard let finalUrl = components?.url else { completion(nil) ; return }
        
        var request = URLRequest(url: finalUrl)
        request.httpMethod = "GET"
        request.httpBody = nil
        
        print(request.url?.absoluteString ?? "No URL")
        
        //2)  Call the datatask (.resume, completion())
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            if let error = error{
                print("\(error.localizedDescription) \(error) in function: \(#function)")
                completion(nil)
                return
            }
            print(response ?? "NO Response")
            guard let data = data else { completion(nil) ; return }
            
            do{
                let weatherService = try JSONDecoder().decode(WeatherService.self, from: data)
                completion(weatherService)
            }catch {
                print("There was as error in \(#function) :  \(error) \(error.localizedDescription)")
                completion(nil)
            }
        }.resume()
    }
}
