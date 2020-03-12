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
       // photoSliderView.configure(with: (self.events_object?.getGallery)!)
    }

}
