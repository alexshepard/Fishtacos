//
//  ViewController.swift
//  Fishtacos
//
//  Created by Alex Shepard on 8/22/15.
//  Copyright © 2015 Alex Shepard. All rights reserved.
//

import UIKit
import GameKit

class ViewController: UIViewController, GKGameCenterControllerDelegate, GKLocalPlayerListener, GKTurnBasedMatchmakerViewControllerDelegate {
    
    @IBOutlet weak var newGameButton: UIButton?
    @IBOutlet weak var leaderboardButton: UIButton?
    @IBOutlet weak var loadingGameCenterLabel: UILabel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.loadingGameCenterLabel?.hidden = false
        self.newGameButton?.enabled = false
        self.leaderboardButton?.enabled = false
        
        // auth our user
        let localPlayer = GKLocalPlayer.localPlayer()
        localPlayer.authenticateHandler = {(ViewController, error) -> Void in
            if let authVC = ViewController {
                self.presentViewController(authVC, animated: true, completion: nil)
            } else if (localPlayer.authenticated) {
                self.loadingGameCenterLabel?.hidden = true
                self.newGameButton?.enabled = true
                self.leaderboardButton?.enabled = true
                localPlayer.registerListener(self)
            } else {
                let alert = UIAlertController(title: "No game center", message: "Try again later", preferredStyle: .Alert)
                alert.addAction(UIAlertAction(title: "OK", style: .Default, handler: { (_) -> Void in
                    self.dismissViewControllerAnimated(true, completion: nil)
                }))
                self.presentViewController(alert, animated: true, completion: nil)
                self.loadingGameCenterLabel?.text = "No game center"
            }
            
        }
    }
    
    //MARK: - UIButton targets
    @IBAction func newGame(sender: UIButton) {
        let matchRequest = GKMatchRequest()
        
        matchRequest.minPlayers = 2
        matchRequest.maxPlayers = 2
        matchRequest.defaultNumberOfPlayers = 2
        
        let vc = GKTurnBasedMatchmakerViewController(
            matchRequest: matchRequest
        )
        
        vc.turnBasedMatchmakerDelegate = self
        
        presentViewController(vc, animated: true, completion: nil)
    }
    
    @IBAction func leaderboards(sender: UIButton) {
        let gcVC: GKGameCenterViewController = GKGameCenterViewController()
        gcVC.gameCenterDelegate = self
        gcVC.viewState = GKGameCenterViewControllerState.Leaderboards
        gcVC.leaderboardIdentifier = "LeaderboardID"
        self.presentViewController(gcVC, animated: true, completion: nil)
    }


    //MARK: - GKGameCenterControllerDelegate
    func gameCenterViewControllerDidFinish(gameCenterViewController: GKGameCenterViewController) {
        gameCenterViewController.dismissViewControllerAnimated(true, completion: nil)
    }
    
    
    //MARK: - GKTurnBasedMatchmakerViewControllerDelegate
    func turnBasedMatchmakerViewController(viewController: GKTurnBasedMatchmakerViewController, didFindMatch match: GKTurnBasedMatch) {
        
        dismissViewControllerAnimated(true) {
            print("matchmaker got match \(match)")
            self.updateCurrentMatchData(match)
        }
    }
    
    func turnBasedMatchmakerViewController(viewController: GKTurnBasedMatchmakerViewController, didFailWithError error: NSError) {
        
        dismissViewControllerAnimated(true) {
            print("matchmaker failed with error \(error)")
        }
    }
    
    func turnBasedMatchmakerViewController(viewController: GKTurnBasedMatchmakerViewController, playerQuitForMatch match: GKTurnBasedMatch) {
        
        dismissViewControllerAnimated(true) {
            print("matchmaker player quit \(match)")
        }
    }
    
    func turnBasedMatchmakerViewControllerWasCancelled(viewController: GKTurnBasedMatchmakerViewController) {
        
        dismissViewControllerAnimated(true) {
            print("matchmaker was cancelled")
        }
    }
    
    //MARK: - GKTurnBasedEventListener
    func player(player: GKPlayer, receivedTurnEventForMatch match: GKTurnBasedMatch, didBecomeActive: Bool) {
        updateCurrentMatchData(match)
    }
    
    //MARK: - update match data
    func updateCurrentMatchData(match: GKTurnBasedMatch) {
        print("update for \(match)")
    }
    
}

