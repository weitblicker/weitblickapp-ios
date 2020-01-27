//
//  EventsDetailViewController.swift
//  Weitblick
//
//  Created by Jana  on 27.01.20.
//  Copyright © 2020 HS Osnabrueck. All rights reserved.
//

import UIKit

class EventsDetailViewController: UIViewController {

    @IBOutlet weak var photoSliderView: PhotoSliderView!
    override func viewDidLoad() {
        super.viewDidLoad()

        photoSliderView.configure(with: (self.events_object?.getGallery)!)
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
