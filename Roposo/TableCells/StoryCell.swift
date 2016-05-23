//
//  StoryCell.swift
//  Roposo
//
//  Created by starapps on 20/05/16.
//  Copyright © 2016 private. All rights reserved.
//

import UIKit
import UIImageViewAlignedSwift

protocol StoryCellDelegate: class {
    func shareStory(index: Int, sender: UIButton)
    func setLikeStateFromStoryCell(index: Int, story: Story)
}

class StoryCell: UITableViewCell {
    
    // Variables
    var user = User()
    var story = Story()
    weak var delegate: StoryCellDelegate?
    
    // Views
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
        label.lineBreakMode = .ByTruncatingTail
        label.numberOfLines = 2
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    var handle: UILabel = {
        let label = UILabel()
        label.font = _subtitleFont
        label.textColor = _subtitleColor
        label.numberOfLines = 1
        label.lineBreakMode = .ByTruncatingTail
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    var storyImage: UIImageViewAligned = {
        let imageView = UIImageViewAligned()
        imageView.backgroundColor = _bottomBorderColor
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .ScaleAspectFill
        imageView.alignment = UIImageViewAlignmentMask.Top
        imageView.clipsToBounds = true
        return imageView
    }()
    
    var storyTitle: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 1
        label.lineBreakMode = .ByTruncatingTail
        label.font = _titleFont
        label.textAlignment = .Left
        return label
    }()
    
    var storyDesc: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 3
        label.textColor = _subtitleColor
        label.lineBreakMode = .ByTruncatingTail
        label.font = _subtitleFont
        label.textAlignment = .Left
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
    
    // Function to sync follow state if it is modified in any other cell
    func syncFollowState(notification: NSNotification) {
        let userInfo: Dictionary<String, AnyObject> = notification.userInfo as! Dictionary<String, AnyObject>
        let userObject = userInfo["user"] as! User
        if userObject.getId() == user.getId() {
            self.user = userObject
            setFollowState()
        }
    }
    
    // Function called when followBtn is tapped
    func toggleFollowState() {
        user.isFollowing = !user.getIsFollowing()
        setFollowState()
        
        // Notification sent to all observers to update their follow status
        NSNotificationCenter.defaultCenter().postNotificationName(SYNC_FOLLOW_STATE_NOTIFICATION, object: nil, userInfo: ["user": self.user])
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
    
    // Function called when likeBtn is tapped
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
        delegate?.setLikeStateFromStoryCell(sender.tag, story: story)
    }
    
    func setLikeState() {
        if (story.getLikeFlag()) {
            self.likeBtn.setImage(_likeImageFill, forState: .Normal)
        }
        else {
            self.likeBtn.setImage(_likeImageEmpty, forState: .Normal)
        }
    }
    
    // Send share story message to ViewController
    func shareStory(sender: UIButton) {
        delegate?.shareStory(sender.tag, sender: sender)
    }
    
