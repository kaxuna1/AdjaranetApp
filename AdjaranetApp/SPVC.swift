//
//  SPVC.swift
//  AdjaranetApp
//
//  Created by vakhtang gelashvili on 9/6/15.
//  Copyright © 2015 vakhtang gelashvili. All rights reserved.
//

import UIKit
import MediaPlayer
import MBProgressHUD
import Async

class SPVC: UIViewController,UITableViewDataSource, UITableViewDelegate ,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{
    
    
    var title_en:String!
    var movieId:String!
    var mdescription:String!
    var date:String!
    var duration:String!
    var rating:String!
    var imdb:String!
    var lang:String!
    var qual:String!
    var movieUrl:String!
    var moviePlayer:MPMoviePlayerController!
    var langs : [String]=[""]
    var currentLang:String!
    var actors=NSMutableArray()
    var relativeMovies=NSMutableArray()
    var fileUrl:String!
    var currentEpisode:EpisodeModel!
    
    @IBOutlet weak var subView2: UIView!
    
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var subView: UIView!
    @IBOutlet weak var langChanger: UISegmentedControl!
    @IBOutlet weak var detailsSubView: UIView!
    @IBOutlet weak var imdbScore: UILabel!
    
    @IBOutlet weak var dateLabel: UILabel!
    
    @IBOutlet weak var genersLabel: UILabel!
    @IBOutlet weak var directorLabel: UILabel!
    @IBOutlet weak var sumeryText: UITextView!
    
    @IBOutlet weak var episodesSubView: UIView!
    @IBOutlet weak var episodesTable: UITableView!
    @IBOutlet weak var actorsAndRelativeSeriesSubView: UIView!
    
    @IBOutlet weak var actorsCollection: UICollectionView!
    @IBOutlet weak var relativeSeriesCollection: UICollectionView!
    
    @IBOutlet weak var seasonChooser: UISegmentedControl!
    var seasons=NSMutableArray();
    
    var currentEpisodes=NSMutableArray()
    
    var quality:String=""
    
    var currentEpNumber=""
    
    var currentEpSeason=""
    
