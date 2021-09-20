//
//  ImageLoader.swift
//  Weather
//
//  Created by Anh Tran on 20/09/2021.
//

import Foundation
import Combine
import UIKit

public protocol ImageCacheType {
    func setImage(_ image: UIImage, key: String)
    func getImage(key: String) -> UIImage?
}

public final class ImageCache: ImageCacheType {
    
    private let imageCache = Cache<String,UIImage>(.system)
    
    public init(){}
    
    public func setImage(_ image: UIImage, key: String) {
        imageCache.insert(image, forKey: key)
    }
    
    public func getImage(key: String) -> UIImage? {
        return imageCache.value(forKey: key)
    }
}

protocol ImageLoaderType {
    func loadImage(from url: URL, size: CGSize) -> AnyPublisher<UIImage?, Never>
}
public final class ImageLoader: NSObject {
    public static let shared = ImageLoader()

    private let cache: ImageCacheType
    private let queue = DispatchQueue(label: "ImageLoader")
    private var publishersCache = [URL:AnyPublisher<UIImage?, Never>]()
    public init(cache: ImageCacheType = ImageCache()) {
        self.cache = cache
        super.init()
    }
    
    public func loadImage(from url: URL, size: CGSize) -> AnyPublisher<UIImage?, Never> {
        if let image = cache.getImage(key: makeCacheKey(url, size: size)) {

            print("cached from last download \(url)")
            return Just(image).eraseToAnyPublisher()
        }

        if let publisher = publishersCache[url] {

            print("reuse form last download \(url)")
            return publisher
        }
        print("start download \(url), \(size)")
        let publisher = URLSession.shared.dataTaskPublisher(for: url)
            .map { (data, response) -> UIImage? in
                return UIImage(data: data)?.resize(size.width)
            }
            .catch { error in return Just(nil) }
            .handleEvents(receiveOutput: {[unowned self] image in
                guard let image = image else { return }
                self.cache.setImage(image, key: makeCacheKey(url, size: size))
            },receiveCompletion: { [weak self] _ in
                self?.publishersCache[url] = nil
            })
            .subscribe(on: Scheduler.backgroundScheduler)
            .receive(on: Scheduler.mainScheduler)
            .share()
//            .print("Image loading \(url):")
            .eraseToAnyPublisher()
        publishersCache[url] = publisher
        return publisher
    }
    
    private func makeCacheKey(_ url: URL, size: CGSize) -> String {
        return url.absoluteString + NSCoder.string(for: size)
    }
}