    func configureStoryCell(index: Int, story: Story, user: User) {
        self.story = story
        self.user = user
        
        self.userImage.sd_setImageWithURL(NSURL(string: user.getImage()), placeholderImage: _placeholder)
        self.username.text = user.getUsername()
        self.handle.text = user.getHandle()
        self.storyTitle.text = story.getTitle()
        self.storyDesc.text = story.getStoryDesc()
        self.storyImage.sd_setImageWithURL(NSURL(string: story.getSi()), placeholderImage: _placeholder)
        self.likeBtn.setTitle(story.getLikesCount().description, forState: .Normal)
        self.commentBtn.setTitle(story.getCommentCount().description, forState: .Normal)
        self.likesCount.text = story.getLikesCount().description + " Likes"
        self.commentCount.text = story.getCommentCount().description + " Comments"
        
        setLikeState()
        setFollowState()
        
        self.likeBtn.tag = index
        self.shareBtn.tag = index
        
        // Add targets to like and share buttons
        self.likeBtn.addTarget(self, action: #selector(StoryCell.toggleLikeState(_:)), forControlEvents: .TouchUpInside)
        self.shareBtn.addTarget(self, action: #selector(StoryCell.shareStory(_:)), forControlEvents: .TouchUpInside)
        self.followBtn.addTarget(self, action: #selector(StoryCell.toggleFollowState), forControlEvents: .TouchUpInside)
    }
    
    func setupConstraints() {
        // Setup metrics dictionary
        let metrics = [
            "storyImageHeight": CommonFunctions.getStoryImageHeight(),
            "userImageWidth": Constants.USERIMAGE_WIDTH,
            "actionButtonWidth": Constants.ACTION_BUTTON_WIDTH,
            "actionButtonHeight": Constants.ACTION_BUTTON_HEIGHT,
            "bottomBorderHeight": Constants.BOTTOM_BORDER_HEIGHT,
            "smallPadding": Constants.SMALL_PADDING,
            "largePadding": Constants.LARGE_PADDING
        ]
        
        // Setup views dictionary
        let viewsDictionary = [
            "userImage": userImage,
            "username": username,
            "handle": handle,
            "followBtn": followBtn,
            "storyImage": storyImage,
            "storyTitle": storyTitle,
            "storyDesc": storyDesc,
            "likeBtn": likeBtn,
            "commentBtn": commentBtn,
            "shareBtn": shareBtn,
            "likesCount": likesCount,
            "commentCount": commentCount,
            "bottomBorder": bottomBorder
        ]
        
        self.contentView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|-largePadding-[userImage(userImageWidth)]-largePadding-[storyImage(storyImageHeight)]-smallPadding-[storyTitle]-smallPadding-[storyDesc]->=smallPadding-[likesCount][likeBtn(actionButtonHeight)]-smallPadding-[bottomBorder(bottomBorderHeight)]|", options: [], metrics: metrics, views: viewsDictionary))
        self.contentView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|[bottomBorder]|", options: [], metrics: nil, views: viewsDictionary))
        self.contentView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:[followBtn(actionButtonHeight)]", options: [], metrics: metrics, views: viewsDictionary))
        self.contentView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|[storyImage]|", options: [], metrics: nil, views: viewsDictionary))
        self.contentView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|-largePadding-[userImage(userImageWidth)]-largePadding-[username]-[followBtn(actionButtonWidth)]-largePadding-|", options: [], metrics: metrics, views: viewsDictionary))
        self.contentView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|-largePadding-[username][handle]", options: [], metrics: metrics, views: viewsDictionary))
        self.contentView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:[likeBtn(actionButtonWidth)]-largePadding-[commentBtn(==likeBtn)]-largePadding-[shareBtn(==likeBtn)]-largePadding-|", options: .AlignAllCenterY , metrics: metrics, views: viewsDictionary))
        self.contentView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|-largePadding-[storyTitle]-largePadding-|", options: [], metrics: metrics, views: viewsDictionary))
        self.contentView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|-largePadding-[likesCount]-largePadding-[commentCount]", options: .AlignAllCenterY, metrics: metrics, views: viewsDictionary))
        
        self.contentView.addConstraint(NSLayoutConstraint(item: userImage, attribute: .CenterY, relatedBy: .Equal, toItem: followBtn, attribute: .CenterY, multiplier: 1.0, constant: 0))
        self.contentView.addConstraint(NSLayoutConstraint(item: storyTitle, attribute: NSLayoutAttribute.Leading, relatedBy: NSLayoutRelation.Equal, toItem: storyDesc, attribute: NSLayoutAttribute.Leading, multiplier: 1.0, constant: 0))
        self.contentView.addConstraint(NSLayoutConstraint(item: storyTitle, attribute: NSLayoutAttribute.Trailing, relatedBy: NSLayoutRelation.Equal, toItem: storyDesc, attribute: NSLayoutAttribute.Trailing, multiplier: 1.0, constant: 0))
        self.contentView.addConstraint(NSLayoutConstraint(item: username, attribute: .Leading, relatedBy: .Equal, toItem: handle, attribute: .Leading, multiplier: 1.0, constant: 0))
    }
    
    func setupViews() {
        self.contentView.addSubview(userImage)
        self.contentView.addSubview(username)
        self.contentView.addSubview(handle)
        self.contentView.addSubview(followBtn)
        self.contentView.addSubview(storyImage)
        self.contentView.addSubview(storyTitle)
        self.contentView.addSubview(storyDesc)
        self.contentView.addSubview(likeBtn)
        self.contentView.addSubview(commentBtn)
        self.contentView.addSubview(shareBtn)
        self.contentView.addSubview(likesCount)
        self.contentView.addSubview(commentCount)
        self.contentView.addSubview(bottomBorder)
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        // Register for syncing follow state notification
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(StoryCell.syncFollowState(_:)), name: SYNC_FOLLOW_STATE_NOTIFICATION, object: nil)
        
        setupViews()
        setupConstraints()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
