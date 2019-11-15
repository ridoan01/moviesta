//
//  ViewController.swift
//  Moviesta
//
//  Created by Ridoan Wibisono on 31/10/19.
//  Copyright © 2019 Ridoan Wibisono. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    var movie = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
       
    }

    @IBAction func gotodetail(_ sender: Any) {
        
        
//        let movieDetailsVC = MovieDetailViewController()
//        movieDetailsVC.movie_id = movie
//        let navController = UINavigationController(rootViewController: movieDetailsVC)
//        navController.modalPresentationStyle = .fullScreen
//        present(navController, animated: true, completion: nil)
        
         movie = 346
        performSegue(withIdentifier: "goDetail", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
       let destVC : MovieDetailViewController = segue.destination as! MovieDetailViewController
       destVC.movie_id = movie
    }
    
}

//import UIKit

// From http://stackoverflow.com/questions/21167226/resizing-a-uilabel-to-accomodate-insets/21267507#21267507

@IBDesignable
class EdgeInsetLabel: UILabel {
    var textInsets = UIEdgeInsets.zero {
        didSet { invalidateIntrinsicContentSize() }
    }

    override func textRect(forBounds bounds: CGRect, limitedToNumberOfLines numberOfLines: Int) -> CGRect {
        let insetRect = bounds.inset(by: textInsets)
        let textRect = super.textRect(forBounds: insetRect, limitedToNumberOfLines: numberOfLines)
        let invertedInsets = UIEdgeInsets(top: -textInsets.top,
                left: -textInsets.left,
                bottom: -textInsets.bottom,
                right: -textInsets.right)
        return textRect.inset(by: invertedInsets)
    }

    override func drawText(in rect: CGRect) {
        super.drawText(in: rect.inset(by: textInsets))
    }
}

extension EdgeInsetLabel {
    @IBInspectable
    var leftTextInset: CGFloat {
        set { textInsets.left = newValue }
        get { return textInsets.left }
    }

    @IBInspectable
    var rightTextInset: CGFloat {
        set { textInsets.right = newValue }
        get { return textInsets.right }
    }

    @IBInspectable
    var topTextInset: CGFloat {
        set { textInsets.top = newValue }
        get { return textInsets.top }
    }

    @IBInspectable
    var bottomTextInset: CGFloat {
        set { textInsets.bottom = newValue }
        get { return textInsets.bottom }
    }
}
