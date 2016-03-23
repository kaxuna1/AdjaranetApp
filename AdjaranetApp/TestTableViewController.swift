//
//  TestTableViewController.swift
//  NFTopMenuController
//
//  Created by Niklas Fahl on 12/17/14.
//  Copyright (c) 2014 Niklas Fahl. All rights reserved.
//


import UIKit
import Async
import SDWebImage
import MBProgressHUD
import SwiftyJSON

class TestTableViewController: UITableViewController,UISearchBarDelegate {
    
    var navigation: UINavigationController?
    
    var k=0;
    
    var loadedMovies:Int=0;
    //var tableView:UITableView?
    var items = NSMutableArray()

    
    //@IBOutlet weak var searchbar: UISearchBar!

    @IBOutlet weak var searchBarField: UISearchBar!
    
    var keyWoard=""
    var loadingNow=false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print("1")
        Async.background{
           self.loadMovies()
        }
        print("2")
        
        searchBarField.delegate=self;
        
        print("3")
        
        self.tableView.registerNib(UINib(nibName: "FriendTableViewCell", bundle: nil), forCellReuseIdentifier: "FriendTableViewCell")
        //self.tableView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
        print("4")
        //loadMovies()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Potentially incomplete method implementation.
        // Return the number of sections.
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete method implementation.
        // Return the number of rows in the section.
        return items.count
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell : FriendTableViewCell = tableView.dequeueReusableCellWithIdentifier("FriendTableViewCell") as! FriendTableViewCell
        print("5")
        let movie:JSON =  JSON(self.items[indexPath.row])
        let picURL = movie["poster"].string
        let url = NSURL(string: picURL!)
        print("6")
        let title_en=movie["title_en"].string!
        let date=movie["release_date"].string!
        //let descriptionText=movie["description"].string!
        print("7")
        //cell.photoImageView.image = UIImage(named: "relax.png")
        cell.photoImageView.sd_setImageWithURL(url!,placeholderImage: UIImage(named: "relax.png"))
        //downloadImage(url!, imageURL: cell.photoImageView)
        print("8")
        
        // Configure the cell...
        print("9")
        cell.nameLabel?.text = "\(title_en) \(date)"
        print("10")
        
        //cell.descriptionLabel?.text="k)"
        //cell.detailTextLabel?.text="\(date)"
        
        return cell
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
   
    func loadMovies() {
        if !loadingNow{
            Async.background{
                self.loadingNow=true
                RestApiManager.sharedInstance.getMovies(self.keyWoard,count: self.loadedMovies,onCompletion: { json in
                    let results = json["data"]
                    for (_, subJson): (String, JSON) in results {
                        let movie:AnyObject=subJson.object
                        self.items.addObject(movie)
                        self.loadedMovies+=1
                    }
                    dispatch_async(dispatch_get_main_queue(),{
                        self.tableView?.reloadData()
                        self.loadingNow=false
                    })
                })
            }
            
        }
        
    }
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 128.0
    }
    override func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        
        let currentLoaded:Int=loadedMovies as Int
        k += 1;
        if((currentLoaded-3)==indexPath.row){
            Async.background{
                self.loadMovies()
            }
        }
    }
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        _ = self.tableView.cellForRowAtIndexPath(indexPath)
        
        
        
        let movieIndex=indexPath.item
            let movie: AnyObject=items.objectAtIndex(movieIndex)
            let storyboard2=UIStoryboard(name: "Main", bundle: nil)
            let view = storyboard2.instantiateViewControllerWithIdentifier("moviepageview") as! MoviePageViewController
            let title_en: AnyObject?=movie["title_en"]!;
            let movieId: AnyObject?=movie["id"]!
            let date: AnyObject?=movie["release_date"]!
            let imdb: AnyObject?=movie["imdb"]!
            
            let loadingNotification = MBProgressHUD.showHUDAddedTo(self.view, animated: true)
            loadingNotification.mode = MBProgressHUDMode.Indeterminate
            loadingNotification.labelText = "იტვირთება"
        
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
                    self.navigation!.pushViewController(view, animated: true)
                })
            })
        
        
        
        }
        

        
        
    }
   
    func searchBar(searchBar: UISearchBar, textDidChange searchText: String) {
        loadedMovies=0;
        keyWoard=searchText;
        
        items.removeAllObjects();
        Async.background{
            self.loadMovies()
        }
        self.tableView.reloadData()
    }
    
    
}