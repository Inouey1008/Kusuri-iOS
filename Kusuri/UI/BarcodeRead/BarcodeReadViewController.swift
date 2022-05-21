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
        label.textColor = .text
        label.font = .mediumRegular
        label.backgroundColor = .clear
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
    }()
    
    private let discriptionLabel2: UILabel = {
        let label = UILabel()
        label.text = "読み取りが成功すると、添付文書を閲覧できます"
        label.textColor = .text
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
        button.backgroundColor = .primary
        button.tintColor = .white
        button.layer.cornerRadius = 22
        return button
    }()
    
    private let reStartButton: UIButton = {
        let button = UIButton(type: .roundedRect)
        button.setTitle("もう一度読み取る", for: .normal)
        button.backgroundColor = .clear
        button.layer.borderColor = UIColor.primary.cgColor
        button.layer.borderWidth = 2
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
        view.layer.addSublayer(previewLayer)
        previewLayer.addSublayer(textLayer)
        
        descriptionArea.addSubview(captureDiscriptionStackView)
        captureDiscriptionStackView.addArrangedSubview(discriptionLabel1)
        captureDiscriptionStackView.addArrangedSubview(discriptionLabel2)
        
        descriptionArea.addSubview(caputureResultStackView)
        caputureResultStackView.addArrangedSubview(showDetailButton)
        caputureResultStackView.addArrangedSubview(reStartButton)
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
            let horizontalInset = UIDevice.current.separateValue(forPad: 88, forPhone: 44)
            make.center.equalToSuperview()
            make.left.right.equalToSuperview().inset(horizontalInset)
        })
    }
    
    override func viewWillLayoutSubviews() {
        previewLayer.frame = previewArea.frame
        
        let height = UIDevice.current.separateValue(forPad: 35, forPhone: 28)
        let width = UIDevice.current.separateValue(forPad: 400, forPhone: 270)
        let x = Int(previewArea.center.x) - width/2
        let y = Int(previewArea.center.y)
        textLayer.frame = CGRect(x: x, y: y, width: width, height: height)
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
            reStartButtonTapped: reStartButton.rx.tap.asSignal()
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
        
        let output = viewModel.transform(input: input)
        
        output.url.asObservable()
            .filter { $0 != nil }
            .subscribe(with: self, onNext: { Object, String in
                AudioServicesPlaySystemSound(SystemSoundID(kSystemSoundID_Vibrate))
                Object.barcodeReader.quitSession()
            })
            .disposed(by: disposeBag)
    }
    
    private func hideTextLayer() {
        DispatchQueue.main.async {
            self.textLayer.isHidden = true
        }
    }
}
