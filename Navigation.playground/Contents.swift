//: A UIKit based Playground for presenting user interface
  
import UIKit
import PlaygroundSupport

class MyViewController : UINavigationController {
    var image = UIImageView()

    override func viewDidLoad() {
        super.viewDidLoad()
        let logo = UIImage(named: "/Users/einmi218/Documents/GitHub/weitblickapp-ios/Weitblick/Weitblick/Assets.xcassets/Weitblick.imageset/Weitblick.png")
        let imageView = UIImageView(image:logo)
        self.navigationItem.titleView = imageView
    }
}
// Present the view controller in the Live View window
PlaygroundPage.current.liveView = MyViewController()
