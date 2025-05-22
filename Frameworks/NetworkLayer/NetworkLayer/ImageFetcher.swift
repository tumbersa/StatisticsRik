//
//  ImageFetcher.swift
//  NetworkLayer
//
//  Created by Глеб Капустин on 22.05.2025.
//

import Foundation
import RxSwift

public final class ImageFetcher {

    public init() {}

    public func fetchImageData(from urlString: String) -> Observable<Data> {
        guard let url = URL(string: urlString) else {
            return Observable.error(NetworkError.invalidUrl)
        }

        return Observable.create { [weak self] observer in
            let task = URLSession.shared.dataTask(with: url) { data, response, error in
                if let error {
                    observer.onError(NetworkError.error(error))
                    return
                }

                guard let response = response as? HTTPURLResponse,
                      200..<300 ~= response.statusCode else {
                    let statusCode = (response as? HTTPURLResponse)?.statusCode ?? -1
                    observer.onError(NetworkError.statusCode(statusCode))
                    return
                }

                guard let data, !data.isEmpty else {
                    observer.onError(NetworkError.emptyData)
                    return
                }

                observer.onNext(data)
                observer.onCompleted()
            }

            task.resume()

            return Disposables.create {
                task.cancel()
            }
        }
    }
}
