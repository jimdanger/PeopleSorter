//
//  PeopleApiInterface.swift
//  PeopleSorter
//
//  Created by Jim Wilson on 6/28/17.
//  Copyright © 2017 Jim Danger, LLC. All rights reserved.
//
import Foundation

class PeopleApiInterface {
  
    static let instance = PeopleApiInterface()

    func fetch (endpoint: String, completion: @escaping (_ people: [Person]) -> Void) {
    
        guard let url = NSURL(string: endpoint) else {
            print("Error: cannot create URL")
            return
        }
        
        let urlRequest = NSURLRequest(url: url as URL)
        let config = URLSessionConfiguration.default
        let session = URLSession(configuration: config)
        
        let task = session.dataTask(with: urlRequest as URLRequest, completionHandler: { (data, response, error) in
            
            guard error == nil else {
                return
            }
            
            guard let unwrappeddata = data else {
                return
            }
            
            do {
                var people: [Person] = []
                
                let dictArray: [[String:Any?]] = try JSONSerialization.jsonObject(with: unwrappeddata, options: .allowFragments) as! [[String:Any?]]
                
                for each in dictArray {
                    people.append(Person(jsonItem: each))
                }
                completion(people)
            } catch let error {
                print(error.localizedDescription)
            }
            
        })
        task.resume()
    }
}
