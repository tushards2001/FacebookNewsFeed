//
//  ViewController.swift
//  FacebookNewsFeed
//
//  Created by MacBookPro on 1/15/18.
//  Copyright © 2018 basicdas. All rights reserved.
//

import UIKit

class Post {
    var name: String?
    var statusText: String?
    var profileImageName: String?
    var statusImageName: String?
    var statusImageUrl: String?
    var numLikes: Int?
    var numComments: Int?
}

class FeedController: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    
    let cellId = "cellId"
    
    var posts = [Post]()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        // cache
        let memoryCapacity = 500 * 1024 * 1024
        let diskCapacity = 500 * 1024 * 1024
        let urlCache = URLCache(memoryCapacity: memoryCapacity, diskCapacity: diskCapacity, diskPath: "myDiskPath")
        URLCache.shared = urlCache
        
        let postMark = Post()
        postMark.name = "Mark Zuckerberg"
        postMark.statusText = "Meanwhile, beast turned to the dark side"
        postMark.profileImageName = "zuck_image"
        postMark.statusImageName = "zuckdog"
        postMark.numLikes = 23
        postMark.numComments = 5
        postMark.statusImageUrl = "https://www.techworm.net/wp-content/uploads/2017/02/facebookmarl.jpg"
        posts.append(postMark)
        
        let postSteve = Post()
        postSteve.name = "Steve Jobs"
        postSteve.statusText = "Being the richest man in the cemetery doesn't matter to me. Going to bed at night saying we've done something wonderful, that's what matters to me."
        postSteve.profileImageName = "stevejobs"
        postSteve.statusImageName = "sj_post"
        postSteve.numLikes = 567
        postSteve.numComments = 34
        postSteve.statusImageUrl = "https://www.billboard.com/files/media/Steve-Jobs-2007-iphone-billboard-1548.jpg"
        posts.append(postSteve)
        
        let postGandhi = Post()
        postGandhi.name = "Mahatma Gandhi"
        postGandhi.statusText = "You must not lose faith in humanity. Humanity is an ocean; if a few drops of the ocean are dirty, the ocean does not become dirty. Strength does not come from physical capacity. It comes from an indomitable will. The weak can never forgive. Forgiveness is the attribute of the strong."
        postGandhi.profileImageName = "gandhi"
        postGandhi.statusImageName = "mg_post"
        postGandhi.numLikes = 13045
        postGandhi.numComments = 456
        postGandhi.statusImageUrl = "https://i.ndtvimg.com/i/2017-10/mahatma-gandhi_650x400_81506923735.jpg"
        posts.append(postGandhi)
        
        collectionView?.backgroundColor = UIColor(white: 0.95, alpha: 1)
        collectionView?.alwaysBounceVertical = true
        navigationItem.title = "Facebook Feed"
        
        collectionView?.register(FeedCell.self, forCellWithReuseIdentifier: cellId)
    }

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return posts.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let feedCell =  collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! FeedCell
        
        feedCell.post = posts[indexPath.row]
        feedCell.feedController = self
        return feedCell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if let statusText = posts[indexPath.row].statusText {
            let size = CGSize(width: view.frame.width, height: 1000)
            let rect = NSString(string: statusText).boundingRect(with: size, options: NSStringDrawingOptions.usesFontLeading.union(NSStringDrawingOptions.usesLineFragmentOrigin), attributes: [NSAttributedStringKey.font: UIFont.systemFont(ofSize: 14)], context: nil)
            
            let knownHeight: CGFloat = 8 + 44 + 4 + 4 + 200 + 8 + 24 + 8 + 44
            
            return CGSize(width: view.frame.width, height: rect.height + knownHeight + 24)
        }
        return CGSize(width: view.frame.width, height: 500)
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        collectionView?.collectionViewLayout.invalidateLayout()
    }
    
    let zoomView = UIImageView()
    let navBarCoverView = UIView()
    let tabBarCoverView = UIView()
    let blackBackgroundView = UIView()
    
    var statusImageView: UIImageView?
    
    func animateImageView(statusImageView: UIImageView) {
        self.statusImageView = statusImageView
        
        if let startingFrame = statusImageView.superview?.convert(statusImageView.frame, to: nil) {
            
            statusImageView.alpha = 0
            
            blackBackgroundView.frame = self.view.frame
            blackBackgroundView.backgroundColor = UIColor.black
            blackBackgroundView.alpha = 0
            view.addSubview(blackBackgroundView)
            
            navBarCoverView.frame = CGRect(x: 0, y: 0, width: 1000, height: 20 + 44)
            navBarCoverView.backgroundColor = UIColor.black
            navBarCoverView.alpha = 0
            
            
            if let keyWindow = UIApplication.shared.keyWindow {
                keyWindow.addSubview(navBarCoverView)
                
                tabBarCoverView.frame = CGRect(x: 0, y: keyWindow.frame.height - 49, width: 1000, height: 49)
                tabBarCoverView.backgroundColor = UIColor.black
                tabBarCoverView.alpha = 0
                
                keyWindow.addSubview(tabBarCoverView)
            }
            
            zoomView.backgroundColor = UIColor.red
            zoomView.image = statusImageView.image
            zoomView.contentMode = .scaleAspectFill
            zoomView.isUserInteractionEnabled = true
            zoomView.frame = startingFrame
            zoomView.clipsToBounds = true
            self.view.addSubview(zoomView)
            
            zoomView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(zoomOut)))
            
            UIView.animate(withDuration: 0.3, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 0.5, options: .curveEaseOut, animations: {
                let height = (self.view.frame.width / startingFrame.width) * startingFrame.height
                let y = self.view.frame.height / 2 - height / 2
                
                self.zoomView.frame = CGRect(x: 0, y: y, width: self.view.frame.width, height: height)
                self.blackBackgroundView.alpha = 1
                self.navBarCoverView.alpha = 1
                self.tabBarCoverView.alpha = 1
            }, completion: nil)
        }
        
    }
    
    @objc func zoomOut() {
        if let startingFrame = self.statusImageView!.superview?.convert(self.statusImageView!.frame, to: nil) {
            UIView.animate(withDuration: 0.3, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 0.5, options: .curveEaseOut, animations: {
                self.zoomView.frame = startingFrame
                self.blackBackgroundView.alpha = 0
                self.navBarCoverView.alpha = 0
                self.tabBarCoverView.alpha = 0
            }, completion: { (complete) in
                self.zoomView.removeFromSuperview()
                self.blackBackgroundView.removeFromSuperview()
                self.navBarCoverView.removeFromSuperview()
                self.tabBarCoverView.removeFromSuperview()
                self.statusImageView?.alpha = 1
            })
        }
    }

}


extension UIColor {
    static func rgb(red: CGFloat, greeen: CGFloat, blue: CGFloat) -> UIColor {
        return UIColor(red: red/255, green: greeen/255, blue: blue/255, alpha: 1)
    }
}

extension UIView {
    func addConstraintsWithFormat(format: String, views: UIView...) {
        var viewsDictionary = [String: UIView]()
        
        for (index, view) in views.enumerated() {
            let key = "v\(index)"
            viewsDictionary[key] = view
            view.translatesAutoresizingMaskIntoConstraints = false
        }
        
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: format, options: NSLayoutFormatOptions(), metrics: nil, views: viewsDictionary))
    }
}

