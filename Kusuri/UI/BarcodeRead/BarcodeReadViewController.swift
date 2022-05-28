//
//  CameraViewController.swift
//  Kusuri
//
//  Created by Yus Inoue on 2021/08/29.
//

import UIKit
import AVFoundation
import RxSwift
import RxCocoa
import SnapKit

final class BarcodeReadViewController: UIViewController {
    var viewModel: BarcodeReadViewModel!
    private let disposeBag = DisposeBag()
    
    private lazy var textLayer: CATextLayer = {
        var layer = CATextLayer()
        layer.contentsScale = UIScreen.main.scale
        layer.fontSize = UIDevice.current.separateValue(forPad: 25, forPhone: 16)
        layer.alignmentMode = CATextLayerAlignmentMode.center
        layer.cornerRadius = UIDevice.current.separateValue(forPad: 8, forPhone: 4)
        layer.backgroundColor = UIColor(white: 0.25, alpha: 0.5).cgColor
        layer.string = "バーコードを読み取りました👍"
        layer.isHidden = true
        return layer
    }()
    
    private let previewArea = UIView()
    private let descriptionArea = UIView()
    
    private lazy var previewLayer: AVCaptureVideoPreviewLayer = {
        let layer = AVCaptureVideoPreviewLayer()
        layer.backgroundColor = UIColor.clear.cgColor
        layer.videoGravity = .resizeAspectFill
        return layer
    }()
    
