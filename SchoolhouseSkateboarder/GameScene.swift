import SpriteKit

class GameScene: SKScene {
    
    // An array that holds all the current sidewalk brikcs
    var bricks = [SKSpriteNode]()
    
    // The size of the sidewalk brick graphics used
    var brickSize = CGSize.zero
    
    // Setting for how fast the game is scrolling to the right
    // This may increase as the user progresses in the game
    var scrollSpeed: CGFloat = 5.0
    
    // The timestamp of the last update method call
    var lastUpdateTime: TimeInterval?
    
    // The hero of the game, the skater, is created here
    let skater = Skater(imageNamed: "skater")

    
    override func didMove(to view: SKView) {
        
        anchorPoint = CGPoint.zero
        
        let background = SKSpriteNode(imageNamed: "background")
        let xMid = frame.midX
        let yMid = frame.midY
        background.position = CGPoint(x: xMid, y: yMid)
        addChild(background)
        
        // Set up the skater and add her to the scene
        resetSkater()
        addChild(skater)
        
    }
    
    func resetSkater() {
        
        // Set the skater's starting position, zPosition, and minimumY
        let skaterX = frame.midX / 2.0
        let skaterY = skater.frame.height / 2.0 + 64.0
        skater.position = CGPoint(x: skaterX, y: skaterY)
        skater.zPosition = 10
        skater.minimumY = skaterY
    }
    
    func spawnBrick(atPosition Position: CGPoint) -> SKSpriteNode {
        
        // Createa brick sprite and add it to the scene
        let brick = SKSpriteNode(imageNamed: "sidewalk")
        brick.position = position
        brick.zPosition = 8
        addChild(brick)
        
        print("got here")
        
        // Update our brickSize with real brick size
        brickSize = brick.size
        
        // Add the new brick to the array of bricks
        bricks.append(brick)
        
        // Retern this new brick to the caller
        return brick
    }
    
    func updateBricks(withScrollAmount currentScrollAmount: CGFloat)  {
    
        // Keep track of the greatest x-position of all the current bricks
        var farthestRightBrickX: CGFloat = 0.0
        
        for brick in bricks {
            
            let newX = brick.position.x - currentScrollAmount
            
            // If a brick has moved too far left (off the screen), remove it
            if newX < -brickSize.width {
                
                brick.removeFromParent()
                
                if let brickIndex = bricks.index(of: brick) {
                    bricks.remove(at: brickIndex)
                }
                print(farthestRightBrickX)
                // A while loop to ensure that our screen is always full of bricks
                while farthestRightBrickX < frame.width {
                    
                    var brickX = farthestRightBrickX + brickSize.width + 1.0
                    let brickY = brickSize.height / 2.0
                    
                    // Evrey now and then, leave a gap the player must jump over
                    let randomNumber = arc4random_uniform(99)
                    
                    if randomNumber < 5 {
                        
                        // There is a 5 % chance that we will leave a gap between bricks
                        let gap = 20.0 * scrollSpeed
                        brickX += gap
                    }
                    
                    // Spawn a new brick and update the rightmost brick
                    let newBrick = spawnBrick(atPosition: CGPoint(x: brickX, y: brickY))
                    
                    farthestRightBrickX = newBrick.position.x
                }
                    
            } else {
                
                // For a brick that is stil on screen update its position
                brick.position = CGPoint(x: newX, y: brick.position.y)
                
                // Update our farthest- right position tracker
                if brick.position.x > farthestRightBrickX {
                    farthestRightBrickX = brick.position.x
                }
            }
        }
    }
        
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
        
        // Determine the elapsed time since the last update call
        var elapsedTime: TimeInterval = 0.0
        if let lastTimeStamp = lastUpdateTime {
            elapsedTime = currentTime - lastTimeStamp
        }
        
        lastUpdateTime = currentTime
        
        let expectedElapsedTime: TimeInterval = 1.0 / 60.0
        
        // Here we calculate how far everything should move in this update
        let scrollAdjustment = CGFloat(elapsedTime / expectedElapsedTime)
        let currentScrollAmount = scrollSpeed * scrollAdjustment
        
        updateBricks(withScrollAmount: currentScrollAmount)
    }
}
