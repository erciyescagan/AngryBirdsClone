//
//  GameScene.swift
//  AngryBirdsClone
//
//  Created by Mert Erciyes Çağan on 6/10/24.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene, SKPhysicsContactDelegate {
    
    var bird = SKSpriteNode()
    var box1 = SKSpriteNode()
    var box2 = SKSpriteNode()
    var box3 = SKSpriteNode()
    var box4 = SKSpriteNode()
    var box5 = SKSpriteNode()
    var box6 = SKSpriteNode()
    
    var boxes : [Int : SKSpriteNode] = [:]
    
    var gameStarted = false
    var originalPositionOfBird = CGPoint()
    
    enum ColliderType : UInt32 {
        case Bird = 1
        case Box = 2
        //case Tree = 4
        //case Tree = 8
        //case Tree = 16
    }
    
    override func didMove(to view: SKView) {
       /* let texture = SKTexture(imageNamed: "chicken")
        chicken = SKSpriteNode(texture: texture)
        chicken.position = CGPoint(x: 0, y: 0)
        chicken.size = CGSize(width: 339, height: 314)
        chicken.zPosition = 1
        self.addChild(chicken) */
        
        self.physicsBody = SKPhysicsBody(edgeLoopFrom: frame)
        self.scene?.scaleMode = .aspectFit
        self.physicsWorld.contactDelegate = self
        

        
        bird = childNode(withName: "bird") as! SKSpriteNode
        boxes = [1: box1, 2: box2, 3: box3, 4: box4, 5: box5, 6: box6]
 
        
        let birdTexture = SKTexture(imageNamed: "bird")
    
        bird.physicsBody = SKPhysicsBody(circleOfRadius: birdTexture.size().height / 13)
        bird.physicsBody?.isDynamic = true
        bird.physicsBody?.affectedByGravity = false
        bird.physicsBody!.mass = 0.03
        originalPositionOfBird = bird.position
        bird.physicsBody?.contactTestBitMask = ColliderType.Bird.rawValue
        bird.physicsBody?.categoryBitMask = ColliderType.Bird.rawValue
        bird.physicsBody?.collisionBitMask = ColliderType.Bird.rawValue
        
        let boxTexture = SKTexture(imageNamed: "brick")
        let size = CGSize(width: boxTexture.size().width / 5, height: boxTexture.size().height / 5)
        
        for (index, _) in boxes {
            let box = childNode(withName: "box\(index)") as! SKSpriteNode
            box.physicsBody = SKPhysicsBody(rectangleOf: size)
            box.physicsBody?.isDynamic = true
            box.physicsBody?.affectedByGravity = true
            box.physicsBody?.allowsRotation = true
            box.physicsBody?.mass = 0.2
            
            box.physicsBody?.collisionBitMask = ColliderType.Bird.rawValue
        }
        
    }
    
    
    func touchDown(atPoint pos : CGPoint) {
      
    }
    
    func touchMoved(toPoint pos : CGPoint) {
       
    }
    
    func touchUp(atPoint pos : CGPoint) {
    
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        // bird.physicsBody?.applyImpulse(CGVector(dx: 300, dy: 300))
        
        if gameStarted == false {
            if let touch = touches.first {
                let touchLocation = touch.location(in: self)
                let touchNodes = nodes(at: touchLocation)
                if touchNodes.isEmpty == false {
                    for node in touchNodes {
                        if let sprite = node as? SKSpriteNode {
                            if sprite == bird {
                                bird.position = touchLocation
                            }
                        }
                    }
                }
            }
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        if gameStarted == false {
            if let touch = touches.first {
                let touchLocation = touch.location(in: self)
                let touchNodes = nodes(at: touchLocation)
                if touchNodes.isEmpty == false {
                    for node in touchNodes {
                        if let sprite = node as? SKSpriteNode {
                            if sprite == bird {
                                bird.position = touchLocation
                            }
                        }
                    }
                }
            }
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        if gameStarted == false {
            if let touch = touches.first {
                let touchLocation = touch.location(in: self)
                let touchNodes = nodes(at: touchLocation)
                if touchNodes.isEmpty == false {
                    for node in touchNodes {
                        if let sprite = node as? SKSpriteNode {
                            if sprite == bird {
                                let dx = -(touchLocation.x - originalPositionOfBird.x)
                                let dy = -(touchLocation.y - originalPositionOfBird.y)
                                let impulse = CGVector(dx: dx, dy: dy)
                                bird.physicsBody?.applyImpulse(impulse)
                                bird.physicsBody?.affectedByGravity = true
                                gameStarted = true
                                
                            }
                        }
                    }
                }
            }
        }
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
    }
    
    
    override func update(_ currentTime: TimeInterval) {
        if let birdPhysicsBody = bird.physicsBody {
            if birdPhysicsBody.velocity.dx <= 1 && birdPhysicsBody.velocity.dy <= 0.5 && birdPhysicsBody.angularVelocity <= 1 && gameStarted == true {
                gameStarted = false
                bird.physicsBody!.velocity.dx = 0
                bird.physicsBody!.velocity.dy = 0
                bird.physicsBody!.angularVelocity = 0
                bird.physicsBody?.node?.zPosition = 1
                bird.position = originalPositionOfBird
                bird.physicsBody?.affectedByGravity = false
                
                
                
            }
        }
    }
    
    func didBegin(_ contact: SKPhysicsContact) {
        if contact.bodyA.collisionBitMask == ColliderType.Bird.rawValue || contact.bodyB.collisionBitMask == ColliderType.Bird.rawValue {
            
        }
    }
}
