//
//  StoryDetailController.swift
//  Roposo
//
//  Created by starapps on 21/05/16.
//  Copyright © 2016 private. All rights reserved.
//

import UIKit
import SDWebImage
import SwiftyJSON

protocol StoryDetailControllerDelegate: class {
    func setLikeStateFromDetailController(index: Int, story: Story)
}

class StoryDetailController: UIViewController {
    
    // Variables
    var storyIndex: Int?
    var user = User()
    var story = Story()
    weak var delegate: StoryDetailControllerDelegate?
    
    // Views
    var detailContainerView: UIView = {
        let containerView = UIView()
        containerView.translatesAutoresizingMaskIntoConstraints = false
        return containerView
    }()
    
    var detailScrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
//        scrollView.contentSize = CGSizeMake(1000, 1000)
        return scrollView
    }()
    
    var storyImage: UIImageView = {
        let imageView = UIImageView()
        imageView.backgroundColor = _bottomBorderColor
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .ScaleAspectFit
        imageView.clipsToBounds = true
        return imageView
    }()
    
    var storyTitle: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.lineBreakMode = .ByWordWrapping
        label.font = _bigTitleFont
        label.textColor = _titleColor
        label.textAlignment = .Left
        return label
    }()
    
    var storyDesc: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.textColor = _subtitleColor
        label.lineBreakMode = NSLineBreakMode.ByWordWrapping
        label.font = _bigSubtitleFont
        label.textAlignment = .Left
        return label
    }()
    
    var storyDate: UILabel = {
        let label = UILabel()
        label.font = _bigSubtitleFont
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .Left
        label.numberOfLines = 0
        label.textColor = _subtitleColor
        label.lineBreakMode = NSLineBreakMode.ByWordWrapping
        return label
    }()
    
    var userImage: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.layer.cornerRadius = Constants.USERIMAGE_WIDTH / 2
        imageView.clipsToBounds = true
        return imageView
    }()
    
    var username: UILabel = {
        let label = UILabel()
        label.font = _titleFont
        label.textColor = _titleColor
        label.numberOfLines = 0
        label.lineBreakMode = .ByWordWrapping
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    var handle: UILabel = {
        let label = UILabel()
        label.font = _subtitleFont
        label.textColor = _subtitleColor
        label.numberOfLines = 0
        label.lineBreakMode = .ByWordWrapping
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    var userDesc: UILabel = {
        let label = UILabel()
        label.font = _titleFont
        label.textColor = _titleColor
        label.numberOfLines = 0
        label.lineBreakMode = .ByWordWrapping
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    var postedByLabel: UILabel = {
        let label = UILabel()
        label.font = _subtitleFont
        label.textColor = _followBtnColor
        label.numberOfLines = 1
        label.text = POSTED_BY
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    var likeBtn: UIButton = {
        let button = UIButton()
        button.clipsToBounds = true
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    var commentBtn: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(_commentImage, forState: .Normal)
        return button
    }()
    
    var shareBtn: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(_shareImage, forState: .Normal)
        return button
    }()
    
    var likesCount: UILabel = {
        let label = UILabel()
        label.font = _subtitleFont
        label.textColor = _followBtnColor
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    var commentCount: UILabel = {
        let label = UILabel()
        label.font = _subtitleFont
        label.textColor = _followBtnColor
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    var followBtn: UIButton = {
        let button = UIButton()
        button.layer.cornerRadius = Constants.FOLLOW_BTN_CORNER_RADIUS
        button.layer.borderWidth = Constants.FOLLOW_BTN_BORDER_WIDTH
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    var bottomBorder: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = _bottomBorderColor
        return view
    }()
    
    func setupConstraints() {
        // Setup metrics dictionary
        let metrics = [
            "storyImageHeight": CommonFunctions.getStoryImageHeight(),
            "userImageWidth": Constants.USERIMAGE_BIG_WIDTH,
            "actionButtonWidth": Constants.ACTION_BUTTON_WIDTH,
            "actionButtonHeight": Constants.ACTION_BUTTON_HEIGHT,
            "bottomBorderHeight": Constants.BOTTOM_BORDER_HEIGHT,
            "smallPadding": Constants.SMALL_PADDING,
            "largePadding": Constants.LARGE_PADDING
            
        ]
        
        // Setup views dictionary
        let viewsDictionary = [
            "superView": self.view,
            "detailScrollView": detailScrollView,
            "detailContainerView": detailContainerView,
            "storyImage": storyImage,
            "storyTitle": storyTitle,
            "storyDesc": storyDesc,
            "storyDate": storyDate,
            "likesCount": likesCount,
            "commentCount": commentCount,
            "likeBtn": likeBtn,
            "commentBtn": commentBtn,
            "shareBtn": shareBtn,
            "bottomBorder": bottomBorder,
            "postedByLabel": postedByLabel,
            "userImage": userImage,
            "username": username,
            "handle": handle,
            "userDesc": userDesc,
            "followBtn": followBtn
        ]
        
        self.view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|[bottomBorder]|", options: [], metrics: nil, views: viewsDictionary))
        self.view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|[detailScrollView]|", options: [], metrics: nil, views: viewsDictionary))
        self.view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|-(-64)-[detailScrollView]|", options: [], metrics: nil, views: viewsDictionary))
        self.view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:[detailContainerView(==superView)]", options: [], metrics: nil, views: viewsDictionary))
        self.view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|[detailContainerView]|", options: [], metrics: nil, views: viewsDictionary))
        self.view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|[detailContainerView]|", options: [], metrics: nil, views: viewsDictionary))
        self.view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|[storyImage(storyImageHeight)]-smallPadding-[storyTitle]", options: [], metrics: metrics, views: viewsDictionary))
        self.view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|[storyImage]|", options: [], metrics: metrics, views: viewsDictionary))
        self.view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|-largePadding-[storyTitle]-largePadding-|", options: [], metrics: metrics, views: viewsDictionary))
        self.view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:[storyTitle]-smallPadding-[storyDesc]-largePadding-[storyDate]", options: [NSLayoutFormatOptions.AlignAllLeading, NSLayoutFormatOptions.AlignAllTrailing], metrics: metrics, views: viewsDictionary))
        self.view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:[storyDate]-smallPadding-[likesCount]", options: .AlignAllLeading, metrics: metrics, views: viewsDictionary))
        self.view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:[likesCount][likeBtn(actionButtonHeight)]-smallPadding-[bottomBorder(bottomBorderHeight)]-largePadding-[postedByLabel]-[username]", options: [], metrics: metrics, views: viewsDictionary))
        self.view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:[username][handle]-smallPadding-[userDesc]", options: [NSLayoutFormatOptions.AlignAllLeading, NSLayoutFormatOptions.AlignAllTrailing], metrics: metrics, views: viewsDictionary))
        self.view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|-largePadding-[postedByLabel]-largePadding-|", options: [], metrics: metrics, views: viewsDictionary))
        self.view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:[userDesc]-[followBtn(actionButtonHeight)]-largePadding-|", options: NSLayoutFormatOptions.AlignAllLeading, metrics: metrics, views: viewsDictionary))
        self.view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:[followBtn(actionButtonWidth)]", options: NSLayoutFormatOptions.AlignAllLeading, metrics: metrics, views: viewsDictionary))
        self.view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:[likeBtn(actionButtonWidth)]-largePadding-[commentBtn(==likeBtn)]-largePadding-[shareBtn(==likeBtn)]-largePadding-|", options: .AlignAllCenterY, metrics: metrics, views: viewsDictionary))
        self.view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:[likesCount]-largePadding-[commentCount]", options: .AlignAllCenterY, metrics: metrics, views: viewsDictionary))
        self.view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|-largePadding-[userImage(userImageWidth)]-largePadding-[username]-largePadding-|", options: [], metrics: metrics, views: viewsDictionary))
        self.view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:[userImage(userImageWidth)]", options: [], metrics: metrics, views: viewsDictionary))
        
        
        self.view.addConstraint(NSLayoutConstraint(item: username, attribute: NSLayoutAttribute.Top, relatedBy: NSLayoutRelation.Equal, toItem: userImage, attribute: NSLayoutAttribute.Top, multiplier: 1.0, constant: 0))
//        self.view.addConstraint(NSLayoutConstraint(item: storyTitle, attribute: NSLayoutAttribute.Leading, relatedBy: NSLayoutRelation.Equal, toItem: storyDesc, attribute: NSLayoutAttribute.Leading, multiplier: 1.0, constant: 0))
//        self.view.addConstraint(NSLayoutConstraint(item: storyTitle, attribute: NSLayoutAttribute.Trailing, relatedBy: NSLayoutRelation.Equal, toItem: storyDesc, attribute: NSLayoutAttribute.Trailing, multiplier: 1.0, constant: 0))
//        self.view.addConstraint(NSLayoutConstraint(item: storyDesc, attribute: NSLayoutAttribute.Leading, relatedBy: NSLayoutRelation.Equal, toItem: likesCount, attribute: NSLayoutAttribute.Leading, multiplier: 1.0, constant: 0))
    }
    
    func setupViews() {
        self.view.addSubview(detailScrollView)
        self.detailScrollView.addSubview(detailContainerView)
        self.detailContainerView.addSubview(storyImage)
        self.detailContainerView.addSubview(storyTitle)
        self.detailContainerView.addSubview(storyDesc)
        self.detailContainerView.addSubview(storyDate)
        self.detailContainerView.addSubview(likeBtn)
        self.detailContainerView.addSubview(commentBtn)
        self.detailContainerView.addSubview(shareBtn)
        self.detailContainerView.addSubview(likesCount)
        self.detailContainerView.addSubview(commentCount)
        self.detailContainerView.addSubview(bottomBorder)
        self.detailContainerView.addSubview(postedByLabel)
        self.detailContainerView.addSubview(userImage)
        self.detailContainerView.addSubview(username)
        self.detailContainerView.addSubview(handle)
        self.detailContainerView.addSubview(userDesc)
        self.detailContainerView.addSubview(followBtn)
    }
    
    func makeNavBarTransparent() {
        let navBar = self.navigationController?.navigationBar
        navBar?.setBackgroundImage(UIImage(), forBarMetrics: UIBarMetrics.Default)
        navBar?.shadowImage = UIImage()
        navBar?.translucent = true
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        makeNavBarTransparent()
    }
    
    func setFollowState() {
        if user.getIsFollowing() {
            followBtn.layer.borderColor = _followingBtnBackgroundColor.CGColor
            followBtn.backgroundColor = _followingBtnBackgroundColor
            followBtn.setImage(_followingImage, forState: .Normal)
        }
        else {
            followBtn.layer.borderColor = _followBtnColor.CGColor
            followBtn.backgroundColor = _followBtnBackgorundColor
            followBtn.setImage(_followImage, forState: .Normal)
        }
    }
    
    func toggleFollowState() {
        user.isFollowing = !user.getIsFollowing()
        setFollowState()
        
        NSNotificationCenter.defaultCenter().postNotificationName(SYNC_FOLLOW_STATE_NOTIFICATION, object: nil, userInfo: ["user": self.user])
    }
    
    func setLikeState() {
        if (story.getLikeFlag()) {
            likeBtn.setImage(_likeImageFill, forState: .Normal)
        }
        else {
            likeBtn.setImage(_likeImageEmpty, forState: .Normal)
        }
    }
    
    func toggleLikeState(sender: UIButton) {
        story.likeFlag = !story.getLikeFlag()
        
        if story.getLikeFlag() {
            story.likesCount! += 1
        }
        else {
            story.likesCount! -= 1
        }
        
        setLikeState()
        likesCount.text = story.getLikesCount().description + " Likes"
        delegate?.setLikeStateFromDetailController(storyIndex!, story: story)
    }
    
    func shareStory(sender: UIButton) {
        CommonFunctions.nativeShare(self, story: story, sender: sender)
    }
    
    func loadDataInViews() {
        userImage.sd_setImageWithURL(NSURL(string: user.getImage()), placeholderImage: _placeholder)
        storyTitle.text = story.getTitle()
        storyDesc.text = story.getStoryDesc()
        storyDate.text = story.getVerb()
        likesCount.text = story.getLikesCount().description + " Likes"
        commentCount.text = story.getCommentCount().description + " Comments"
        setLikeState()
        setFollowState()
        
        username.text = user.getUsername()
        handle.text = user.getHandle()
        userDesc.text = user.getAbout()
        
        storyImage.sd_setImageWithURL(NSURL(string: story.getSi()), placeholderImage: _placeholder) {
            (image, error, SDImageCacheType, url) in
            if image != nil {
                /*
                 Image scaled to device width in background and assigned to story imageView
                 when the task is completed
                 */
                dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), {
                    let scaledImage = CommonFunctions.scaleImageToWidth(image)
                    dispatch_async(dispatch_get_main_queue(), {
                        self.storyImage.contentMode = .Top
                        self.storyImage.image = scaledImage
                    })
                })
            }
        }
        
        likeBtn.addTarget(self, action: #selector(StoryDetailController.toggleLikeState(_:)), forControlEvents: .TouchUpInside)
        followBtn.addTarget(self, action: #selector(StoryDetailController.toggleFollowState), forControlEvents: .TouchUpInside)
        shareBtn.addTarget(self, action: #selector(StoryDetailController.shareStory(_:)), forControlEvents: .TouchUpInside)
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor.whiteColor()
        setupViews()
        setupConstraints()
        loadDataInViews()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}
