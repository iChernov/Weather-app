//
//  IconLoader.swift
//  Weather
//
//  Created by IVAN CHERNOV on 31.01.21.
//

import UIKit

enum LoadingError: Error {
    case runtimeError(String)
}

typealias ImageLoadingAction = (Result<UIImage, Error>) -> Void

class IconLoader {
    static let shared = IconLoader()
    private var runningRequests = [String: URLSessionDataTask]()
    private var savedCompletions = [String: [ImageLoadingAction]]()
    
    func loadWeatherIcon(_ iconCode: String, _ completion: @escaping (Result<UIImage, Error>) -> Void) {
            if let image = ImageCache.shared[iconCode] {
            completion(.success(image))
            return
        }
        
        if runningRequests[iconCode] != nil {
            savedCompletions[iconCode]?.append(completion)
        } else if let url = URL(string: "https://openweathermap.org/img/wn/\(iconCode)@2x.png") {
            savedCompletions[iconCode] = [completion]
            let task = URLSession.shared.dataTask(with: url) { [weak self] data, response, error in
                guard let self = self else { return }
                defer { self.runningRequests.removeValue(forKey: iconCode) }
                if let data = data, let image = UIImage(data: data) {
                    ImageCache.shared[iconCode] = image
                    if let completions = self.savedCompletions[iconCode] {
                        for savedCompletion in completions {
                            savedCompletion(.success(image))
                        }
                        self.savedCompletions[iconCode] = []
                    }
                    
                    return
                }
                guard let error = error else {
                    return
                }
                completion(.failure(error))
            }
            task.resume()
            runningRequests[iconCode] = task
        } else {
            completion(.failure(LoadingError.runtimeError("icon URL format failure")))
        }

        return
    }
}
