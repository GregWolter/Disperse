//
//  ViewController.swift
//  Disperse
//
//  Created by Tim Gegg-Harrison, Nicole Anderson on 12/20/13.
//  Copyright © 2013 TiNi Apps. All rights reserved.
//
//  Modified by Greg Wolter on 9/27/20.
//

import UIKit

class ViewController: UIViewController {

    private let MAXCARDS: Int = 10
    private let CARDS: [String] = ["AC", "AD", "AH", "AS"]
    private let BLUE: UIColor = UIColor(red: 0.0, green: 0.0, blue: 0.609375, alpha: 1.0)
    private let RED: UIColor = UIColor(red: 0.733333, green: 0.0, blue: 0.0, alpha: 1.0)
    private let suits: [UIImageView] = [UIImageView(), UIImageView(), UIImageView(), UIImageView()]
    private let buttons: [UIButton] = [UIButton(), UIButton()]
    private let playButton: UIImageView = UIImageView()
    private let game: GameState = GameState()
    private var startingPoint: CGPoint = CGPoint(x:0, y:0)
    private var cardSuitsRemaining = Set<UIImageView>()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Lab 1 code goes here
        // create frame for each index of suits array
        suits[0].frame = CGRect(x: (view.frame.width * 0.2) - (view.frame.width/18), y: 80, width: view.frame.width/9, height: view.frame.width/9)
        suits[1].frame = CGRect(x: (view.frame.width * 0.4) - (view.frame.width/18), y:80, width: view.frame.width/9, height: view.frame.width/9)
        suits[2].frame = CGRect(x: (view.frame.width * 0.6) - (view.frame.width/18), y:80, width: view.frame.width/9, height: view.frame.width/9)
        suits[3].frame = CGRect(x: (view.frame.width * 0.8) - (view.frame.width/18), y:80, width: view.frame.width/9, height: view.frame.width/9)
        
        // set image of each index of suit array
        suits[0].image = UIImage(named: "club")
        suits[1].image = UIImage(named: "diamond")
        suits[2].image = UIImage(named: "heart")
        suits[3].image = UIImage(named: "spade")
        
        // add image to view of each index of suit array
        view.addSubview(suits[0])
        view.addSubview(suits[1])
        view.addSubview(suits[2])
        view.addSubview(suits[3])
        
        // adds the suits to the cardSuitsRemaining set
        cardSuitsRemaining.insert(suits[0])
        cardSuitsRemaining.insert(suits[1])
        cardSuitsRemaining.insert(suits[2])
        cardSuitsRemaining.insert(suits[3])
        
        // create frame for playButton
        playButton.frame = CGRect(x: view.center.x-(view.frame.width/14), y: view.frame.height-40-(view.frame.width/7), width: view.frame.width/7, height: view.frame.width/7)
        //buttons[0].frame = CGRect(x: view.center.x-(view.frame.width/14), y: view.frame.height-40-(view.frame.width/7), width: view.frame.width/7, height: view.frame.width/7)
        
        // set image of playButton
        playButton.image = UIImage(named: "play")
        //buttons[0].setImage(UIImage(named: "play"), for: UIControl.State.normal)
        
        // set highlighted image of playButton
        playButton.highlightedImage = UIImage(named: "playH")
        //buttons[0].setImage(UIImage(named: "playH"), for: UIControl.State.highlighted)
        
        // the code below sets the highlightedImage of playButton
        playButton.isHighlighted = true;
        //buttons[0].isHighlighted = true;
        
        // add playButton image to the view
        view.addSubview(playButton);
        //view.addSubview(buttons[0]);
        
