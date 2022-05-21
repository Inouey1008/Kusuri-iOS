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
        layer.fontSize = 20
        layer.alignmentMode = CATextLayerAlignmentMode.center
        layer.frame = CGRect(x: self.view.frame.width * 0.4 - 100, y: self.view.frame.height * 0.2 - 12, width: 200, height: 24)
        layer.cornerRadius = 4
        layer.backgroundColor = UIColor(white: 0.25, alpha: 0.5).cgColor
        layer.isHidden = true
        return layer
    }()
    
    private let previewArea = UIView()
    
    private lazy var previewLayer: AVCaptureVideoPreviewLayer = {
        let layer = AVCaptureVideoPreviewLayer()
        layer.backgroundColor = UIColor.clear.cgColor
        layer.videoGravity = .resizeAspectFill
        return layer
    }()
    
    private let descriptionArea: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        view.layer.borderWidth = 2
        view.layer.borderColor = UIColor.gray.cgColor
        return view
    }()
    
    private let captureDiscriptionArea: UIStackView = {
        let stackView = UIStackView()
        stackView.alignment = .center
        stackView.axis = .vertical
        stackView.spacing = UIDevice.current.separateValue(forPad: 88, forPhone: 44)
        stackView.distribution = .equalSpacing
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.isHidden = false
        return stackView
    }()
    
    private let barcodeLabel1: UILabel = {
        let label = UILabel()
        label.text = "バーコードを撮影枠内に映してください。"
        label.textColor = .text
        label.font = .mediumRegular
        label.backgroundColor = .clear
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
    }()
    
    private let barcodeLabel2: UILabel = {
        let label = UILabel()
        label.text = "読み取りが成功すると、添付文書を閲覧できます。"
        label.textColor = .text
        label.font = .mediumLight
        label.backgroundColor = .clear
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
    }()
    
    private let resultArea: UIStackView = {
        let stackView = UIStackView()
        stackView.alignment = .center
        stackView.axis = .vertical
        stackView.spacing = UIDevice.current.separateValue(forPad: 88, forPhone: 36)
        stackView.distribution = .equalSpacing
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
        view.layer.masksToBounds = true
        view.addSubview(previewArea)
        view.layer.addSublayer(previewLayer)
        
        let titleLabel = UILabel()
        titleLabel.text = "バーコード"
        titleLabel.textColor = .strongText
        titleLabel.font = .largeRegular
        navigationItem.titleView = titleLabel
        navigationItem.hidesSearchBarWhenScrolling = false
        navigationController?.navigationBar.tintColor = .primary
        navigationController?.navigationBar.prefersLargeTitles = false
        navigationController?.navigationBar.isTranslucent = false
        
        previewLayer.addSublayer(textLayer)
        
        view.addSubview(captureDiscriptionArea)
        captureDiscriptionArea.addArrangedSubview(barcodeLabel1)
        captureDiscriptionArea.addArrangedSubview(barcodeLabel2)
        
        view.addSubview(resultArea)
        resultArea.addArrangedSubview(showDetailButton)
        resultArea.addArrangedSubview(reStartButton)
    }
    
    private func adjustLayout() {
        previewArea.snp.makeConstraints({ make in
            make.top.equalTo(view.safeAreaLayoutGuide)
            make.bottom.equalTo(captureDiscriptionArea.snp.top).offset(-16)
            make.width.equalToSuperview()
        })

        barcodeLabel1.snp.makeConstraints({ make in
            make.width.equalToSuperview()
        })
        barcodeLabel2.snp.makeConstraints({ make in
            make.width.equalToSuperview()
        })
        captureDiscriptionArea.snp.makeConstraints({ make in
            let horizontalInset = UIDevice.current.separateValue(forPad: 88, forPhone: 22)
            let bottomInset = UIDevice.current.separateValue(forPad: 88, forPhone: 44)
            make.left.right.equalToSuperview().inset(horizontalInset)
            make.bottom.equalTo(view.safeAreaLayoutGuide).inset(bottomInset)
        })

        showDetailButton.snp.makeConstraints({ make in
            make.height.equalTo(44)
            make.width.equalToSuperview()
        })
        reStartButton.snp.makeConstraints({ make in
            make.height.equalTo(44)
            make.width.equalToSuperview()
        })
        resultArea.snp.makeConstraints({ make in
            make.center.equalTo(captureDiscriptionArea)
        })
    }
    
    override func viewWillLayoutSubviews() {
        previewLayer.frame = previewArea.frame
    }
    
    private func addActions() {
        reStartButton.rx.tap
            .subscribe(onNext: { [weak self] in
                guard let self = self else { return }
                self.barcodeReader.setupCamera()
                self.hideTextLayer()
            })
            .disposed(by: disposeBag)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        hideTextLayer()
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
            .drive(resultArea.rx.isHidden)
            .disposed(by: disposeBag)

        barcodeReader.sessionRunning
            .map { !$0 }
            .drive(captureDiscriptionArea.rx.isHidden)
            .disposed(by: disposeBag)
        
        let output = viewModel.transform(input: input)
        
        output.url.asObservable()
            .filter { $0 != nil }
            .subscribe(with: self, onNext: { Object, String in
                Object.showTextLayer(String!)
                AudioServicesPlaySystemSound(SystemSoundID(kSystemSoundID_Vibrate))
                Object.barcodeReader.quitSession()
            })
            .disposed(by: disposeBag)
    }
    
    private func showTextLayer(_ value: String) {
        DispatchQueue.main.async {
            self.textLayer.string = value
            self.textLayer.isHidden = false
        }
    }
    
    private func hideTextLayer() {
        DispatchQueue.main.async {
            self.textLayer.isHidden = true
        }
    }
}
