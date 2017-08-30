/*
* Copyright (c) 2014 Razeware LLC
*
* Permission is hereby granted, free of charge, to any person obtaining a copy
* of this software and associated documentation files (the "Software"), to deal
* in the Software without restriction, including without limitation the rights
* to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
* copies of the Software, and to permit persons to whom the Software is
* furnished to do so, subject to the following conditions:
*
* The above copyright notice and this permission notice shall be included in
* all copies or substantial portions of the Software.
*
* THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
* IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
* FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
* AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
* LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
* OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
* THE SOFTWARE.
*/

import UIKit
import SceneKit

class ViewController: UIViewController {
    // UI
    @IBOutlet weak var geometryLabel: UILabel!
    @IBOutlet weak var sceneView: SCNView!
    
    var boxNode: SCNNode!
    var dallNodes = [String]()
    
    // MARK: Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        sceneSetup()
    }
    
    // MARK: IBActions
    @IBAction func segmentValueChanged(_ sender: UISegmentedControl) {
    }
    
    // MARK: Style
    override var preferredStatusBarStyle : UIStatusBarStyle {
        return UIStatusBarStyle.lightContent
    }
    
    // MARK: Transition
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        sceneView.stop(nil)
        sceneView.play(nil)
    }
    
    func sceneSetup() {
        
        sceneView.autoenablesDefaultLighting = true
        sceneView.allowsCameraControl = true
        
        // 1
        let scene = SCNScene()
        
        // 2
        let boxGeometry = SCNBox(width: 8, height: 8, length: 8, chamferRadius: 1.0)
        let boxNode = SCNNode(geometry: boxGeometry)
        boxNode.name = "box"
//        scene.rootNode.addChildNode(boxNode)
        self.boxNode = boxNode
        
        let dNode = SCNNode()
        let geoScene = SCNScene(named: "BB_0829.obj")
        
        for case let node in geoScene!.rootNode.childNodes {
            if let name = node.name {
                dallNodes.append(name)
            }
            
            dNode.addChildNode(node)
        }
//        scene.rootNode.addChildNode(boxNode)
        scene.rootNode.addChildNode(dNode)
        
        sceneView.scene = scene
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(tapGesture(_:)))
        sceneView.addGestureRecognizer(tap)
        
    }
    
    func tapGesture(_ sender: UITapGestureRecognizer) {
        print("handle tap!!")
        let point = sender.location(in: sceneView)
        let hits = self.sceneView.hitTest(point, options: nil)
        for touch in hits {
            print(touch.node.name)
            if touch.node == boxNode {
                
                let alert = UIAlertController(title: "Hit", message: "On Box", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                present(alert, animated: true, completion: nil)
            }
            if let name = touch.node.name {
                if dallNodes.contains(name) {
                    let alert = UIAlertController(title: "Hit", message: name, preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                    present(alert, animated: true, completion: nil)
                }
            }
        }
    
    }
}
