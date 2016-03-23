//
//  TestCollectionViewController.swift
//  NFTopMenuController
//
//  Created by Niklas Fahl on 12/17/14.
//  Copyright (c) 2014 Niklas Fahl. All rights reserved.
//

import UIKit
import Async
import SDWebImage
import SwiftyJSON

let reuseIdentifier = "MoodCollectionViewCell"

class TestCollectionViewController: UICollectionViewController {
    var navigation: UINavigationController?
    
    var items = NSMutableArray()
   
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadMovies()
        
        self.collectionView!.registerNib(UINib(nibName: "MoodCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: reuseIdentifier)
    }
    func loadMovies() {
                RestApiManager.sharedInstance.getCollections({
                    json in let results = json
                    
                    
                    for (key, subJson): (String, JSON) in results {
                        let collection:JSON=JSON(subJson.object)
                        let name:String=collection["name"].string!
                        self.items.addObject(CollectionModel(colId: key,colName: name))
                        
            
                        
                    }
                    dispatch_async(dispatch_get_main_queue(),{
                        self.collectionView?.reloadData()
                    })
                })
        
        
            
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: UICollectionViewDataSource

    override func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        //#warning Incomplete method implementation -- Return the number of sections
        return 1
    }


    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        //#warning Incomplete method implementation -- Return the number of items in the section
        return items.count
    }

    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let index=indexPath.row
        let collection:CollectionModel =  self.items[index] as! CollectionModel
        let cell : MoodCollectionViewCell = collectionView.dequeueReusableCellWithReuseIdentifier(reuseIdentifier, forIndexPath: indexPath) as! MoodCollectionViewCell
        let collectionName=collection.colName
        let id=collection.colId
        let picURL = "http://static.adjaranet.com/collections/thumb/\(id)_big.jpg"
        let url = NSURL(string: picURL)
    
        // Configure the cell
        //cell.backgroundImageView.image = UIImage(named: backgroundPhotoNameArray[indexPath.row])
        
        //cell.backgroundImageView.image = UIImage(named: "relax.png")
        //downloadImage(url!, imageURL: cell.backgroundImageView)
        cell.backgroundImageView.sd_setImageWithURL(url!,placeholderImage: UIImage(named: "relax.png"))
        cell.moodTitleLabel.text = collectionName
        //cell.moodIconImageView.image = UIImage(named: photoNameArray[indexPath.row])*/
    
        return cell
    }
    override func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        let index=indexPath.item
        let collection:CollectionModel =  self.items[index] as! CollectionModel
        let storyboard2=UIStoryboard(name: "Main", bundle: nil)
        let view = storyboard2.instantiateViewControllerWithIdentifier("CollectionMovies") as! CollectionMoviesController
        view.collectionId=collection.colId
        view.title=collection.colName
        view.navigation=self.navigationController
        navigation!.pushViewController(view, animated: true)
        
        
        
    }
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        return CGSize(width: 130, height: 120)
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
}
