//
//  Scheduler.swift
//  Weather
//
//  Created by Anh Tran on 19/09/2021.
//

import Foundation
import Combine

final class Scheduler {

    static var userInitiatedScheduler: OperationQueue = {
        let operationQueue = OperationQueue()
        operationQueue.maxConcurrentOperationCount = 5
        operationQueue.qualityOfService = QualityOfService.userInitiated
        return operationQueue
    }()

    static let mainScheduler = RunLoop.main

}

