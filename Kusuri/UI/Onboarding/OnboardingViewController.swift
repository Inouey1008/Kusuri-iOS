//
//  OnboardingViewController.swift
//  Kusuri
//
//  Created by Yusuke Inoue on 2023/07/10.
//

import UIKit
import SnapKit

final class OnboardingViewController: UIViewController {
    private let pageSize: Int = 4   // !! ページは 1 以上であること。
    
    private let titles: [String] = [
        "ようこそ",
        "医薬品名検索",
        "バーコード読み取り",
        "さあ、はじめましょう",
    ]
    
    private let subTitles: [String] = [
        "「添付文書 Pocket」は医薬品の添付文書を簡単に検索することができるアプリです。",
        "検索したい医薬品名を入力して、添付文書を検索できます。",
        "医薬品のバーコードを読み込んで、添付文書を表示することができます。",
        "「はじめる」を押してアプリの利用を開始しましょう！",
    ]
    
    private let imageNames: [String] = [
        "OnboardingWelcome",
        "OnboardingSearch",
        "OnboardingBarcode",
        "OnboardingLetsStart",
    ]
    
    private let headerArea: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        return view
    }()
    
    private lazy var closeButton: UIButton = {
        let button = UIButton()
        let image = UIImage(systemName: "xmark.circle.fill")
        button.setImage(image, for: .normal)
        button.imageView?.tintColor = .gray
        button.imageView?.contentMode = .scaleAspectFill
        button.contentHorizontalAlignment = .fill
        button.contentVerticalAlignment = .fill
        button.addAction(for: .touchUpInside, { [weak self] in
            guard let self = self else { return }
            Configuration.firstLaunch = false
            UserStateManager.shared.updateUserState()
        })
        return button
    }()
    
    private lazy var scrollView: UIScrollView = {
        var scrollView = UIScrollView(frame: self.view.frame)
        configureScrollView(&scrollView)
        return scrollView
    }()
    
    private lazy var pageControl: UIPageControl = {
        let pageControl = UIPageControl()
        pageControl.pageIndicatorTintColor = .weakGray
        pageControl.currentPageIndicatorTintColor = .primary
        pageControl.currentPage = 0
        pageControl.isUserInteractionEnabled = false
        pageControl.numberOfPages = self.pageSize
        return pageControl
    }()
    
    private lazy var nextButton: UIButton = {
        let button = UIButton(type: .roundedRect)
        button.setTitle("次へ進む", for: .normal)
        button.titleLabel?.font = .mediumRegular
        button.backgroundColor = .primary
        button.tintColor = .white
        button.layer.cornerRadius = 22
        button.addAction(for: .touchUpInside) { [weak self] in
            guard let self = self else { return }
            self.goToNextPage()
        }
        return button
    }()
    
    private lazy var previousButton: UIButton = {
        let button = UIButton(type: .roundedRect)
        button.setTitle("戻る", for: .normal)
        button.titleLabel?.font = .mediumRegular
        button.backgroundColor = .clear
        button.layer.borderColor = UIColor.primary.cgColor
        button.layer.borderWidth = 2
        button.layer.cornerRadius = 22
        button.addAction(for: .touchUpInside) { [weak self] in
            guard let self = self else { return }
            self.backToPreviousPage()
        }
        return button
    }()
    
    private lazy var startButton: UIButton = {
        let button = UIButton(type: .roundedRect)
        button.setTitle("はじめる", for: .normal)
        button.titleLabel?.font = .mediumRegular
        button.backgroundColor = .primary
        button.tintColor = .white
        button.layer.cornerRadius = 22
        button.addAction(for: .touchUpInside) { [weak self] in
            guard let self = self else { return }
            Configuration.firstLaunch = false
            UserStateManager.shared.updateUserState()
        }
        return button
    }()
    
    private let buttonArea: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = UIDevice.current.separateValue(forPad: 44, forPhone: 16)
        stackView.alignment = .fill
        stackView.distribution = .fillEqually
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .backgroundCover
        headerArea.addSubview(closeButton)
        view.addSubview(headerArea)
        view.addSubview(scrollView)
        view.addSubview(pageControl)
        buttonArea.addArrangedSubview(previousButton)
        buttonArea.addArrangedSubview(nextButton)
        buttonArea.addArrangedSubview(startButton)
        view.addSubview(buttonArea)
        previousButton.isHidden = true
        startButton.isHidden = true
        adjustLayout()
    }
    
    private func adjustLayout() {
        closeButton.snp.makeConstraints({ make in
            let rightInset = UIDevice.current.separateValue(forPad: 24, forPhone: 16)
            let height = UIDevice.current.separateValue(forPad: 40, forPhone: 30)
            
            make.right.equalToSuperview().inset(rightInset)
            make.centerY.equalToSuperview()
            make.height.width.equalTo(height)
        })
        headerArea.snp.makeConstraints({ make in
            let height = UIDevice.current.separateValue(forPad: 66, forPhone: 52)
            
            make.left.top.right.equalTo(view.safeAreaLayoutGuide)
            make.height.equalTo(height)
        })
        scrollView.snp.makeConstraints({ make in
            let topOffset = UIDevice.current.separateValue(forPad: 24, forPhone: 16)
            let bottomOffset = UIDevice.current.separateValue(forPad: -24, forPhone: -16)
            make.top.equalTo(headerArea.snp.bottom).offset(topOffset)
            make.centerX.equalToSuperview()
            make.width.equalToSuperview()
            make.bottom.equalTo(pageControl.snp.top).offset(bottomOffset)
        })
        pageControl.snp.makeConstraints({ make in
            let bottomOffset = UIDevice.current.separateValue(forPad: -24, forPhone: -16)
            make.centerX.equalToSuperview()
            make.width.equalToSuperview()
            make.height.equalTo(12)
            make.bottom.equalTo(buttonArea.snp.top).offset(bottomOffset)
        })
        buttonArea.snp.makeConstraints({ make in
            let bottomInset = UIDevice.current.separateValue(forPad: 100, forPhone: 24)
            let horizontalInset = UIDevice.current.separateValue(forPad: 100, forPhone: 24)
            make.bottom.equalTo(view.safeAreaLayoutGuide).inset(bottomInset)
            make.height.equalTo(44)
            make.left.right.equalToSuperview().inset(horizontalInset)
        })
    }
    
    private func goToNextPage() {
        if pageControl.currentPage >= (pageSize - 1) { return }
        
        var frame: CGRect = scrollView.frame
        frame.origin.x = frame.size.width * CGFloat((pageControl.currentPage + 1))
        frame.origin.y = 0;
        scrollView.scrollRectToVisible(frame, animated: true)
        pageControl.currentPage = pageControl.currentPage + 1
        
        if pageControl.currentPage == 0 {
            previousButton.isHidden = true
            nextButton.isHidden = false
            startButton.isHidden = true
        } else if pageControl.currentPage == (pageSize - 1) {
            previousButton.isHidden = false
            nextButton.isHidden = true
            startButton.isHidden = false
        } else {
            previousButton.isHidden = false
            nextButton.isHidden = false
            startButton.isHidden = true
        }
    }
    
    private func backToPreviousPage() {
        if self.pageControl.currentPage <= 0 { return }
        
        var frame: CGRect = self.scrollView.frame;
        frame.origin.x = frame.size.width * CGFloat((self.pageControl.currentPage - 1))
        frame.origin.y = 0
        self.scrollView.scrollRectToVisible(frame, animated: true)
        self.pageControl.currentPage = self.pageControl.currentPage - 1
        nextButton.isHidden = false
        
        if pageControl.currentPage == 0 {
            previousButton.isHidden = true
            nextButton.isHidden = false
            startButton.isHidden = true
        } else if pageControl.currentPage == (pageSize - 1) {
            previousButton.isHidden = false
            nextButton.isHidden = true
            startButton.isHidden = false
        } else {
            previousButton.isHidden = false
            nextButton.isHidden = false
            startButton.isHidden = true
        }
    }
    
    private func configureScrollView(_ scrollView: inout UIScrollView) {
        let contentWidth = view.frame.width * CGFloat(pageSize)
        let contentHeight = view.frame.height * 0.6     // TODO: ここの値は何がいいだろう？？
        scrollView.contentSize = CGSize(width: contentWidth, height: contentHeight)
        scrollView.delegate = self
        scrollView.isPagingEnabled = true
        scrollView.backgroundColor = .clear
        scrollView.showsVerticalScrollIndicator = false
        scrollView.showsHorizontalScrollIndicator = false
        
        // コンテンツ生成
        for i in 0 ..< pageSize {
            let pageView = UIView()
            
            let imageArea = UIView()
            imageArea.backgroundColor = .white
            
            let imageView = UIImageView(image: UIImage(named: imageNames[i]))
            imageView.contentMode = .scaleAspectFit
            
            let titleLabel = UILabel()
            titleLabel.text = titles[i]
            titleLabel.numberOfLines = 0
            titleLabel.textAlignment = .center
            titleLabel.font = .largeRegular
            titleLabel.textColor = .strongText
            
            let subTitleLabel = UILabel()
            subTitleLabel.text = subTitles[i]
            subTitleLabel.numberOfLines = 0
            subTitleLabel.textAlignment = .center
            subTitleLabel.font = .mediumRegular
            subTitleLabel.textColor = .text
            
            imageArea.addSubview(imageView)
            pageView.addSubview(imageArea)
            pageView.addSubview(titleLabel)
            pageView.addSubview(subTitleLabel)
            scrollView.addSubview(pageView)
            
            imageView.snp.makeConstraints({ make in
                let edgeInsets = UIDevice.current.separateValue(forPad: 44, forPhone: 24)
                make.center.equalToSuperview()
                make.edges.equalToSuperview().inset(edgeInsets)
            })
            imageArea.snp.makeConstraints({ make in
                let width = UIDevice.current.separateValue(forPad: 420, forPhone: 240)
                make.top.equalToSuperview()
                make.centerX.equalToSuperview()
                make.width.height.equalTo(width)
            })
            titleLabel.snp.makeConstraints({ make in
                let topOffset = UIDevice.current.separateValue(forPad: 24, forPhone: 16)
                make.top.equalTo(imageArea.snp.bottom).offset(topOffset)
                make.right.left.equalToSuperview().inset(44)
            })
            subTitleLabel.snp.makeConstraints({ make in
                let topOffset = UIDevice.current.separateValue(forPad: 24, forPhone: 16)
                make.top.equalTo(titleLabel.snp.bottom).offset(topOffset)
                make.right.left.equalToSuperview().inset(24)
            })
            pageView.snp.makeConstraints({ make in
                make.top.equalToSuperview()
                make.left.equalToSuperview().offset(i * Int(view.bounds.width))
                make.width.equalToSuperview()
                make.height.equalTo(scrollView)
            })
        }
    }
}

extension OnboardingViewController: UIScrollViewDelegate {
    // UIScrollView のスクロールが停止したときに呼ばれるメソッド
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        
        if fmod(scrollView.contentOffset.x, scrollView.frame.maxX) == 0 {
            pageControl.currentPage = Int(scrollView.contentOffset.x / scrollView.frame.maxX)
        }

        // ボタンの 表示 or 非表示 判定
        if pageControl.currentPage == 0 {
            previousButton.isHidden = true
            nextButton.isHidden = false
            startButton.isHidden = true
        } else if pageControl.currentPage == (pageSize - 1) {
            previousButton.isHidden = false
            nextButton.isHidden = true
            startButton.isHidden = false
        } else {
            previousButton.isHidden = false
            nextButton.isHidden = false
            startButton.isHidden = true
        }
    }
}
