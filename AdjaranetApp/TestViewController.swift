//
//  TestViewController.swift
//  NFTopMenuController
//
//  Created by Niklas Fahl on 12/16/14.
//  Copyright (c) 2014 Niklas Fahl. All rights reserved.
//

import UIKit
import Async
import MBProgressHUD
import SDWebImage


class TestViewController: UIViewController,UITableViewDataSource, UITableViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{
    var navigation: UINavigationController?
    
    var items = ["პრემიერები","ქართულად გახმოვანებული","ახალი დამატებული","ტოპ ფილმები","ახალი ეპიზოდები"]
    var itemsFunctions=[RestApiManager.sharedInstance.getPremiereMovies,]
    var itemsData=[NSMutableArray(),NSMutableArray(),NSMutableArray(),NSMutableArray(),NSMutableArray()]
    @IBOutlet weak var tableView: UITableView!
    
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate=self
        tableView.dataSource=self
        tableView.registerNib(UINib(nibName: "MTC", bundle: nil), forCellReuseIdentifier: "MTC")
    
    
        tableView.layer.shadowColor=UIColor.grayColor().CGColor
        tableView.layer.shadowOpacity=0.8
        tableView.layer.shadowRadius=3
        tableView.layer.shadowOffset=CGSize(width: 2.0,height: 2.0)
        
        tableView.layer.cornerRadius=10.0
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 240.0
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell : MTC = tableView.dequeueReusableCellWithIdentifier("MTC") as! MTC
        //let descriptionText=movie["description"].string!
        
        //cell.descriptionLabel?.text="k)"
        //cell.detailTextLabel?.text="\(date)"
        
        let cellName:String=items[indexPath.row] as String;
        cell.collection!.registerNib(UINib(nibName: "MoodCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: reuseIdentifier)
        cell.cellLabel?.text=cellName
        cell.collection.delegate=self
        cell.collection.dataSource=self
        cell.collection.tag=indexPath.row
        cell.collection.backgroundColor=UIColor.clearColor()
        cell.selectionStyle=UITableViewCellSelectionStyle.None
        
        if(itemsData[indexPath.row].count==0){
            loadMovies(cell.collection);
        }
        cell.collection!.reloadData()
        
        return cell
    }
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        //#warning Incomplete method implementation -- Return the number of sections
        return 1
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        //#warning Incomplete method implementation -- Return the number of items in the section
        return self.itemsData[collectionView.tag].count
        
        
    }
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        let movie:JSON =  JSON(self.itemsData[collectionView.tag][indexPath.row])
        
        let picURL = movie["poster"].string
        let url = NSURL(string: picURL!)
        
        _=movie["title_en"].string!
    
        
        
        
        
        let cell : MoodCollectionViewCell = collectionView.dequeueReusableCellWithReuseIdentifier(reuseIdentifier, forIndexPath: indexPath) as! MoodCollectionViewCell
        
        
        // Configure the cell
        //cell.backgroundImageView.image = UIImage(named: backgroundPhotoNameArray[indexPath.row])
        //cell.backgroundImageView.image = UIImage(named: "relax.png")
        cell.backgroundImageView.sd_setImageWithURL(url!,placeholderImage: UIImage(named: "relax.png"))
        //downloadImage(url!, imageURL: cell.backgroundImageView)
        cell.moodTitleLabel.text = ""
        //cell.moodIconImageView.image = UIImage(named: photoNameArray[indexPath.row])*/
        
        return cell
    }
    func loadMovies(collection:UICollectionView!) {
        Async.background{
            let function1=RestApiManager.sharedInstance.arrayOfFunctions[collection.tag]
            function1(RestApiManager.sharedInstance)({ json in
                let results = json
                
                for (_, subJson): (String, JSON) in results {
                    let movie:AnyObject=subJson.object
                    self.itemsData[collection.tag].addObject(movie)
                }
                dispatch_async(dispatch_get_main_queue(),{
                    collection?.reloadData()
                    
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
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        return CGSize(width: 120, height: 180)
    }
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        
        let movieIndex=indexPath.item
        if(collectionView.tag != 4 ){
            let movie: AnyObject=itemsData[collectionView.tag].objectAtIndex(movieIndex)
            let storyboard2=UIStoryboard(name: "Main", bundle: nil)
            let view = storyboard2.instantiateViewControllerWithIdentifier("moviepageview") as! MoviePageViewController
            let title_en: AnyObject?=movie["title_en"]!;
            let movieId: AnyObject?=movie["id"]!
            let date: AnyObject?=movie["release_date"]!
            let imdb: AnyObject?=movie["imdb"]!
    
            let loadingNotification = MBProgressHUD.showHUDAddedTo(self.view, animated: true)
            loadingNotification.mode = MBProgressHUDMode.Indeterminate
            loadingNotification.labelText = "იტვირთება"
            
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
            
        }else{
            let movie: AnyObject=itemsData[collectionView.tag].objectAtIndex(movieIndex)
            let storyboard2=UIStoryboard(name: "Main", bundle: nil)
            let view = storyboard2.instantiateViewControllerWithIdentifier("SPVC") as! SPVC
            let title_en: AnyObject?=movie["title_en"]!;
            let id: AnyObject?=movie["id"]!
            let lang: AnyObject?=movie["lang"]!
            let date: AnyObject?=movie["release_date"]!
            let imdb: AnyObject?=movie["imdb"]!
            
            view.movieId=id as? String
            view.title=title_en as? String
            view.lang=lang as? String
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
                        self.navigation!.pushViewController(view, animated: true)
                    })
                })
                
                
                
            }

            
        }
        
    }

    
}
