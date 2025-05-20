//
//  Fetcher.swift
//  NetworkLayer
//
//  Created by Глеб Капустин on 19.05.2025.
//

import Foundation
import RxSwift

public final class Fetcher {
    private lazy var decoder = JSONDecoder()

    public init() {}
    public func fetchUsers() -> Observable<UsersEntry> {
        let url = NetworkLayer.Endpoint
            .users
            .url

        return fetch(url: url)
    }

    public func fetchStatistics() -> Observable<StatisticsEntry> {
        let url = NetworkLayer.Endpoint
            .statistics
            .url

        return fetch(url: url)
    }

}

private extension Fetcher {
    func fetch<T: Decodable>(url: URL) -> Observable<T> {
       Observable.create { [weak self] observer in
           let task = URLSession.shared.dataTask(with: url) { [weak self] data, response, error in
               guard let self else { return }
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

               do {
                   let decodedObject = try self.decoder.decode(T.self, from: data)
                   observer.onNext(decodedObject)
                   observer.onCompleted()
               } catch {
                   observer.onError(NetworkError.decodingFailed(error))
               }

           }

           task.resume()

           return Disposables.create {
               task.cancel()
           }
       }
   }
}
