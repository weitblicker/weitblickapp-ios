//
//  TNImageSliderViewController.swift
//
//  Created by Frederik Jacques on 20/06/15.
//  Copyright (c) 2015 Frederik Jacques. All rights reserved.
//

import UIKit

public protocol TNImageSliderViewControllerDelegate:class {
    
    func imageSlider( imageSlider:TNImageSliderViewController, didScrollToPage pageNumber:Int )
    
}

public struct TNImageSliderViewOptions {
    
    public var scrollDirection:UICollectionView.ScrollDirection
    public var backgroundColor:UIColor
    public var pageControlHidden:Bool
    public var pageControlCurrentIndicatorTintColor:UIColor
    public var autoSlideIntervalInSeconds:TimeInterval
    public var shouldStartFromBeginning:Bool
    public var imageContentMode:UIView.ContentMode
    
    public init(){
        
        self.scrollDirection = UICollectionView.ScrollDirection.horizontal
        self.backgroundColor = UIColor.black
        self.pageControlHidden = false
        self.pageControlCurrentIndicatorTintColor = UIColor.white
        self.autoSlideIntervalInSeconds = 0
        self.shouldStartFromBeginning = false
        self.imageContentMode = .scaleToFill
        
    }
    
    public init( scrollDirection:UICollectionView.ScrollDirection, backgroundColor:UIColor, pageControlHidden:Bool, pageControlCurrentIndicatorTintColor:UIColor, imageContentMode:UIView.ContentMode){
        
        self.scrollDirection = scrollDirection
        self.backgroundColor = backgroundColor
        self.pageControlHidden = pageControlHidden
        self.pageControlCurrentIndicatorTintColor = pageControlCurrentIndicatorTintColor
        self.autoSlideIntervalInSeconds = 0
        self.shouldStartFromBeginning = false
        self.imageContentMode = imageContentMode
        
    }
}

