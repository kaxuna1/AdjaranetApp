//
//  CollectionMoviesController.swift
//  AdjaranetApp
//
//  Created by vakhtang gelashvili on 8/26/15.
//  Copyright © 2015 vakhtang gelashvili. All rights reserved.
//

import UIKit
import Async
import MBProgressHUD
import SDWebImage

class CollectionMoviesController: UIViewController,UITableViewDataSource, UITableViewDelegate {
    var collectionId:String?
    var navigation: UINavigationController?
    @IBOutlet weak var tableView: UITableView!
    var items = NSMutableArray()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate=self
        tableView.dataSource=self
        tableView.registerNib(UINib(nibName: "FriendTableViewCell", bundle: nil), forCellReuseIdentifier: "FriendTableViewCell")
        loadMovies()

        // Do any additional setup after loading the view.
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 128.0
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell : FriendTableViewCell = tableView.dequeueReusableCellWithIdentifier("FriendTableViewCell") as! FriendTableViewCell
        
        let movie:JSON =  JSON(self.items[indexPath.row])
        let picURL = movie["poster"].string
        let url = NSURL(string: picURL!)
        
        let title_en=movie["title_en"].string!
        let date=movie["release_date"].string!
        //let descriptionText=movie["description"].string!
        
        //cell.photoImageView.image = UIImage(named: "relax.png")
        
        //downloadImage(url!, imageURL: cell.photoImageView)
        
        cell.photoImageView.sd_setImageWithURL(url!,placeholderImage: UIImage(named: "relax.png"))
        
        
        // Configure the cell...
        cell.nameLabel?.text = "\(title_en) \(date)"
        
        
        //cell.descriptionLabel?.text="k)"
        //cell.detailTextLabel?.text="\(date)"
        
        return cell
    }
    func loadMovies() {
        
        
        Async.background{
            RestApiManager.sharedInstance.getCollectionMovies(self.collectionId!,onCompletion: { json in
                    let results = json
                
                    
                    for (_, subJson): (String, JSON) in results {
                        let movie:AnyObject=subJson.object
                        self.items.addObject(movie)
                    }
                    dispatch_async(dispatch_get_main_queue(),{
                        self.tableView?.reloadData()
                    })
                })
            }
        
    }
    func getDataFromUrl(urL:NSURL, completion: ((data: NSData?) -> Void)) {
        NSURLSession.sharedSession().dataTaskWithURL(urL) { (data, response, error) in
            completion(data: data)
            }.resume()
    }
    func downloadImage(url:NSURL,imageURL:UIImageView){
        
        getDataFromUrl(url) { data in
            dispatch_async(dispatch_get_main_queue()) {
                imageURL.image = UIImage(data: data!)
            }
        }
    }
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        _ = self.tableView.cellForRowAtIndexPath(indexPath)
        let movieIndex=indexPath.item
        let movie: AnyObject=items.objectAtIndex(movieIndex)
        let movieType:AnyObject?=movie["movie_type"]!
        
        if(Int((movieType as? String)!)==0){
            let storyboard2=UIStoryboard(name: "Main", bundle: nil)
            let view = storyboard2.instantiateViewControllerWithIdentifier("moviepageview") as! MoviePageViewController
            let title_en: AnyObject?=movie["title_en"]!;
            let movieId: AnyObject?=movie["id"]!
            let loadingNotification = MBProgressHUD.showHUDAddedTo(self.view, animated: true)
            loadingNotification.mode = MBProgressHUDMode.Indeterminate
            loadingNotification.labelText = "იტვირთება"
            let date: AnyObject?=movie["release_date"]!
            let imdb: AnyObject?=movie["imdb"]!
            
            Async.background{
                RestApiManager.sharedInstance.getMovieLang((movieId as? String)!, onCompletion: {
                    
                    json in let results = json["0"]
                    view.movieId=movieId as? String
                    view.title=title_en as? String
                    view.lang=results["lang"].string!
                    view.qual=results["quality"].string!
                    view.date=date as? String
                    view.imdb=imdb as? String!
                    view.mdescription=movie["description"]! as! String
                    
                    
                    dispatch_async(dispatch_get_main_queue(),{
                        MBProgressHUD.hideAllHUDsForView(self.view, animated: true)
                        self.navigationController!.pushViewController(view, animated: true)
                    })
                })
            }
            
            
        }else{
            let storyboard2=UIStoryboard(name: "Main", bundle: nil)
            let view = storyboard2.instantiateViewControllerWithIdentifier("SPVC") as! SPVC
            let title_en: AnyObject?=movie["title_en"]!;
            let id: AnyObject?=movie["id"]!
            //let lang: AnyObject?=movie["lang"]!
            let date: AnyObject?=movie["release_date"]!
            let imdb: AnyObject?=movie["imdb"]!
            
            view.movieId=id as? String
            view.title=title_en as? String
            //view.lang=lang as? String
            view.movieId=id as? String
            view.title=title_en as? String
            view.date=date as? String
            view.imdb=imdb as? String!
            view.mdescription=movie["description"]! as! String
            
            let loadingNotification = MBProgressHUD.showHUDAddedTo(self.view, animated: true)
            loadingNotification.mode = MBProgressHUDMode.Indeterminate
            loadingNotification.labelText = "იტვირთება"
            Async.background{
                
                
                RestApiManager.sharedInstance.getInfo((id as? String)!, onCompletion: {
                    json in let results = json
                    view.fileUrl=results["file_url"].string!;
                    
                    for index in 1...99{
                        let season:JSON=results["\(index)"]
                        if(season != nil){
                            //print("season: \(season)")
                            let seasonObject:SeasonModel=SeasonModel(name: "\(index)")
                            let episodesInSeason=season.count;
                            for episodeIndex in 1...episodesInSeason{
                                let episodeJSON:JSON=season["\(episodeIndex)"]
                                if(episodeJSON != nil){
                                    
                                    print("\(episodeJSON)")
                                    print("for error \(index) \(episodeIndex)")
                                    let epName:String="ეპოზოდი \(episodeIndex)"
                                    let epLang:String=episodeJSON["lang"].string!
                                    let epQual:String=episodeJSON["quality"].string!
                                    let episode=EpisodeModel(name : epName , lang : epLang, quality : epQual,number: episodeIndex,season:index)
                                    seasonObject.episodes.addObject(episode)
                                }
                            }
                            //print("in model \(seasonObject)")
                            view.seasons.addObject(seasonObject)
                        }
                        
                        
                        
                    }
                    
                    
                    
                    dispatch_async(dispatch_get_main_queue(),{
                        MBProgressHUD.hideAllHUDsForView(self.view, animated: true)
                        print("navigat")
                        self.navigationController!.pushViewController(view, animated: true)
                    })
                })
                
                
                
            }
        }
        
        
        
        
        
        
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