        // creates a tap gesture recognizer for playButton that initially is not enabled.
        playButton.addGestureRecognizer(UITapGestureRecognizer(target:self, action: #selector(ViewController.handleTap(_:))))
        playButton.isUserInteractionEnabled = false        //buttons[0].isUserInteractionEnabled = false
        //buttons[0].addTarget(self, action: #selector(ViewController.imageButtonPressed), for: UIControl.Event.touchUpInside)
        
        
    }
    
    @objc func imageButtonPressed(sender: UIButton){
        
    }
    
    @objc func handleTap(_ recognizer: UITapGestureRecognizer) {
        if recognizer.view == playButton {
            // turns off playButton highlighted
            playButton.isHighlighted = false;
            // takes away playButton interaction
            playButton.isUserInteractionEnabled = false
            nextTurn()
            // inserts the cards images back into the set only if they are not already in the set
            cardSuitsRemaining.insert(suits[0])
            cardSuitsRemaining.insert(suits[1])
            cardSuitsRemaining.insert(suits[2])
            cardSuitsRemaining.insert(suits[3])
            // diplays all the card suit immages
            suits[0].isHidden = false
            suits[1].isHidden = false
            suits[2].isHidden = false
            suits[3].isHidden = false
            highlightOpenCards()
        }
    }
    
    @objc func handlePan(_ recognizer: UIPanGestureRecognizer) {
        if recognizer.state == UIGestureRecognizer.State.began {
            // not needed for lab 2 or lab 3
            startingPoint = recognizer.view!.center
            // brings the view to the front
            recognizer.view?.superview?.bringSubviewToFront(recognizer.view!)
        }
        let translation: CGPoint = recognizer.translation(in:view)
        recognizer.view?.center = CGPoint(x:recognizer.view!.center.x + translation.x, y: recognizer.view!.center.y + translation.y)
        // Without the line below the card will leave the screen once clicked
        recognizer.setTranslation(CGPoint(x: 0, y: 0), in:view)
        if recognizer.state == UIGestureRecognizer.State.ended {
            // without line below card will remain highlighted
            recognizer.view!.isHidden = true
            // chekcs if the card was a club
            if (recognizer.view!.tag/100 == 0) {
                suits[0].isHidden = true
                cardSuitsRemaining.remove(suits[0])
            }
            // checks if the card was a diamond
            if (recognizer.view!.tag/100 == 1) {
                suits[1].isHidden = true
                cardSuitsRemaining.remove(suits[1])
            }
            // checks if the card was a heart
            if (recognizer.view!.tag/100 == 2) {
                suits[2].isHidden = true
                cardSuitsRemaining.remove(suits[2])
            }
            // checks if the card was a spade
            if (recognizer.view!.tag/100 == 3) {
                suits[3].isHidden = true
                cardSuitsRemaining.remove(suits[3])
            }
            game.cardsRemaining-=1
            highlightOpenCards()
            playButton.isHighlighted = true
            playButton.isUserInteractionEnabled = true
            
            //buttons[0].isHighlighted = true
            //buttons[0].isUserInteractionEnabled = true
        }
        if recognizer.state == UIGestureRecognizer.State.cancelled {
            recognizer.view?.center = startingPoint
        }
    }
    
    // The following 3 methods were "borrowed" from http://stackoverflow.com/questions/15710853/objective-c-check-if-subviews-of-rotated-uiviews-intersect and converted to Swift
    private func projectionOfPolygon(poly: [CGPoint], onto: CGPoint) ->  (min: CGFloat, max: CGFloat) {
        var minproj: CGFloat = CGFloat.greatestFiniteMagnitude
        var maxproj: CGFloat = -CGFloat.greatestFiniteMagnitude
        for point in poly {
            let proj: CGFloat = point.x * onto.x + point.y * onto.y
            if proj > maxproj {
                maxproj = proj
            }
            if proj < minproj {
                minproj = proj
            }
        }
        return (minproj, maxproj)
    }
    
    private func convexPolygon(poly1: [CGPoint], poly2: [CGPoint]) -> Bool {
        for i in 0 ..< poly1.count {
            // Perpendicular vector for one edge of poly1:
            let p1: CGPoint = poly1[i];
            let p2: CGPoint = poly1[(i+1) % poly1.count];
            let perp: CGPoint = CGPoint(x: p1.y - p2.y, y: p2.x - p1.x)
            // Projection intervals of poly1, poly2 onto perpendicular vector:
            let (minp1,maxp1): (CGFloat,CGFloat) = projectionOfPolygon(poly: poly1, onto: perp)
            let (minp2,maxp2): (CGFloat,CGFloat) = projectionOfPolygon(poly: poly2, onto: perp)
            // If projections do not overlap then we have a "separating axis" which means that the polygons do not intersect:
            if maxp1 < minp2 || maxp2 < minp1 {
                return false
            }
        }
        // And now the other way around with edges from poly2:
        for i in 0 ..< poly2.count {
            // Perpendicular vector for one edge of poly2:
            let p1: CGPoint = poly2[i];
            let p2: CGPoint = poly2[(i+1) % poly2.count];
            let perp: CGPoint = CGPoint(x: p1.y - p2.y, y:
                p2.x - p1.x)
            // Projection intervals of poly1, poly2 onto perpendicular vector:
            let (minp1,maxp1): (CGFloat,CGFloat) = projectionOfPolygon(poly: poly1, onto: perp)
            let (minp2,maxp2): (CGFloat,CGFloat) = projectionOfPolygon(poly: poly2, onto: perp)
            // If projections do not overlap then we have a "separating axis" which means that the polygons do not intersect:
            if maxp1 < minp2 || maxp2 < minp1 {
                return false
            }
        }
        return true
    }

    private func viewsIntersect(view1: UIView, view2: UIView) -> Bool {
        return convexPolygon(poly1: [view1.convert(view1.bounds.origin, to: nil), view1.convert(CGPoint(x: view1.bounds.origin.x + view1.bounds.size.width, y: view1.bounds.origin.y), to: nil), view1.convert(CGPoint(x: view1.bounds.origin.x + view1.bounds.size.width, y: view1.bounds.origin.y + view1.bounds.height), to: nil), view1.convert(CGPoint(x: view1.bounds.origin.x, y: view1.bounds.origin.y + view1.bounds.height), to: nil)], poly2: [view2.convert(view1.bounds.origin, to: nil), view2.convert(CGPoint(x: view2.bounds.origin.x + view2.bounds.size.width, y: view2.bounds.origin.y), to: nil), view2.convert(CGPoint(x: view2.bounds.origin.x + view2.bounds.size.width, y: view2.bounds.origin.y + view2.bounds.height), to: nil), view2.convert(CGPoint(x: view2.bounds.origin.x, y: view2.bounds.origin.y + view2.bounds.height), to: nil)])
    }
    
    private func cardIsOpenAtIndex(i: Int) -> Bool {
        for k in i+1 ..< game.board.count {
            if viewsIntersect(view1: game.board[i], view2: game.board[k]) && !game.board[k].isHidden {
                return false
            }
        }
        return true
    }
    
    private func highlightOpenCards() {
        for i in 0 ..< game.board.count {
            let open: Bool = cardIsOpenAtIndex(i: i)
            // checks if the suit was played this turn.
            if (cardSuitsRemaining.contains(suits[i % 4])) {
                game.board[i].isHighlighted = open
                game.board[i].isUserInteractionEnabled = open
            }
        }
    }
    
    private func createCards() {
        let w = 0.25*view.frame.width
        let h = (351.0/230.0)*w
        var cardSuit: Int = 0
        game.board = [UIImageView]()
        game.cardsRemaining = MAXCARDS + Int.random(in: 0...MAXCARDS/2)
        for i in 0 ..< game.cardsRemaining {
            let card: UIImageView = UIImageView(image: UIImage(named: CARDS[cardSuit]), highlightedImage: UIImage(named: "\(CARDS[cardSuit])H"))
            card.isHighlighted = false
            card.tag = i + 100 * cardSuit
            card.frame = CGRect(x: CGFloat.random(in: 0.35...0.85)*view.frame.width - w, y: CGFloat.random(in: 0.40...0.80)*view.frame.height - h, width: w, height: h)
            card.transform = CGAffineTransform(rotationAngle: CGFloat.random(in: 0.0...45.0)*CGFloat.pi/180.0)
            view.addSubview(card)
            card.addGestureRecognizer(UIPanGestureRecognizer(target:self, action: #selector(ViewController.handlePan(_:))))
            card.isUserInteractionEnabled = true
            game.board.append(card)
            cardSuit = (cardSuit + 1) % 4
        }
    }
    
    private func nextTurn() {
        game.blueTurn = !game.blueTurn
        view.backgroundColor = game.blueTurn ? BLUE : RED
        highlightOpenCards()
    }
 
    func enterNewGame() {
        createCards()
        nextTurn()
    }
    
}
