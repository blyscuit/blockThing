//
//  StageSelectViewController.swift
//  BlockThing
//
//  Created by Bliss Watchaye on 2015-11-10.
//  Copyright © 2015 confusians. All rights reserved.
//

import UIKit

@objc protocol StageSelectControllerDelegate {
    func stageDidChoose(i:Int)
}
class StageSelectViewController: UIViewController {
    var delegate:StageSelectControllerDelegate?
}