    var currentEpQual=""
    
    
    @IBAction func langChanged(sender: UISegmentedControl) {
        let lang=sender.titleForSegmentAtIndex(sender.selectedSegmentIndex)as String!
        _=moviePlayer.currentPlaybackTime
        
        currentLang=lang as String!
        movieUrl="http://\(fileUrl)\(movieId)_\(currentEpSeason)_\(currentEpNumber)_\(currentLang)_\(currentEpQual).mp4";
       
        print(movieUrl)
        let url:NSURL = NSURL(string: movieUrl)!
        print("kurl\(movieUrl)")
        moviePlayer = MPMoviePlayerController(contentURL: url)
        
        subView.addSubview(moviePlayer.view)
        
        moviePlayer.controlStyle = MPMovieControlStyle.Embedded
        moviePlayer.play()
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        print("\(1)")
        self.imdbScore.text=self.imdb
        print("\(2)")
        self.dateLabel.text=self.date
        print("\(3)")
        self.sumeryText.text=self.mdescription
        print("\(4)")
        
        detailsSubView.layer.shadowColor=UIColor.grayColor().CGColor
        detailsSubView.layer.shadowOpacity=0.8
        detailsSubView.layer.shadowRadius=3
        detailsSubView.layer.shadowOffset=CGSize(width: 2.0,height: 2.0)
        
        detailsSubView.layer.cornerRadius=10.0
        
        actorsAndRelativeSeriesSubView.layer.shadowColor=UIColor.grayColor().CGColor
        actorsAndRelativeSeriesSubView.layer.shadowOpacity=0.8
        actorsAndRelativeSeriesSubView.layer.shadowRadius=3
        actorsAndRelativeSeriesSubView.layer.shadowOffset=CGSize(width: 2.0,height: 2.0)
        
        actorsAndRelativeSeriesSubView.layer.cornerRadius=10.0
        
        subView.layer.shadowColor=UIColor.grayColor().CGColor
        subView.layer.shadowOpacity=0.8
        subView.layer.shadowRadius=3
        subView.layer.shadowOffset=CGSize(width: 2.0,height: 2.0)
        
        subView.layer.cornerRadius=10.0
        
        
        
        episodesSubView.layer.shadowColor=UIColor.grayColor().CGColor
        episodesSubView.layer.shadowOpacity=0.8
        episodesSubView.layer.shadowRadius=3
        episodesSubView.layer.shadowOffset=CGSize(width: 2.0,height: 2.0)
        
        episodesSubView.layer.cornerRadius=10.0
        
        seasonChooser.removeAllSegments()
        for index in 0...(seasons.count-1) {
            let season:SeasonModel=seasons[index] as! SeasonModel
            print(season.name)
            seasonChooser.insertSegmentWithTitle(season.name, atIndex: index, animated: true)
            
        }
        
        let season1:SeasonModel=seasons[0] as! SeasonModel
        for index in 0...(season1.episodes.count-1){
            let episode:EpisodeModel=season1.episodes[index] as! EpisodeModel
            currentEpisodes.addObject(episode)
            
        }
        currentEpisode=season1.episodes[0] as! EpisodeModel
        let langs=currentEpisode.lang.characters.split(){$0==","}.map { String($0) }
        langChanger.removeAllSegments()
        
        var index=0;
        
        for langItem in langs{
            _=langItem as String!
            langChanger.insertSegmentWithTitle(langItem, atIndex: index, animated: true)
            index++;
        }
        langChanger.selectedSegmentIndex=0
        
        currentEpNumber=currentEpisode.number<10 ? "0\(currentEpisode.number)":"\(currentEpisode.number)"
        currentEpSeason=currentEpisode.season<10 ? "0\(currentEpisode.season)":"\(currentEpisode.season)"
        currentLang=langs[0]
        currentEpQual=currentEpisode.quality.characters.split(){$0==","}.map { String($0) }[0]
        
    let firstUrl:String="http://\(fileUrl)\(movieId)_\(currentEpSeason)_\(currentEpNumber)_\(currentLang)_\(currentEpQual).mp4";
        
        print("kurl \(firstUrl)")
        
        
        
        
        
        episodesTable.delegate=self
        episodesTable.dataSource=self
        episodesTable.registerNib(UINib(nibName: "episodesCell", bundle: nil), forCellReuseIdentifier: "episodesCell")
        
        episodesTable.reloadData()
        actorsCollection.delegate=self
        actorsCollection.dataSource=self
        actorsCollection!.registerNib(UINib(nibName: "MoodCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: reuseIdentifier)
        actorsCollection.backgroundColor=UIColor.clearColor()
        loadActors()
        relativeSeriesCollection.delegate=self
        relativeSeriesCollection.dataSource=self
        relativeSeriesCollection!.registerNib(UINib(nibName: "MoodCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: reuseIdentifier)
        relativeSeriesCollection.backgroundColor=UIColor.clearColor()
        loadRelativeMovies()
        
        let url:NSURL = NSURL(string: firstUrl)!
        
        moviePlayer = MPMoviePlayerController(contentURL: url)
        
        
        //let horizontalConstraint = NSLayoutConstraint(item: moviePlayer.view, attribute: NSLayoutAttribute.CenterX, relatedBy: NSLayoutRelation.Equal, toItem: view, attribute: NSLayoutAttribute.CenterX, multiplier: 1, constant: 0)
        
        
        
        //moviePlayer.view.addConstraint(horizontalConstraint)
        
        //self.view.addSubview(moviePlayer.view)
        print("bolo ")
        subView.addSubview(moviePlayer.view)
        
        moviePlayer.controlStyle = MPMovieControlStyle.Embedded
        moviePlayer.play()

        // Do any additional setup after loading the view.
    }
    override func viewDidAppear(animated: Bool) {
        
        super.viewDidAppear(animated);
        
       
        
    }
    override func viewDidLayoutSubviews() {
        
        
        subView.frame=CGRect(x: 0, y: 0, width: scrollView!.frame.width, height: subView.frame.height)
        moviePlayer.view.frame = CGRect(x: 0, y: 0, width: subView.frame.width, height: subView.frame.height)
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 40.0
    }
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return currentEpisodes.count
    }
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell : episodesCell = tableView.dequeueReusableCellWithIdentifier("episodesCell") as! episodesCell
        //let descriptionText=movie["description"].string!
        
        //cell.descriptionLabel?.text="k)"
        //cell.detailTextLabel?.text="\(date)"
        
        let currentEp:EpisodeModel=currentEpisodes[indexPath.row] as! EpisodeModel
        cell.name?.text=currentEp.name
        
        return cell
    }
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        //#warning Incomplete method implementation -- Return the number of items in the section
        if(collectionView == relativeSeriesCollection){
            return self.relativeMovies.count
        }
        return self.actors.count
        
        
    }
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        if(collectionView==self.relativeSeriesCollection){
            let movie:JSON =  JSON(self.relativeMovies[indexPath.row])
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
        
        let actor:ActorModel =  self.actors[indexPath.row] as! ActorModel
        
        let picURL = "http://static.adjaranet.com/cast/\(actor.actorId).jpg"
        let url = NSURL(string: picURL)
        
        
        let cell : MoodCollectionViewCell = collectionView.dequeueReusableCellWithReuseIdentifier(reuseIdentifier, forIndexPath: indexPath) as! MoodCollectionViewCell
        
        
        // Configure the cell
        //cell.backgroundImageView.image = UIImage(named: backgroundPhotoNameArray[indexPath.row])
        //cell.backgroundImageView.image = UIImage(named: "relax.png")
        cell.backgroundImageView.sd_setImageWithURL(url!,placeholderImage: UIImage(named: "both.png"))
        //downloadImage(url!, imageURL: cell.backgroundImageView)
        cell.moodTitleLabel.text = actor.actorName
        //cell.moodIconImageView.image = UIImage(named: photoNameArray[indexPath.row])*/
        
        return cell
    }
    func loadActors() {
        Async.background{
            RestApiManager.sharedInstance.getInfo(self.movieId,onCompletion: {
                json in let results = json["cast"]
                print(json);
                //println("data:\(results)")
                for (k, subJson): (String, JSON) in results {
                    //print("\(k),\(subJson.object)")
                    self.actors.addObject(ActorModel(actorId: k, actorName: subJson.object as! String))
                }
                dispatch_async(dispatch_get_main_queue(),{
                    actorsCollection?.reloadData()
                })
            })
            RestApiManager.sharedInstance.getInfo(self.movieId,onCompletion: {
                json in let results = json["director"]
                print(json);
                //println("data:\(results)")
                for (_, subJson): (String, JSON) in results {
                    //print("\(k),\(subJson.object)")
                    self.directorLabel.text=subJson.object as? String
                }
                dispatch_async(dispatch_get_main_queue(),{
                    
                })
            })
            RestApiManager.sharedInstance.getInfo(self.movieId,onCompletion: {
                json in let results = json["genres"]
                print(json);
                //println("data:\(results)")
                var gen=""
                var i=0;
                for (key, subJson): (String, JSON) in results {
                    //print("\(k),\(subJson.object)")
                    if(Int(key)>850&&i<2){
                        let s=subJson.object as? String
                        gen+=s!
                        if(i == 0){
                            gen+=","
                        }
                        i++;
                    }
                    
                    
                }
                self.genersLabel.text=gen
                dispatch_async(dispatch_get_main_queue(),{
                })
            })
            
        }
        
        
        
    }
    func loadRelativeMovies() {
        Async.background{
            RestApiManager.sharedInstance.getRelativeMovies(self.movieId,onCompletion: {
                
                
                json in let results = json
                print(json);
                for (_, subJson): (String, JSON) in results {
                    //print("\(k),\(subJson.object)")
                    let movie:AnyObject=subJson.object
                    self.relativeMovies.addObject(movie)
                }
                dispatch_async(dispatch_get_main_queue(),{
                    
                    relativeSeriesCollection?.reloadData()
                    
                    
                })
                
            })
        }
    }
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        return CGSize(width: 90, height: 150)
    }
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        
        if(collectionView == self.relativeSeriesCollection ){
            let movieIndex=indexPath.item
            let movie: AnyObject=self.relativeMovies.objectAtIndex(movieIndex)
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
        }else{
            let actorIndex=indexPath.item
            let actor:ActorModel=self.actors.objectAtIndex(actorIndex) as! ActorModel
            let storyboard2=UIStoryboard(name: "Main", bundle: nil)
            let view = storyboard2.instantiateViewControllerWithIdentifier("AMC") as! AMCViewController
            view.actorId=actor.actorId
            self.navigationController?.pushViewController(view, animated: true)
            
        }
    }
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        let serieIndex=indexPath.item
        currentEpisode=currentEpisodes[serieIndex] as! EpisodeModel
        let langs=currentEpisode.lang.characters.split(){$0==","}.map { String($0) }
        langChanger.removeAllSegments()
        
        var index=0;
        
        for langItem in langs{
            _=langItem as String!
            langChanger.insertSegmentWithTitle(langItem, atIndex: index, animated: true)
            index++;
        }
        langChanger.selectedSegmentIndex=0
        
        currentEpNumber=currentEpisode.number<10 ? "0\(currentEpisode.number)":"\(currentEpisode.number)"
        currentEpSeason=currentEpisode.season<10 ? "0\(currentEpisode.season)":"\(currentEpisode.season)"
        currentLang=langs[0]
        currentEpQual=currentEpisode.quality.characters.split(){$0==","}.map { String($0) }[0]
        
        let firstUrl:String="http://\(fileUrl)\(movieId)_\(currentEpSeason)_\(currentEpNumber)_\(currentLang)_\(currentEpQual).mp4";
        
        print("kurl \(firstUrl)")
        let url:NSURL = NSURL(string: firstUrl)!
        
        moviePlayer = MPMoviePlayerController(contentURL: url)
        
        subView.addSubview(moviePlayer.view)
        
        moviePlayer.controlStyle = MPMovieControlStyle.Embedded
        moviePlayer.play()
        
        
    }
    override func viewWillDisappear(animated: Bool) {
        
        moviePlayer.pause();
    }
    @IBAction func seasonChange(sender: UISegmentedControl) {
        currentEpisodes.removeAllObjects()
        let season=sender.titleForSegmentAtIndex(sender.selectedSegmentIndex)as String!
        let seasonNumber:Int=Int(season)!-1
        for i in 0...(self.seasons[seasonNumber].episodes.count-1){
            let episode:EpisodeModel=self.seasons[seasonNumber].episodes[i] as! EpisodeModel
            currentEpisodes.addObject(episode)
        }
        episodesTable.reloadData()
        
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
