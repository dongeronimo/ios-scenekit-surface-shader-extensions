import UIKit
import QuartzCore
import SceneKit

class WaterTestViewController: UIViewController {
    @IBOutlet weak var sceneView: SCNView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupScene()
    }
    private func setupScene(){
        guard let myScene = SCNScene(named: "art.scnassets/water.scn")
            else {fatalError("Unable to load scene")}
        sceneView.scene = myScene
        sceneView.backgroundColor = UIColor.black
        sceneView.allowsCameraControl = true
    }

    override var shouldAutorotate: Bool {
        return true
    }
    override var prefersStatusBarHidden: Bool {
        return true
    }
}
