//
//  ViewController.swift
//  RepeatedMoyaRequests
//
//  Created by Sam Watts on 01/02/2017.
//  Copyright © 2017 Sam Watts. All rights reserved.
//

import UIKit
import RxSwift

extension ObservableType where E == Int {
    
    func test() -> Observable<(E, E)> {
        return flatMap { _ -> Observable<(E, E)> in
            return Observable.combineLatest(self.double(), self.triple()) { ($0, $1) }
        }
    }
    
//    func test() -> Observable<(E, E)> {
//        return flatMap { value -> Observable<(E, E)> in
//            return Observable.just((value * 2, value * 3))
//        }
//    }
    
    func double() -> Observable<E> {
        return self.map { num in
            print("doubling: \(num)")
            return num * 2
        }
    }
    
    func triple() -> Observable<E> {
        return self.map { num in
            print("tripling: \(num)")
            return num * 3
        }
    }
    
}

class ViewController: UIViewController {
    
    static var currentNumber: Int = 0
    
    let disposeBag = DisposeBag()

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        let baseObservable: Observable<Int> = Observable.create { observer in
            
            ViewController.currentNumber += 1
            let value = ViewController.currentNumber
            
            print("returning value: \(value)")
            
            observer.onNext(value)
            observer.onCompleted()

            return Disposables.create()
        }
        
        baseObservable
            .test()
            .subscribe { event in
                print("after test: \(event)")
            }
            .addDisposableTo(disposeBag)
    }
}