    private let captureDiscriptionStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.alignment = .center
        stackView.axis = .vertical
        stackView.spacing = UIDevice.current.separateValue(forPad: 44, forPhone: 24)
        stackView.distribution = .equalCentering
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.isHidden = false
        return stackView
    }()
    
    private let discriptionLabel1: UILabel = {
        let label = UILabel()
        label.text = "バーコードを撮影枠内に映してください"
        label.textColor = .weakText
        label.font = .largeRegular
        label.backgroundColor = .clear
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
    }()
    
    private let discriptionLabel2: UILabel = {
        let label = UILabel()
        label.text = "読み取りが成功すると、添付文書を閲覧できます"
        label.textColor = .weakText
        label.font = .mediumLight
        label.backgroundColor = .clear
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
    }()
    
    private let caputureResultStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.alignment = .center
        stackView.axis = .vertical
        stackView.spacing = UIDevice.current.separateValue(forPad: 44, forPhone: 24)
        stackView.distribution = .equalCentering
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.isHidden = true
        return stackView
    }()
    
    private let showDetailButton: UIButton = {
        let button = UIButton(type: .roundedRect)
        button.setTitle("添付文書を見る", for: .normal)
        button.titleLabel?.font = .mediumRegular
        button.backgroundColor = .primary
        button.tintColor = .white
        button.layer.cornerRadius = 22
        return button
    }()
    
    private let reStartButton: UIButton = {
        let button = UIButton(type: .roundedRect)
        button.setTitle("もう一度読み取る", for: .normal)
        button.titleLabel?.font = .mediumRegular
        button.backgroundColor = .clear
        button.layer.borderColor = UIColor.primary.cgColor
        button.layer.borderWidth = 2
        button.layer.cornerRadius = 22
        return button
    }()
    
    private let cameraSettingView: UIView = {
        let view = UIView()
        view.backgroundColor = .backgroundCover
        view.isHidden = true
        return view
    }()
    
    var cameraSettingImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.image = UIImage(systemName: "camera")
        imageView.tintColor =  .weakText
        return imageView
    }()
    
    private let cameraSettingLabel1: UILabel = {
        let label = UILabel()
        label.text = "カメラへのアクセスが許可されていません"
        label.textColor = .weakText
        label.font = .largeRegular
        label.backgroundColor = .clear
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
    }()
    
    private let cameraSettingLabel2: UILabel = {
        let label = UILabel()
        label.text = "バーコードの読み取りに必要です"
        label.textColor = .weakText
        label.font = .mediumLight
        label.backgroundColor = .clear
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
    }()
    
    private let cameraSettingButton: UIButton = {
        let button = UIButton(type: .roundedRect)
        button.setTitle("カメラ設定を開く", for: .normal)
        button.titleLabel?.font = .mediumRegular
        button.backgroundColor = .primary
        button.tintColor = .white
        button.layer.cornerRadius = 22
        return button
    }()
    
    private lazy var barcodeReader = BarcodeReader(previewLayer: previewLayer)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.isUserInteractionEnabled = true
        view.backgroundColor = .backgroundCover
        barcodeReader.setupCamera()
        addSubViews()
        adjustLayout()
        bind()
        addActions()
    }
    
    private func addSubViews() {
        let titleLabel = UILabel()
        titleLabel.text = "バーコード"
        titleLabel.textColor = .strongText
        titleLabel.font = .largeRegular
        navigationItem.titleView = titleLabel
        navigationItem.hidesSearchBarWhenScrolling = false
        navigationController?.navigationBar.tintColor = .primary
        navigationController?.navigationBar.prefersLargeTitles = false
        navigationController?.navigationBar.isTranslucent = false
        
        view.layer.masksToBounds = true
        view.addSubview(previewArea)
        view.addSubview(descriptionArea)
        view.addSubview(cameraSettingView)
        view.layer.addSublayer(previewLayer)
        previewLayer.addSublayer(textLayer)
        
        descriptionArea.addSubview(captureDiscriptionStackView)
        captureDiscriptionStackView.addArrangedSubview(discriptionLabel1)
        captureDiscriptionStackView.addArrangedSubview(discriptionLabel2)
        
        descriptionArea.addSubview(caputureResultStackView)
        caputureResultStackView.addArrangedSubview(showDetailButton)
        caputureResultStackView.addArrangedSubview(reStartButton)

        cameraSettingView.addSubview(cameraSettingImageView)
        cameraSettingView.addSubview(cameraSettingLabel1)
        cameraSettingView.addSubview(cameraSettingLabel2)
        cameraSettingView.addSubview(cameraSettingButton)
    }
    
    private func adjustLayout() {
        previewArea.snp.makeConstraints({ make in
            make.top.equalTo(view.safeAreaLayoutGuide)
            make.bottom.equalTo(descriptionArea.snp.top)
            make.width.equalToSuperview()
        })
        descriptionArea.snp.makeConstraints({ make in
            let height = UIDevice.current.separateValue(forPad: 300, forPhone: 200)
            
            make.height.equalTo(height)
            make.width.equalToSuperview()
            make.bottom.equalTo(view.safeAreaLayoutGuide)
        })
        
        discriptionLabel1.snp.makeConstraints({ make in
            make.width.equalToSuperview()
        })
        discriptionLabel2.snp.makeConstraints({ make in
            make.width.equalToSuperview()
        })
        captureDiscriptionStackView.snp.makeConstraints({ make in
            let horizontalInset = UIDevice.current.separateValue(forPad: 88, forPhone: 22)
            make.left.right.equalToSuperview().inset(horizontalInset)
            make.center.equalToSuperview()
        })
        
        showDetailButton.snp.makeConstraints({ make in
            make.height.equalTo(44)
            make.width.equalToSuperview()
        })
        reStartButton.snp.makeConstraints({ make in
            make.height.equalTo(44)
            make.width.equalToSuperview()
        })
        caputureResultStackView.snp.makeConstraints({ make in
            let horizontalInset = UIDevice.current.separateValue(forPad: 100, forPhone: 44)
            make.center.equalToSuperview()
            make.left.right.equalToSuperview().inset(horizontalInset)
        })
        
        cameraSettingView.snp.makeConstraints({ make in
            make.edges.equalToSuperview()
        })
        cameraSettingImageView.snp.makeConstraints({ make in
            let bottomOffset = UIDevice.current.separateValue(forPad: -60, forPhone: -40)
            let heightWidth = UIDevice.current.separateValue(forPad: 100, forPhone: 75)
            
            make.centerX.equalToSuperview()
            make.bottom.equalTo(cameraSettingLabel1.snp.top).offset(bottomOffset)
            make.height.width.equalTo(heightWidth)
        })
        cameraSettingLabel1.snp.makeConstraints({ make in
            let horizontalInset = UIDevice.current.separateValue(forPad: 60, forPhone: 30)

            make.center.equalToSuperview()
            make.left.right.equalToSuperview().inset(horizontalInset)
        })
        cameraSettingLabel2.snp.makeConstraints({ make in
            let topOffset = UIDevice.current.separateValue(forPad: 60, forPhone: 30)
            let horizontalInset = UIDevice.current.separateValue(forPad: 60, forPhone: 30)

            make.top.equalTo(cameraSettingLabel1.snp.bottom).offset(topOffset)
            make.centerX.equalToSuperview()
            make.left.right.equalToSuperview().inset(horizontalInset)
        })
        cameraSettingButton.snp.makeConstraints({ make in
            let horizontalInset = UIDevice.current.separateValue(forPad: 100, forPhone: 44)
            let topOffset = UIDevice.current.separateValue(forPad: 80, forPhone: 30)
            
            make.top.equalTo(cameraSettingLabel2.snp.bottom).offset(topOffset)
            make.left.right.equalToSuperview().inset(horizontalInset)
            make.height.equalTo(44)
        })
    }
        
    override func viewDidLayoutSubviews() {
        previewLayer.frame = previewArea.frame
        
        let height = UIDevice.current.separateValue(forPad: 35, forPhone: 28)
        let width = UIDevice.current.separateValue(forPad: 400, forPhone: 270)
        let x = Int(previewArea.center.x) - width/2
        let y = Int(previewArea.center.y)
        textLayer.frame = CGRect(x: x, y: y, width: width, height: height)
        barcodeReader.setupCamera()
    }
    
    private func addActions() {
        reStartButton.rx.tap
            .subscribe(with: self, onNext: { Object, _ in
                Object.barcodeReader.setupCamera()
            })
            .disposed(by: disposeBag)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        cameraSettingView.isHidden = AVCaptureDevice.authorizationStatus(for: AVMediaType.video) == .authorized
        barcodeReader.setupCamera()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        barcodeReader.quitSession()
    }

    private func bind() {
        let input = BarcodeReadViewModel.Input(
            barcode: barcodeReader.barcodeObservable,
            showDetailButtonTapped: showDetailButton.rx.tap.asSignal(),
            cameraSettingButtonTapped: cameraSettingButton.rx.tap.asSignal()
        )
        
        barcodeReader.sessionRunning
            .drive(caputureResultStackView.rx.isHidden)
            .disposed(by: disposeBag)

        barcodeReader.sessionRunning
            .map { !$0 }
            .drive(captureDiscriptionStackView.rx.isHidden)
            .disposed(by: disposeBag)
        
        barcodeReader.sessionRunning
            .asObservable()
            .subscribe(with: self, onNext: { Object, Bool in
                Object.textLayer.isHidden = Bool
            })
            .disposed(by: disposeBag)
        
        NotificationCenter.default.rx.notification(UIApplication.didBecomeActiveNotification)
            .subscribe(with: self, onNext: { Object, _ in
                Object.cameraSettingView.isHidden = AVCaptureDevice.authorizationStatus(for: AVMediaType.video) == .authorized
            })
            .disposed(by: disposeBag)

        let output = viewModel.transform(input: input)
        
        output.url.asObservable()
            .filter { $0 != nil }
            .subscribe(with: self, onNext: { Object, String in
                AudioServicesPlaySystemSound(SystemSoundID(kSystemSoundID_Vibrate))
                Object.barcodeReader.quitSession()
            })
            .disposed(by: disposeBag)
    }
}
