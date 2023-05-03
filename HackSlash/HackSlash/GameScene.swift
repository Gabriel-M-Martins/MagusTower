import GameplayKit

class GameScene: SKScene {
    /// struct constants vai ter todos os valores constantes ao longo do jogo, cores e etc
    var constants: Constants {
        return Constants(frame: frame)
    }

    // lista de plataformas existentes na cena. todas sao desenhadas no começo do jogo
    var platforms: [SKSpriteNode] = []
    var player: Player = Player(sprite: "")

    /// quando a view chamar a cena, esta funçao é a primeira a ser executada.
    ///  é a preparaçao da cena.
    override func didMove(to view: SKView) {
        setupGround()
        // ------------------------------------------------------------------------
        setupPlayer()
        // ------------------------------------------------------------------------
        setupCamera()
    }
    
    override func update(_ currentTime: TimeInterval) {
        player.move(direction: [.right, .up])
        camera?.position = player.position
    }
    
    func setupCamera() {
        let camera = SKCameraNode()
        camera.setScale(0.7)
        self.camera = camera
        addChild(camera)
    }
    
    func setupGround(){
        /// plataforma do ground
        let ground = SKSpriteNode(color: .black, size: CGSize(width: frame.width, height: frame.height/4))
        // settando o anchor point para ser no meio horizontal e no baixo na vertical
        ground.anchorPoint = CGPoint(x: 0.5, y: 0)
        // posicao do ground é zero no x e o mais baixo no y
        ground.position = CGPoint(x: 0, y: frame.minY)
        // criando o physicsbody e settando que nao é dinamico p nenhuma força poder ser aplicada contra ele
        ground.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: ground.size.width * 2, height: ground.size.height * 2))
        ground.physicsBody?.isDynamic = false
        ground.physicsBody?.affectedByGravity = false
        platforms.append(ground)

        // ------------------------------------------------------------------------
        
        let platform1 = SKSpriteNode(color: .black, size: CGSize(width: frame.width/3, height: constants.platformsHeight))

        platform1.anchorPoint = CGPoint(x: 0, y: 0.5)
        platform1.position = CGPoint(x: frame.minX, y: frame.midY)
        platform1.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: platform1.size.width * 2, height: platform1.size.height * 2))
        platform1.physicsBody?.isDynamic = false
        platform1.physicsBody?.affectedByGravity = false
        platforms.append(platform1)

        // ------------------------------------------------------------------------
        
        let platform2 = SKSpriteNode(color: .black, size: CGSize(width: frame.width/3, height: constants.platformsHeight))

        platform2.anchorPoint = CGPoint(x: 1, y: 0.5)
        platform2.position = CGPoint(x: frame.maxX, y: frame.midY)
        platform2.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: platform2.size.width * 2, height: platform2.size.height * 2))
        platform2.physicsBody?.isDynamic = false
        platform2.physicsBody?.affectedByGravity = false
        platforms.append(platform2)

        // ------------------------------------------------------------------------
        
        // adicionando todas as plataformas como childs da cena
        for i in platforms {
            addChild(i)
        }
    }
    
    func setupPlayer(){
        //Creates player and adds it to the scene
        player = Player(sprite: "YellowBall")
        addChild(player.sprite)
    }
}
