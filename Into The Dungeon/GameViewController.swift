//
//  GameViewController.swift
//  Into The Dungeon
//
//  Created by Vy Nguyen on 11/23/20.
//  Copyright © 2020 Vy Nguyen. All rights reserved.
//
// pictures: <div>Icons made by <a href="https://www.flaticon.com/authors/flat-icons" title="Flat Icons">Flat Icons</a> from <a href="https://www.flaticon.com/" title="Flaticon">www.flaticon.com</a></div>
// <div>Icons made by <a href="https://www.flaticon.com/authors/freepik" title="Freepik">Freepik</a> from <a href="https://www.flaticon.com/" title="Flaticon">www.flaticon.com</a></div>
// <div>Icons made by <a href="https://www.flaticon.com/authors/good-ware" title="Good Ware">Good Ware</a> from <a href="https://www.flaticon.com/" title="Flaticon">www.flaticon.com</a></div>
// <div>Icons made by <a href="https://www.flaticon.com/authors/freepik" title="Freepik">Freepik</a> from <a href="https://www.flaticon.com/" title="Flaticon">www.flaticon.com</a></div>

import UIKit
import SpriteKit
import GameplayKit
import FirebaseDatabase
import Firebase

class GameViewController: UIViewController {

    
    var gameID: String? = nil
    var userName: String? = nil //nae of the user so that we can identify it out of the list of players
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
            
              
        if let view = self.view as! SKView? {
            // Load the SKScene from 'GameScene.sks'
            if let scene = SKScene(fileNamed: "GameScene") {
                // Set the scale mode to scale to fit the window
                scene.scaleMode = .aspectFill
                
                // Present the scene
                view.presentScene(scene)
            }
            
            view.ignoresSiblingOrder = true
            
            view.showsFPS = true
            view.showsNodeCount = true
        }
    }
    
    func updatePlayers() {
        if let id = gameID, let user = userName {
            FirebaseUtils.getGameData(gameID: id, completion: {(data) in
                if let gameData = data as? NSDictionary{
                    if let userList = gameData["users"] as? [String] {
                        for x in userList {
                            if let userData = gameData[x] as? NSDictionary {
                                //self.players.append(Player(team: .team1, characterClass: userData["class"] as! String, name: userData["name"] as! String))
                            }
                        }
                    }
                }
            })
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let identifier = segue.identifier {
            if identifier == "BattleSceneSegue" {
                print("TEST")
            }
        }
    }

    override var shouldAutorotate: Bool {
        return false
    }

    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .portrait
    }

    override var prefersStatusBarHidden: Bool {
        return true
    }
}
