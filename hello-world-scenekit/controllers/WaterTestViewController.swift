import UIKit
import QuartzCore
import SceneKit

class WaterTestViewController: UIViewController {
    @IBOutlet weak var sceneView: SCNView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupScene()
    }
    //Builds the scene
    private func setupScene(){
        guard let myScene = SCNScene(named: "art.scnassets/water.scn")
            else {fatalError("Unable to load scene")}
        sceneView.scene = myScene
        sceneView.backgroundColor = UIColor.black
        sceneView.allowsCameraControl = true
        let water: SCNNode = sceneView.scene!.rootNode.childNode(withName: "water box", recursively: true)!
        //setupShaderExtensions(object: water)
    }
    //Creates the shader extensions that create the water effect
    private func setupShaderExtensions(object:SCNNode){
        let surfaceShaderExtension = """
            vec3 position = _surface.position;
            if(position.x < 0){
                position.y = position.y - 1.0;
            }
            if(position.x > 0){
                position.y = position.y + 1.0;
            }
            _surface.position = position;
        """
        object.geometry!.shaderModifiers = [.surface: surfaceShaderExtension]
    }
    override var shouldAutorotate: Bool {
        return true
    }
    override var prefersStatusBarHidden: Bool {
        return true
    }
}
