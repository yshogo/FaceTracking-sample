//
//  ViewController.swift
//  face-tracking-test
//
//  Created by 山田尚吾 on 2019/08/25.
//  Copyright © 2019 山田尚吾. All rights reserved.
//

import UIKit
import SceneKit
import ARKit

class ViewController: UIViewController, ARSessionDelegate {
    
    @IBOutlet var sceneView: ARSCNView!
    private var faceGeometory: ARSCNFaceGeometry!
    private var faceNode: SCNNode!
    
    private let sampeTest: SCNReferenceNode? = {
        let path = Bundle.main.path(forResource: "overlayModel", ofType: "scn")!
        let url = URL(fileURLWithPath: path)
        return SCNReferenceNode(url: url)
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        sceneView.delegate = self
        sceneView.showsStatistics = false
        // 自動ロックをオフにしておく
        UIApplication.shared.isIdleTimerDisabled = false
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        resetTracking()
    }
    
    private func resetTracking() {
        guard ARFaceTrackingConfiguration.isSupported else {
            // Face tracking is not supported.
            return
        }
        let configuration = ARFaceTrackingConfiguration()
        // ライトは3Dモデルのものを使います
        configuration.isLightEstimationEnabled = false
//        let options = [.resetTracking, .removeExistingAnchors]
        sceneView.session.run(configuration, options: [.resetTracking, .removeExistingAnchors])
    }
}

extension ViewController: ARSCNViewDelegate {
    func renderer(_ renderer: SCNSceneRenderer, didAdd node: SCNNode, for anchor: ARAnchor) {
        guard anchor is ARFaceAnchor else { return }
        
        if node.childNodes.isEmpty, let content = sampeTest {
            // ノードを読み込み
            content.load()
            
            // 顔面にノードを追加
            node.addChildNode(content)
        }
    }
}
