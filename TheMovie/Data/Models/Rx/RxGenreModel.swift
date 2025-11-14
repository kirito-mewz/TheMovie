//
//  RxGenreModel.swift
//  TheMovie
//
//  Created by Kiyotaka Kirito on 14/11/2025.
//

import RxSwift

protocol RxGenreModel {
    
    func getGenres() -> Observable<[Genre]>
    
}

final class RxGenreModelImpl: BaseModel, RxGenreModel {
    
    static let shared: RxGenreModel = RxGenreModelImpl()
    private let rxRepo: RxGenreRepository = RxGenreRepositoryImpl.shared
    
    private let disposeBag = DisposeBag()
    
    private override init() { }
    
    func getGenres() -> Observable<[Genre]> {
        rxNetworkAgent.fetchGenres(withEndpoint: .genres)
            .subscribe { [weak self] genres in
                self?.rxRepo.saveGenres(genres: genres)
            } onError: { error in
                print("\(#function) \(error)")
            }
            .disposed(by: disposeBag)
        return self.rxRepo.getGenres()
    }
    
}
