
/*
 
// Copy this into HackerRank to run there.

 
import Foundation

class PeopleApiInterface {
    
    static let instance = PeopleApiInterface()
    private let dispatchGroup = DispatchGroup()
    
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
                self.dispatchGroup.leave()
            } catch let error {
                print(error.localizedDescription)
            }
            
        })
        task.resume()
        dispatchGroup.enter()
        let _ = self.dispatchGroup.wait(timeout: .now() + .seconds(3))
    }
}


class Person {
    
    var id: String
    var name: String
    var state: String
    var age: Int
    
    init(id: String, name: String, state: String, age: Int) {
        self.id = id
        self.name = name
        self.state = state
        self.age = age
    }
    
    init(jsonItem: [String:Any?]) {
        self.id = jsonItem["id"]! as! String
        self.name = jsonItem["name"]! as! String
        self.state = jsonItem["state"]! as! String
        self.age = jsonItem["age"]! as! Int
    }
}

class ProblemRunner {
    static let instance =  ProblemRunner()
    let baseUrl: String = "http://52.14.36.184/people"
    var pageParam = "?_page="
    static var limit: Int = 20000    //        <--- Adjust this value
    var limitParam = "&_limit=\(limit)"
    
    var runningCountOfYoungAndOld = 0
    var stateBucketDict = Dictionary<String, Int>()
    var statesWithNonEmptyBuckets: [String] = []
    
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
    case _18_25 = " 18 to 25" //  formatted so it prints nicely
    case _26_41 = " 26 to 41"
    case _41_65 = " 41 to 65"
}

// MARK: code that runs when you hit 'Run Code':


class Problem {
    
    func run(){
        
        switch 1 { /// Toggle: 1, 2, or 3 to pick which function to see run.
        case 1:
            ProblemRunner.instance.countYoungAndOld(page: 1)
            break
        case 1:
            ProblemRunner.instance.countRecordsByStateInBuckets(page: 1)
            break
        default:
            ProblemRunner.instance.returnMatchingPeople(page: 1, state: "Georgia", age: 31)
        }
    }
}

let p = Problem() 
p.run()

 
 
*/

