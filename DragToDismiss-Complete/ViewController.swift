//
//  ViewController.swift
//  EasyAnimatedTransition
//
//  Created by Alex Gibson on 3/29/17.
//  Copyright © 2017 AG. All rights reserved.
//

import UIKit

class ViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    
    var images = ["flower","flower2","flower3","flower4","flower5","flower6"]
    var animator = Animator()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.estimatedRowHeight = 120.0
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.delegate = self
        tableView.dataSource = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return images.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "postCell", for: indexPath) as? FeedTableViewCell{
            cell.imgView.image = UIImage(named: images[indexPath.row])
            return cell
        }
        //should never execute
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let cell = tableView.cellForRow(at: indexPath) as? FeedTableViewCell{
            let image = cell.imgView.image
            self.performSegue(withIdentifier: "_toImageDetail", sender: image)
            animator.cellImageView = cell.imgView
        }
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
        
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "_toImageDetail"{
            guard let dvc = segue.destination as? ImageDetailViewController else{return}
            dvc.image = sender as? UIImage
            dvc.transitioningDelegate = animator
            dvc.modalPresentationStyle = .overCurrentContext
        }
    }
    
    
}

