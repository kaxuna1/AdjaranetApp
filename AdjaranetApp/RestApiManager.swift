//
//  RestApiManager.swift
//  adjaranet
//
//  Created by vakhtang gelashvili on 7/28/15.
//  Copyright (c) 2015 vakhtang gelashvili. All rights reserved.
//

import Foundation
import SwiftyJSON
typealias ServiceResponse = (JSON, NSError?) -> Void

class RestApiManager:NSObject {
    static let sharedInstance=RestApiManager()
    
    var arrayOfFunctions=[getPremiereMovies,getLatestGeoMovies,getNewAddedMovies,getTopMovies,getNewEpisodes,getGeoEpisodes]
    
    let baseURL = "http://adjaranet.com/Search/SearchResults?ajax=1&display=15&startYear=1900&endYear=2015&offset={off}&isnew=0&keyword={keyword}&needtags=0&orderBy=date&order%5Border%5D=data&order%5Bdata%5D=published&language=false&country=false&game=0&videos=0&xvideos=0&xphotos=0&trailers=0&episode=0&tvshow=0&flashgames=0"
    
    
    func getMovies(keyWord:String,count:Int,onCompletion: (JSON) -> Void) {
        var route = "http://adjaranet.com/Search/SearchResults?ajax=1&display=15&startYear=1900&endYear=2015&offset=\(count)&isnew=0&keyword=\(keyWord)&needtags=0&orderBy=date&order%5Border%5D=data&order%5Bdata%5D=published&language=false&country=false&game=0&videos=0&xvideos=0&xphotos=0&trailers=0&episode=0&tvshow=0&flashgames=0"
        route = route.stringByReplacingOccurrencesOfString(" ", withString: "%20")
        makeHTTPGetRequest(route, onCompletion: { json, err in
            onCompletion(json as JSON)
        })
    }
    func getSeries(keyWord:String,count:Int,onCompletion: (JSON) -> Void) {
        var route = "http://adjaranet.com/Search/SearchResults?ajax=1&display=15&startYear=1900&endYear=2015&offset=\(count)&isnew=0&keyword=\(keyWord)&needtags=0&orderBy=date&order%5Border%5D=data&order%5Bdata%5D=published&language=false&country=false&game=0&videos=0&xvideos=0&xphotos=0&trailers=0&episode=1&tvshow=0&flashgames=0"
        route = route.stringByReplacingOccurrencesOfString(" ", withString: "%20")
        makeHTTPGetRequest(route, onCompletion: { json, err in
            onCompletion(json as JSON)
        })
    }
    func getCollections(onCompletion: (JSON) -> Void) {
        var route = "http://adjaranet.com/req/jsondata/req.php?reqId=getCollections"
        route = route.stringByReplacingOccurrencesOfString(" ", withString: "%20")
        makeHTTPGetRequest(route, onCompletion: { json, err in
            onCompletion(json as JSON)
        })
    }
    func getCollectionMovies(id:String,onCompletion: (JSON) -> Void) {
        
        var route = "http://adjaranet.com/req/jsondata/req.php?reqId=getCollections&id=\(id)"
        route = route.stringByReplacingOccurrencesOfString(" ", withString: "%20")
        makeHTTPGetRequest(route, onCompletion: { json, err in
            onCompletion(json as JSON)
        })
    }
    func getInfo(id:String,onCompletion: (JSON) -> Void) {
        var route = "http://adjaranet.com/req/jsondata/req.php?id=\(id)&reqId=getInfo"
        route = route.stringByReplacingOccurrencesOfString(" ", withString: "%20")
        makeHTTPGetRequest(route, onCompletion: { json, err in
            onCompletion(json as JSON)
        })
    }
    func getRelativeMovies(id:String,onCompletion: (JSON) -> Void) {
        var route = "http://adjaranet.com/Movie/BuildSliderRelated?ajax=1&movie_id=\(id)&isepisode=0&type=related&order=top&period=day&limit=25"
        route = route.stringByReplacingOccurrencesOfString(" ", withString: "%20")
        makeHTTPGetRequest(route, onCompletion: { json, err in
            onCompletion(json as JSON)
        })
    }
    func getActorMovies(id:String,onCompletion: (JSON) -> Void) {
        var route = "http://adjaranet.com/req/jsondata/req.php?reqId=getActorMovies&id=\(id)"
        route = route.stringByReplacingOccurrencesOfString(" ", withString: "%20")
        makeHTTPGetRequest(route, onCompletion: { json, err in
            onCompletion(json as JSON)
        })
    }
    func getMovieLang(id:String,onCompletion: (JSON) -> Void) {
        var route = "http://adjaranet.com/req/jsondata/req.php?id=\(id)&reqId=getLangAndHd"
        route = route.stringByReplacingOccurrencesOfString(" ", withString: "%20")
        makeHTTPGetRequest(route, onCompletion: { json, err in
            onCompletion(json as JSON)
        })
    }
    func getPremiereMovies(onCompletion: (JSON) -> Void) {
        var route = "http://adjaranet.com/cache/cached_home_premiere.php?type=premiere&order=new&period=week&limit=25"
        route = route.stringByReplacingOccurrencesOfString(" ", withString: "%20")
        makeHTTPGetRequest(route, onCompletion: { json, err in
            onCompletion(json as JSON)
        })
    }
    func getLatestGeoMovies(onCompletion: (JSON) -> Void) {
        var route = "http://adjaranet.com/cache/cached_home_geomovies.php?type=geomovies&order=new&period=day&limit=25"
        route = route.stringByReplacingOccurrencesOfString(" ", withString: "%20")
        makeHTTPGetRequest(route, onCompletion: { json, err in
            onCompletion(json as JSON)
        })
    }
    func getTopMovies(onCompletion: (JSON) -> Void) {
        var route = "http://adjaranet.com/Home/ajax_home?ajax=1&type=premiere&order=top&period=week&limit=25"
        route = route.stringByReplacingOccurrencesOfString(" ", withString: "%20")
        makeHTTPGetRequest(route, onCompletion: { json, err in
            onCompletion(json as JSON)
        })
    }
    func getNewEpisodes(onCompletion: (JSON) -> Void) {
        var route = "http://adjaranet.com/cache/cached_home_episodes.php?type=episodes&order=new&period=week&limit=25"
        route = route.stringByReplacingOccurrencesOfString(" ", withString: "%20")
        makeHTTPGetRequest(route, onCompletion: { json, err in
            onCompletion(json as JSON)
        })
    }
    func getGeoEpisodes(onCompletion: (JSON) -> Void) {
        var route = "http://adjaranet.com/Home/ajax_home?ajax=1&type=geomovies&order=top&period=null&limit=25"
        route = route.stringByReplacingOccurrencesOfString(" ", withString: "%20")
        makeHTTPGetRequest(route, onCompletion: { json, err in
            onCompletion(json as JSON)
        })
    }
    func getNewAddedMovies(onCompletion: (JSON) -> Void) {
        var route = "http://adjaranet.com/cache/cached_home_movies.php?type=movies&order=new&period=week&limit=25"
        route = route.stringByReplacingOccurrencesOfString(" ", withString: "%20")
        makeHTTPGetRequest(route, onCompletion: { json, err in
            onCompletion(json as JSON)
        })
    }
    func getMyRegion(onCompletion: (JSON) -> Void) {
        var route = "http://ip-api.com/json"
        route = route.stringByReplacingOccurrencesOfString(" ", withString: "%20")
        makeHTTPGetRequest(route, onCompletion: { json, err in
            onCompletion(json as JSON)
        })
    }
    
    
    
    
    
    func makeHTTPGetRequest(path: String, onCompletion: ServiceResponse) {
        let request = NSMutableURLRequest(URL: NSURL(string: path)!)
        
        let session = NSURLSession.sharedSession()
        
        let task = session.dataTaskWithRequest(request, completionHandler: {data, response, error -> Void in
            
            print("\(error)")
            if error==nil{
                let json:JSON! = JSON(data: data!)
                onCompletion(json, error)
            }
            
            
        })
        task.resume()
            
    }
    
    
}