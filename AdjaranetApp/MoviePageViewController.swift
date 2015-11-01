//
//  MoviePageViewController.swift
//  AdjaranetApp
//
//  Created by vakhtang gelashvili on 8/5/15.
//  Copyright © 2015 vakhtang gelashvili. All rights reserved.
//

import UIKit
import MediaPlayer
import MBProgressHUD
import Async

class MoviePageViewController: UIViewController ,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{

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


    @IBOutlet var subView: UIView!
    @IBOutlet var scrollView: UIScrollView?
    
    @IBOutlet weak var detailsSubView: UIView!
    
    @IBOutlet var langChanger: UISegmentedControl!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var imdbLabel: UILabel!
    @IBOutlet weak var directorLabel: UILabel!
    @IBOutlet weak var genersLabel: UILabel!
    @IBOutlet weak var descriptionText: UITextView!
    
    @IBOutlet weak var actorsCollection: UICollectionView!
    @IBOutlet weak var relativeMoviesCollection: UICollectionView!
  
    @IBOutlet weak var actorsaAndRelativeView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        detailsSubView.layer.shadowColor=UIColor.grayColor().CGColor
        detailsSubView.layer.shadowOpacity=0.8
        detailsSubView.layer.shadowRadius=3
        detailsSubView.layer.shadowOffset=CGSize(width: 2.0,height: 2.0)
        
        detailsSubView.layer.cornerRadius=10.0
        
        actorsaAndRelativeView.layer.shadowColor=UIColor.grayColor().CGColor
        actorsaAndRelativeView.layer.shadowOpacity=0.8
        actorsaAndRelativeView.layer.shadowRadius=3
        actorsaAndRelativeView.layer.shadowOffset=CGSize(width: 2.0,height: 2.0)
        
        actorsaAndRelativeView.layer.cornerRadius=10.0
        
        subView.layer.shadowColor=UIColor.grayColor().CGColor
        subView.layer.shadowOpacity=0.8
        subView.layer.shadowRadius=3
        subView.layer.shadowOffset=CGSize(width: 2.0,height: 2.0)
        
        subView.layer.cornerRadius=10.0
        
        dateLabel.text=date
        imdbLabel.text=imdb
        descriptionText.text=mdescription
        descriptionText.editable=false
        
        
        
        actorsCollection.delegate=self
        actorsCollection.dataSource=self
        actorsCollection!.registerNib(UINib(nibName: "MoodCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: reuseIdentifier)
        actorsCollection.backgroundColor=UIColor.clearColor()
        loadActors()
        relativeMoviesCollection.delegate=self
        relativeMoviesCollection.dataSource=self
        relativeMoviesCollection!.registerNib(UINib(nibName: "MoodCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: reuseIdentifier)
        relativeMoviesCollection.backgroundColor=UIColor.clearColor()
        loadRelativeMovies()
        
        let langs=lang.characters.split(){$0==","}.map { String($0) }
        
        
        langChanger.removeAllSegments()
        
        var index=0;
        
        for langItem in langs{
            _=langItem as String!
            langChanger.insertSegmentWithTitle(langItem, atIndex: index, animated: true)
            index++;
        }
        langChanger.selectedSegmentIndex=0
        print("langs\(langs)")
        currentLang=langs[0] as String!
        // Do any additional setup after loading the view.
        
        movieUrl="http://adjaranet.com/download.php?mid=\(movieId)&file=\(movieId)_\(currentLang)_300";
        print(movieUrl)
        let url:NSURL = NSURL(string: movieUrl)!
        
        moviePlayer = MPMoviePlayerController(contentURL: url)
        
        
        //let horizontalConstraint = NSLayoutConstraint(item: moviePlayer.view, attribute: NSLayoutAttribute.CenterX, relatedBy: NSLayoutRelation.Equal, toItem: view, attribute: NSLayoutAttribute.CenterX, multiplier: 1, constant: 0)
        
        
        
        //moviePlayer.view.addConstraint(horizontalConstraint)
        
        //self.view.addSubview(moviePlayer.view)
        subView.addSubview(moviePlayer.view)
        
        moviePlayer.controlStyle = MPMovieControlStyle.Embedded
        moviePlayer.play()
    }
    
    override func viewWillDisappear(animated: Bool) {
        
        moviePlayer.pause();
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func langChanged(sender: UISegmentedControl) {
        let lang=sender.titleForSegmentAtIndex(sender.selectedSegmentIndex)as String!
        _=moviePlayer.currentPlaybackTime
        
        currentLang=lang as String!
        movieUrl="http://adjaranet.com/download.php?mid=\(movieId)&file=\(movieId)_\(currentLang)_300";
        print(movieUrl)
        let url:NSURL = NSURL(string: movieUrl)!
        print("kurl\(movieUrl)")
        moviePlayer = MPMoviePlayerController(contentURL: url)
        
        subView.addSubview(moviePlayer.view)
        
        moviePlayer.controlStyle = MPMovieControlStyle.Embedded
        moviePlayer.play()

    }
    
    override func viewDidLayoutSubviews() {
    
        subView.frame=CGRect(x: 0, y: 0, width: scrollView!.frame.width, height: subView.frame.height)
        moviePlayer.view.frame = CGRect(x: 0, y: 0, width: subView.frame.width, height: subView.frame.height)
        

    }
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        //#warning Incomplete method implementation -- Return the number of items in the section
        if(collectionView==relativeMoviesCollection){
            return self.relativeMovies.count
        }
        return self.actors.count
        
        
    }
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        if(collectionView==self.relativeMoviesCollection){
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
            
            relativeMoviesCollection?.reloadData()
            
            
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
        //print("Started downloading \"\(url.lastPathComponent!.stringByDeletingPathExtension)\".")
        getDataFromUrl(url) { data in
            dispatch_async(dispatch_get_main_queue()) {
                //print("Finished downloading \"\(url.lastPathComponent!.stringByDeletingPathExtension)\".")
                imageURL.image = UIImage(data: data!)
            }
        }
    }
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        return CGSize(width: 90, height: 150)
    }
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        
        if(collectionView == self.relativeMoviesCollection ){
            let movieIndex=indexPath.item
            let movie: AnyObject=self.relativeMovies.objectAtIndex(movieIndex)
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
    
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