public class TNImageSliderViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        <#code#>
    }
    

    // MARK: - IBOutlets
    
    // MARK: - Properties
    public weak var delegate:TNImageSliderViewControllerDelegate?
    
    var collectionView:UICollectionView!
    var collectionViewLayout:UICollectionViewFlowLayout {
    
        get {
            
            return collectionView.collectionViewLayout as! UICollectionViewFlowLayout
            
        }
        
    }
    
    var pageControl:UIPageControl!
    
    public var options:TNImageSliderViewOptions! {
    
        didSet {
            
            if let collectionView = collectionView, let pageControl = pageControl {
            
                collectionViewLayout.scrollDirection = options.scrollDirection
                
                collectionView.collectionViewLayout = collectionViewLayout
                collectionView.backgroundColor = options.backgroundColor
                pageControl.isHidden = options.pageControlHidden
                pageControl.currentPageIndicatorTintColor = options.pageControlCurrentIndicatorTintColor
                
                setupAutoSliderIfNeeded()
                
            }
            
        }
        
    }
    
    public var images:[UIImage]! {
        
        didSet {
            
            collectionView.reloadData()
            
            pageControl.numberOfPages = images.count
        }
        
    }
    
    var currentPage:Int {
        
        get {
            
            switch( collectionViewLayout.scrollDirection ) {
                
            case .horizontal:
                    return Int((collectionView.contentOffset.x / collectionView.contentSize.width) * CGFloat(images.count))
                
            case .vertical:
                    return Int((collectionView.contentOffset.y / collectionView.contentSize.height) * CGFloat(images.count))
                
            case .vertical:
                <#code#>
            case .horizontal:
                <#code#>
            @unknown default:
                <#code#>
            }
            
        }
        
    }
    
    // MARK: - Initializers methods
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        
    }

    required public init?(coder aDecoder: NSCoder) {
        
        super.init(coder: aDecoder)
        
    }
    
    // MARK: - Lifecycle methods
    public override func viewDidLoad() {
        
        super.viewDidLoad()
        
        options = TNImageSliderViewOptions()
        
        setupCollectionView()
        setupPageControl()
        
    }
    
    public override func didReceiveMemoryWarning() {
        
        super.didReceiveMemoryWarning()
        
    }
    
    public override func viewWillTransitionToSize(size: CGSize, withTransitionCoordinator coordinator: UIViewControllerTransitionCoordinator) {
        
        super.viewWillTransitionToSize(size, withTransitionCoordinator: coordinator)
        
        // Calculate current page to update the content offset to the correct position when the orientation changes
        // I take a copy of the currentPage variable, as it will be incorrectly calculated once we are in the animateAlongsideTransition block
        // Because the contentSize will already be changed to reflect the new orientation
        let theCurrentPage = Int(currentPage)
        
        coordinator.animate(alongsideTransition: { (context) -> Void in
            
            let contentOffSet:CGPoint
            
            switch( self.collectionViewLayout.scrollDirection ) {
                
            case .horizontal:
                
                contentOffSet = CGPoint(x: Int(self.collectionView.bounds.size.width) * theCurrentPage, y: 0)
                
            case .vertical:
                
                contentOffSet = CGPoint(x: 0, y: Int(self.collectionView.bounds.size.height) * self.currentPage)
                
            case .vertical:
                <#code#>
            case .horizontal:
                <#code#>
            @unknown default:
                <#code#>
            }
            
            self.collectionView.contentOffset = contentOffSet
            
            }, completion: { (context) -> Void in
                
        })
        
        self.collectionView.collectionViewLayout.invalidateLayout()
        
    }
    
    // MARK: - Private methods
    private func setupCollectionView(){
    
        let layout = UICollectionViewFlowLayout()

        layout.scrollDirection = options.scrollDirection
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        
        collectionView = UICollectionView(frame: CGRectZero, collectionViewLayout:layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.isPagingEnabled = true
        
        let bundle = Bundle(for: TNImageSliderViewController.classForCoder())
        let nib = UINib(nibName: "TNImageSliderCollectionViewCell", bundle: bundle)
        
        collectionView.register(nib, forCellWithReuseIdentifier: "TNImageCell")
        collectionView.backgroundColor = options.backgroundColor
        collectionView.delegate = self
        collectionView.dataSource = self
        view.addSubview(collectionView)
    
        let horizontalConstraints = NSLayoutConstraint.constraints(withVisualFormat: "H:|[collectionView]|", options: [], metrics: nil, views: ["collectionView":collectionView])
        let verticalConstraints = NSLayoutConstraint.constraints(withVisualFormat: "V:|[collectionView]|", options: [], metrics: nil, views: ["collectionView":collectionView ?? <#default value#>])
        
        view.addConstraints(horizontalConstraints)
        view.addConstraints(verticalConstraints)
        
    }
    
    private func setupPageControl() {
        
        pageControl = UIPageControl()
        pageControl.translatesAutoresizingMaskIntoConstraints = false
        
        pageControl.currentPage = 0
        pageControl.currentPageIndicatorTintColor = options.pageControlCurrentIndicatorTintColor
    
        pageControl.isHidden = options.pageControlHidden
        view.addSubview(pageControl)
        
        let centerXConstraint = NSLayoutConstraint(item: pageControl,
                                                   attribute: NSLayoutConstraint.Attribute.centerX,
                                                   relatedBy: NSLayoutConstraint.Relation.equal,
            toItem: view,
            attribute: NSLayoutConstraint.Attribute.centerX,
            multiplier: 1.0,
            constant: 0)
        
        let bottomConstraint = NSLayoutConstraint(item: pageControl,
                                                  attribute: NSLayoutConstraint.Attribute.bottom,
                                                  relatedBy: NSLayoutConstraint.Relation.equal,
            toItem: view,
            attribute: NSLayoutConstraint.Attribute.bottom,
            multiplier: 1.0,
            constant: -5)
        
        view.addConstraints([centerXConstraint, bottomConstraint])
        
    }
    
    private func setupAutoSliderIfNeeded() {
        
        if options.autoSlideIntervalInSeconds > 0 {
            Timer.scheduledTimerWithTimeInterval(options.autoSlideIntervalInSeconds, target: self, selector: #selector(TNImageSliderViewController.timerDidFire(_:)), userInfo: nil, repeats: true)
        }
        
    }
    
    func timerDidFire(timer: Timer) {
        
        let theNextPage = currentPage + 1
        var contentOffSet = CGPointZero
        
        if theNextPage < images.count {
            switch( self.collectionViewLayout.scrollDirection ) {
                
            case .horizontal:
                
                contentOffSet = CGPoint(x: Int(self.collectionView.bounds.size.width) * theNextPage, y: 0)
                
            case .vertical:
                
                contentOffSet = CGPoint(x: 0, y: Int(self.collectionView.bounds.size.height) * theNextPage)
                
            case .vertical:
                <#code#>
            case .horizontal:
                <#code#>
            @unknown default:
                <#code#>
            }
        }
        
        if options.shouldStartFromBeginning || contentOffSet != CGPointZero {
            collectionView.setContentOffset(contentOffSet, animated: true)
        } else {
            timer.invalidate()
        }
    }
    
    // MARK: - Public methods
    
    // MARK: - Getter & setter methods
    
    // MARK: - IBActions
    
    // MARK: - Target-Action methods
    
    // MARK: - Notification handler methods
    
    // MARK: - Datasource methods
    // MARK: UICollectionViewDataSource methods
    public func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
    
        return 1
        
    }
    
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    
        if let images = images {
        
            return images.count
            
        }
        
        return 0
        
    }
    
    public func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TNImageCell", for: indexPath as IndexPath) as! TNImageSliderCollectionViewCell
        
        cell.imageView.image = images[indexPath.row]
        cell.imageView.contentMode = options.imageContentMode
        
        return cell
        
    }
    
    public func collectionView( collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        
        return collectionView.bounds.size
        
    }
    
    // MARK: - Delegate methods
    // MARK: UICollectionViewDelegate methods
    public func scrollViewDidEndDecelerating(scrollView: UIScrollView) {
        
        // If the scroll animation ended, update the page control to reflect the current page we are on
        pageControl.currentPage = currentPage
        
        self.delegate?.imageSlider(imageSlider: self, didScrollToPage: currentPage)
        
    }
    
    public func scrollViewDidEndScrollingAnimation(scrollView: UIScrollView) {
        
        // Called when manually setting contentOffset
        scrollViewDidEndDecelerating(scrollView: scrollView)
        
    }
}
