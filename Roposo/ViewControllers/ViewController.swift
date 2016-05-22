//
//  ViewController.swift
//  Roposo
//
//  Created by starapps on 20/05/16.
//  Copyright © 2016 private. All rights reserved.
//

import UIKit
import SwiftyJSON

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, StoryCellDelegate, StoryDetailControllerDelegate {
    
    // Variables
    var stories = [Story]()
    var users = [User]()
    
    // Views
    var storiesTableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    
    var progressIndicator: UIActivityIndicatorView = {
        let activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: .Gray)
        activityIndicator.autoresizingMask = [.FlexibleLeftMargin, .FlexibleRightMargin, .FlexibleTopMargin, .FlexibleBottomMargin]
        return activityIndicator
    }()
    
    // StoryCellDelegate functions
    func shareStory(index: Int, sender: UIButton) {
        CommonFunctions.nativeShare(self, story: stories[index], sender: sender)
    }
    
    func setLikeStateFromStoryCell(index: Int, story: Story) {
        // update story parameters of ViewController
        stories[index].likeFlag = story.getLikeFlag()
        stories[index].likesCount = story.getLikesCount()
    }
    
    // StoryDetailControllerDelegate functions
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return stories.count
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return CommonFunctions.getStoryImageHeight() + 225.0
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("storyCell") as! StoryCell
        cell.selectionStyle = UITableViewCellSelectionStyle.None
        cell.delegate = self
        cell.configureStoryCell(indexPath.row, story: stories[indexPath.row], user: getStoryUser(stories[indexPath.row]))
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        // Open StoryDetailController to show particular story detail
        let detailController = StoryDetailController()
        detailController.story = stories[indexPath.row]
        detailController.user = getStoryUser(stories[indexPath.row])
        detailController.storyIndex = indexPath.row
        detailController.delegate = self
        self.navigationController?.pushViewController(detailController, animated: true)
    }
    
    // StoryDetailControllerDelegate fucntions
    func setLikeStateFromDetailController(index: Int, story: Story) {
        /*
         update likeFlag and likeCount values if any action is performed on StoryDetailController
         tableViewCell reloaded to update changes
         */
        stories[index].likeFlag = story.getLikeFlag()
        stories[index].likesCount = story.getLikesCount()
        storiesTableView.reloadRowsAtIndexPaths([NSIndexPath(forRow: index, inSection: 0)], withRowAnimation: .None)
    }
    
    // Util function to get user from story -> 'db' paramter
    func getStoryUser(story: Story) -> User {
        for user in users {
            if user.getId() == story.getDb() {
                return user
            }
        }
        
        // Return default user
        return users[0]
    }
    
    /*
     The whole process of reading JSON and converting into objects is done in a seperate background thread
     If the json file is heavy, it can block UI thread
     */
    func createObjectsFromJson() {
        let fileName = NSBundle.mainBundle().pathForResource("iOS-Android Data", ofType: "json")
        if fileName != nil {
            let data = NSData(contentsOfFile: fileName!)
            let json = JSON(data: data!, options: NSJSONReadingOptions.AllowFragments, error: nil)
            
            for (_,subJson):(String, JSON) in json {
                
                /*
                 Assuming that only story has 'type' paramter
                 If JSON object has a 'type' paramter present, the execution moves to if condition and story object is initialized,
                 Otherwise user object is created and added to 'users' array
                 */
                if let _ = subJson[TYPE].string {
                    let story = Story()
                    story.storyDesc = subJson[DESCRIPTION].stringValue
                    story.commentCount = subJson[COMMENT_COUNT].intValue
                    story.db = subJson[DB].stringValue
                    story.id = subJson[ID].stringValue
                    story.likeFlag = subJson[LIKE_FLAG].boolValue
                    story.likesCount = subJson[LIKES_COUNT].intValue
                    story.si = subJson[SI].stringValue
                    story.title = subJson[TITLE].stringValue
                    story.type = subJson[TYPE].stringValue
                    story.url = subJson[URL].stringValue
                    story.verb = subJson[VERB].stringValue
                    
                    stories.append(story)
                }
                else {
                    let user = User()
                    user.about = subJson[ABOUT].string
                    user.id = subJson[ID].string
                    user.createdOn = subJson[CREATED_ON].int64
                    user.followers = subJson[FOLLOWERS].int
                    user.handle = subJson[HANDLE].string
                    user.image = subJson[IMAGE].string
                    user.isFollowing = subJson[IS_FOLLOWING].bool
                    user.username = subJson[USERNAME].string
                    user.following = subJson[FOLLOWING].intValue
                    user.url = subJson[URL].stringValue
                    
                    users.append(user)
                }
            }
        }
    }
    
    func createObjectsAndLoadData() {
        progressIndicator.startAnimating()
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0)) {
            self.createObjectsFromJson()
            dispatch_async(dispatch_get_main_queue(), {
                self.progressIndicator.stopAnimating()
                self.storiesTableView.reloadData()
            })
        }
    }
    
    func setupViews() {
        self.view.addSubview(storiesTableView)
        self.view.addSubview(progressIndicator)
    }
    
    func setupConstraints() {
        let viewsDictionary = ["storiesTableView": storiesTableView]
        
        // Pin storiesTableView to top, bottom, left and right borders of view
        self.view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|[storiesTableView]|", options: [], metrics: nil, views: viewsDictionary))
        self.view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|[storiesTableView]|", options: [], metrics: nil, views: viewsDictionary))
    }
    
    func configureViews() {
        view.backgroundColor = UIColor.whiteColor()
        
        storiesTableView.delegate = self
        storiesTableView.dataSource = self
        storiesTableView.separatorColor = UIColor.clearColor()
        storiesTableView.tableFooterView = UIView(frame: CGRect.zero)
        storiesTableView.registerClass(StoryCell.self, forCellReuseIdentifier: "storyCell")
        
        progressIndicator.center = CGPointMake(view.bounds.midX, view.bounds.midY)
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        navigationItem.title = " "
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        setupNavigationBar()
        navigationItem.title = APP_NAME
    }
    
    func setupNavigationBar() {
        let navigationBar = self.navigationController?.navigationBar
        
        navigationBar?.translucent = false
        navigationBar?.barTintColor = _navigationBarTintColor
        navigationBar?.barStyle = UIBarStyle.Black
        navigationBar?.tintColor = _navigationBarTitleColor
        navigationBar?.titleTextAttributes = [
            NSForegroundColorAttributeName: _navigationBarTitleColor
        ]
        navigationBar?.setBackgroundImage(nil, forBarMetrics: .Default)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = APP_NAME
        
        setupViews()
        setupConstraints()
        configureViews()
        createObjectsAndLoadData()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}

