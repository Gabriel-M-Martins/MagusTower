import GameplayKit

class GameScene: SKScene {
    /// struct constants vai ter todos os valores constantes ao longo do jogo, cores e etc
    var constants: Constants {
        return Constants(frame: frame)
    }

    // lista de plataformas existentes na cena. todas sao desenhadas no começo do jogo
    var platforms: [SKSpriteNode] = []

    /// quando a view chamar a cena, esta funçao é a primeira a ser executada.
    ///  é a preparaçao da cena.
    override func didMove(to view: SKView) {
        /// plataforma do ground
        let ground = SKSpriteNode(color: .black, size: CGSize(width: frame.width, height: frame.height/4))
        // settando o anchor point para ser no meio horizontal e no baixo na vertical
        ground.anchorPoint = CGPoint(x: 0.5, y: 0)
        // posicao do ground é zero no x e o mais baixo no y
        ground.position = CGPoint(x: 0, y: frame.minY)
        // criando o physicsbody e settando que nao é dinamico p nenhuma força poder ser aplicada contra ele
        ground.physicsBody = SKPhysicsBody()
        ground.physicsBody?.isDynamic = false
        platforms.append(ground)

        // ------------------------------------------------------------------------
        
        let platform1 = SKSpriteNode(color: .black, size: CGSize(width: frame.width/3, height: constants.platformsHeight))

        platform1.anchorPoint = CGPoint(x: 0, y: 0.5)
        platform1.position = CGPoint(x: frame.minX, y: frame.midY)
        platform1.physicsBody = SKPhysicsBody()
        platform1.physicsBody?.isDynamic = false
        platforms.append(platform1)

        // ------------------------------------------------------------------------
        
        let platform2 = SKSpriteNode(color: .black, size: CGSize(width: frame.width/3, height: constants.platformsHeight))

        platform2.anchorPoint = CGPoint(x: 1, y: 0.5)
        platform2.position = CGPoint(x: frame.maxX, y: frame.midY)
        platform2.physicsBody = SKPhysicsBody()
        platform2.physicsBody?.isDynamic = false
        platforms.append(platform2)

        // ------------------------------------------------------------------------
        
        // adicionando todas as plataformas como childs da cena
        for i in platforms {
            addChild(i)
        }
    }
}
