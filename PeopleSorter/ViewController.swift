//
//  ViewController.swift
//  PeopleSorter
//
//  Created by Jim Wilson on 6/28/17.
//  Copyright © 2017 Jim Danger, LLC. All rights reserved.
//

import Cocoa

class ViewController: NSViewController {

    let baseUrl: String = "http://52.14.36.184/people"
    var pageParam = "?_page="
    static var limit: Int = 20000    //        <--- Adjust this value
    var limitParam = "&_limit=\(limit)"
    
    var runningCountOfYoungAndOld = 0
    var stateBucketDict = Dictionary<String, Int>()
    var statesWithNonEmptyBuckets: [String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        switch 1 { /// Toggle: 1, 2, or 3 to pick which function to see run.
        case 1:
            countYoungAndOld(page: 1)
            break
        case 1:
            countRecordsByStateInBuckets(page: 1)
            break
        default:
            returnMatchingPeople(page: 1, state: "Georgia", age: 31)
        }
    }

    override var representedObject: Any? {
        didSet {
            
        }
    }

    /// Count the number of records where the age is not between 18 and 65 (inclusive).
    func countYoungAndOld(page: Int) {
                
        PeopleApiInterface.instance.fetch(endpoint: makeUrl(page: page)) { (people) in

            if !people.isEmpty {
                for person in people {
                    if person.age <= 18 || person.age >= 65 {
                        self.runningCountOfYoungAndOld += 1
                    }
                }
                print("runningCountOfYoungAndOld: \(self.runningCountOfYoungAndOld)")
                self.countYoungAndOld(page: page + 1)
            } else {
                print("final count: \(self.runningCountOfYoungAndOld)") // 103529
            }
        }
    }
    
    // Count the number of records by state in bucketed age groups of 18-25, 26-41, and 41-65.
    func countRecordsByStateInBuckets(page: Int) {
     
        PeopleApiInterface.instance.fetch(endpoint: makeUrl(page: page)) { (people) in

            if !people.isEmpty {
                
                for person in people {
                    if person.age >= 18 && person.age <= 25 {
                        self.incrementBucket(state: person.state, bucket: ._18_25)
                    }
                    
                    if person.age >= 26 && person.age <= 41 {
                        self.incrementBucket(state: person.state, bucket: ._26_41)
                    }
                    
                    if person.age >= 41 && person.age <= 65 {
                        self.incrementBucket(state: person.state, bucket: ._41_65)
                    }
                }
                self.countRecordsByStateInBuckets(page: page + 1)
                print("fetched page: \(page)")

            } else {
                
                // print all buckets in order:
                self.statesWithNonEmptyBuckets.sort()
                for key in self.statesWithNonEmptyBuckets {
                    if let value: Int = self.stateBucketDict[key] {
                    print("\(key): \(String(describing: value))")
                    }
                }
            }
        }
    }
    
    func incrementBucket(state: String, bucket: Bucket) {
        let key = state + bucket.rawValue
        
        let value: Int? = stateBucketDict[key]
        
        if value == nil {
            statesWithNonEmptyBuckets.append(key)
            stateBucketDict[key] = 1
        } else {
            stateBucketDict[key] = value! + 1
        }
    }
    
    
    // - Provide a function that takes in a state and an age and returns all matching records.
    var result: [Person] = []
    func returnMatchingPeople(page: Int, state: String, age: Int) {
        
        PeopleApiInterface.instance.fetch(endpoint: makeUrl(page: page)) { (people) in
            
            if !people.isEmpty {
                
                for person in people {
                    if person.age == age && person.state == state {
                       self.result.append(person)
                    }
                }
                
                self.returnMatchingPeople(page: page + 1, state: state, age: age)
                print("fetched page: \(page)")
                
            } else {
                for item in self.result {
                    print (item.name)
                }
            }
        }
    }
    

    func makeUrl(page: Int = 1) -> String {
        return baseUrl + pageParam + String(page) + limitParam
    }
}

enum Bucket: String {
    case _18_25 = " 18 to 25" //  format so it prints nicely
    case _26_41 = " 26 to 41"
    case _41_65 = " 41 to 65"
}

