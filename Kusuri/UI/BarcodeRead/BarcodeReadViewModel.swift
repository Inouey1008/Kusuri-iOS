//
//  CameraViewReactor.swift
//  Kusuri
//
//  Created by Yus Inoue on 2021/10/01.
//

import Foundation
import RxSwift
import RxCocoa
import Vision

final class BarcodeReadViewModel {
    var router: BarcodeReadRouter!
    private let disposeBag = DisposeBag()
    
    struct Input {
        let barcode: Driver<VNBarcodeObservation>
//        let reStartButtonClicked: Signal<()>
    }

    struct Output {
        let url: Driver<String?>
        let resultIsHidden: Driver<Bool>
    }
    
    func transform(input: Input) -> Output {
        let url = input.barcode
            .filter { barcode in
                return barcode.symbology == .gs1DataBarLimited || barcode.symbology == .gs1DataBar
            }
            .map { barcode -> String? in
                return barcode.payloadStringValue
            }
        
        let resultIsHidden = url.map { $0 == nil }
        
        return Output(
            url: url,
            resultIsHidden: resultIsHidden
        )
    }
}
