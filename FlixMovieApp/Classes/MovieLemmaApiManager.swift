//
//  MovieLemmaApiManager.swift
//  FlixMovieApp
//
//  Created by Henry Vuong on 9/3/19.
//  Copyright © 2019 Henry Vuong. All rights reserved.
//

import Foundation
import FirebaseAuth

class MovieLemmaApiManager {
    
    static let baseUrl = "https://movielemma.herokuapp.com/"
    static let recommendationRoute = "recommendation/"
    var session: URLSession
    
    init() {
        // Configure session so that completion handler is executed on main UI thread
        session = URLSession(configuration: .default, delegate: nil, delegateQueue: OperationQueue.main)
    }
    
    func recommendedMovies(completion: @escaping ([Movie]?, Error?) -> ()) {
        let url = URL(string: MovieLemmaApiManager.baseUrl + MovieLemmaApiManager.recommendationRoute + Auth.auth().currentUser!.uid)
        let request = URLRequest(url: url!, cachePolicy: .reloadIgnoringLocalCacheData, timeoutInterval: 10)
        let task = session.dataTask(with: request) { (data, response, error) in
            // This will run when the network request returns
            if let data = data {
                if let movieDictionaries = try? JSONSerialization.jsonObject(with: data, options: []) as! [[String: Any]] {
                    let movies = Movie.movies(dictionaries: movieDictionaries)
                    completion(movies, nil)
                } else {
                    // i just created a random error to prevent crashing 
                    let raiseError = NSError(domain: "", code: 2, userInfo: nil)
                    completion(nil, raiseError)
                }
               
                
            } else {
                completion(nil, error)
            }
        }
        task.resume()
    }
}
