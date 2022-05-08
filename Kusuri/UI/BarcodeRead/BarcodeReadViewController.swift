//
//  CameraViewController.swift
//  Kusuri
//
//  Created by Yus Inoue on 2021/08/29.
//

import Vision
import AVFoundation
import UIKit
import SwiftUI
import SafariServices
import RxSwift
import SnapKit

//
//struct BarcodeViewController_Representable: UIViewControllerRepresentable {
//    func makeUIViewController(context: Context) -> BarcodeReadViewController {
//        return BarcodeReadViewController()
//    }
//
//    func updateUIViewController(_ : BarcodeReadViewController, context: Context) { }
//}
//
//struct BarcodeViewController_Previews: PreviewProvider {
//    static var previews: some View {
//        return BarcodeViewController_Representable()
//            .previewDevice("iPad (9th generation)")
//    }
//}

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
        let height = self.view.frame.height
        let width = self.view.frame.width
        layer.frame = CGRect(x: width * 0.1, y: height * 0.1, width: width * 0.8, height: height * 0.3)
        layer.backgroundColor = UIColor.clear.cgColor
        layer.videoGravity = .resizeAspectFill
        layer.borderColor = UIColor.black.cgColor
        layer.borderWidth = 2
        return layer
    }()
    
    private let descriptionArea: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        view.layer.borderWidth = 2
        view.layer.borderColor = UIColor.border.cgColor
        return view
    }()
    
    private let capturingView: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        return view
    }()
    
    private let barcodeLabel: UILabel = {
        let label = UILabel()
        label.text = "バーコードを撮影枠内に映してください\n読み取りが成功すると、添付文書を閲覧できます。"
        label.textColor = .text
        label.font = .mediumRegular
        label.backgroundColor = .clear
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
    }()
    
    private let barcodeImageView: UIImageView = {
        let imageView = UIImageView(image: UIImage(systemName: "barcode.viewfinder"))
        imageView.tintColor = .primary
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private let resultArea: UIStackView = {
        let stackView = UIStackView()
        stackView.alignment = .fill
        stackView.axis = .vertical
        stackView.distribution = .equalSpacing
        stackView.isHidden = true
        return stackView
    }()
    
    private let gtinArea: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        view.layer.borderWidth = 2
        view.layer.borderColor = UIColor.border.cgColor
        return view
    }()
    
    private let gtinCenterBorder: UIView = {
        let view = UIView()
        view.backgroundColor = .border
        return view
    }()
    
    private let gtinTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "商品コード(GTIN)"
        label.textColor = .text
        label.font = .mediumRegular
        label.backgroundColor = .clear
        label.textAlignment = .left
        return label
    }()
    
    private let gtinDetailLabel: UILabel = {
        let label = UILabel()
        label.text = "てすと"
        label.textColor = .text
        label.font = .mediumRegular
        label.textAlignment = .left
        return label
    }()
    
    private let detailButton: UIButton = {
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
    
    private lazy var barcodeReader = Gs1BarcodeHandler(previewLayer: previewLayer)

    override func loadView() {
        super.loadView()
        view.isUserInteractionEnabled = true
        view.backgroundColor = .backgroundCover
        barcodeReader.setupCamera()
        addSubViews()
        adjustLayout()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
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
        navigationController?.navigationBar.prefersLargeTitles = false
        navigationController?.navigationBar.isTranslucent = false
        
        previewLayer.addSublayer(textLayer)
        
        view.addSubview(capturingView)
        capturingView.addSubview(barcodeLabel)
        capturingView.addSubview(barcodeImageView)
        
        view.addSubview(resultArea)
        resultArea.addSubview(detailButton)
        resultArea.addSubview(reStartButton)
        resultArea.addSubview(gtinArea)
        gtinArea.addSubview(gtinTitleLabel)
        gtinArea.addSubview(gtinDetailLabel)
        gtinArea.addSubview(gtinCenterBorder)
    }
    
    private func adjustLayout() {
        previewArea.snp.makeConstraints {
            $0.centerX.equalTo(previewLayer.frame.midX)
            $0.centerY.equalTo(previewLayer.frame.midY)
            $0.size.equalTo(previewLayer.frame.size)
        }
        
        capturingView.snp.makeConstraints {
            $0.top.equalTo(previewArea.snp.bottom).offset(16)
            $0.left.right.equalToSuperview().inset(16)
            $0.bottom.equalTo(view.safeAreaLayoutGuide)
        }
        barcodeLabel.snp.makeConstraints {
            $0.top.left.right.equalToSuperview()
            $0.height.equalTo(80)
        }
        barcodeImageView.snp.makeConstraints {
            $0.top.equalTo(barcodeLabel.snp.bottom).offset(16)
            $0.left.right.equalToSuperview()
            $0.height.equalTo(UIDevice.current.separateValue(forPad: 120, forPhone: 150))
        }
        
        resultArea.snp.makeConstraints {
            $0.top.equalTo(previewArea.snp.bottom).offset(16)
            $0.left.right.equalToSuperview().inset(16)
            $0.bottom.equalToSuperview()
        }
        gtinArea.snp.makeConstraints {
            $0.bottom.equalTo(detailButton.snp.top).offset(-20)
            $0.left.right.equalToSuperview().inset(16)
            $0.height.equalTo(44)
        }
        gtinTitleLabel.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.left.right.equalToSuperview().inset(8)
            $0.height.equalTo(20)
        }
        gtinCenterBorder.snp.makeConstraints {
            $0.top.equalTo(gtinTitleLabel.snp.bottom)
            $0.left.right.equalToSuperview()
            $0.height.equalTo(2)
        }
        gtinDetailLabel.snp.makeConstraints {
            $0.bottom.equalToSuperview()
            $0.left.right.equalToSuperview().inset(8)
            $0.height.equalTo(20)
        }
        detailButton.snp.makeConstraints {
            $0.bottom.equalTo(reStartButton.snp.top).offset(-20)
            $0.left.right.equalToSuperview().inset(16)
            $0.height.equalTo(44)
        }
        reStartButton.snp.makeConstraints {
            $0.bottom.equalToSuperview().inset(100)
            $0.left.right.equalToSuperview().inset(16)
            $0.height.equalTo(44)
        }
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
            barcode: barcodeReader.barcodeObservable
        )
        
        barcodeReader.sessionRunning
            .drive(resultArea.rx.isHidden)
            .disposed(by: disposeBag)
        
        barcodeReader.sessionRunning
            .map { !$0 }
            .drive(capturingView.rx.isHidden)
            .disposed(by: disposeBag)
        
        let output = viewModel.transform(input: input)
        
        output.url.asObservable()
            .subscribe (onNext: { [weak self] url in
                guard let self = self else { return }
                self.showTextLayer("見つかりました！")
                AudioServicesPlaySystemSound(SystemSoundID(kSystemSoundID_Vibrate))
                self.barcodeReader.quitSession()
            })
            .disposed(by: disposeBag)
        
        output.url
            .drive(gtinDetailLabel.rx.text)
            .disposed(by: disposeBag)
       
        detailButton.rx.tap
            .asObservable()
            .withLatestFrom(output.url)
            .subscribe(onNext: { [weak self] url in
                guard let self = self else { return }
                self.showDrugInfo(url: url!)
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
    
    private func showDrugInfo(url: String) {
        let webPage = "https://www.pmda.go.jp/PmdaSearch/bookSearch/01/\(url.dropFirst(2))"
        let safariVC = SFSafariViewController(url: NSURL(string: webPage)! as URL)
        safariVC.modalPresentationStyle = .formSheet
        self.present(safariVC, animated: true, completion: nil)
    }
}
