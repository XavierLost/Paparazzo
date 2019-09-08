import AVFoundation
import ImageSource
import UIKit

class NewPhotoLibraryCameraView: UICollectionReusableView, PhotoLibraryCameraViewInterface {
    
    // MARK: - Subviews
    var cameraOutputLayer: AVCaptureVideoPreviewLayer? = AVCaptureVideoPreviewLayer()
    private var dimView = UIView()
    private let button = UIButton()
    
    // MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = .black
        
        layer.cornerRadius = 6
        layer.rasterizationScale = UIScreen.main.nativeScale
        layer.shouldRasterize = true
        layer.masksToBounds = true
        
        dimView.backgroundColor = UIColor.black.withAlphaComponent(0.48)
        
        addSubview(dimView)
        
        button.tintColor = .white
        button.addTarget(self, action: #selector(onButtonTap(_:)), for: .touchUpInside)
        
        addSubview(button)
        
        if let cameraOutputLayer = cameraOutputLayer {
            cameraOutputLayer.videoGravity = .resizeAspectFill
            cameraOutputLayer.cornerRadius = 6
            layer.insertSublayer(cameraOutputLayer, below: dimView.layer)
        }
        
        setAccessibilityId(.cameraInLibraryButton)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - NewPhotoLibraryCameraView
    var onTap: (() -> ())?
    
    func setCameraIcon(_ icon: UIImage?) {
        button.setImage(icon, for: .normal)
    }
    
    func setOutputParameters(_ parameters: CameraOutputParameters) {
        cameraOutputLayer?.session = parameters.captureSession
    }
    
    func setOutputOrientation(_ orientation: ExifOrientation) {
        // AVCaptureVideoPreviewLayer handles this itself
    }
    
    func setPreviewLayer(_ previewLayer: AVCaptureVideoPreviewLayer?) {
        self.cameraOutputLayer = previewLayer
        
        if let previewLayer = previewLayer {
            layer.insertSublayer(previewLayer, below: dimView.layer)
            layOutPreviewLayer()
        }
    }
    
    // MARK: - Layout
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let insets = UIEdgeInsets(top: 0.5, left: 0.5, bottom: 0.5, right: 0.5)
        
        layOutPreviewLayer()
        
        dimView.frame = bounds
        button.frame = bounds
    }
    
    // MARK: - Private
    @objc private func onButtonTap(_ sender: UIButton) {
        onTap?()
    }
    
    private func layOutPreviewLayer() {
        CATransaction.begin()
        CATransaction.setDisableActions(true)
        cameraOutputLayer?.frame = layer.bounds
        CATransaction.commit()
    }
}