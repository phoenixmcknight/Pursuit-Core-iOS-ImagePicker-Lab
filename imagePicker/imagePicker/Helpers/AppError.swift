//
//  AppError.swift
//  Elements
//
//  Created by Phoenix McKnight on 9/19/19.
//  Copyright © 2019 Pursuit. All rights reserved.
//

import Foundation

enum AppError: Error {
    case unauthenticated
    case invalidJSONResponse
    case couldNotParseJSON(rawError: Error)
    case noInternetConnection
    case badURL
    case badStatusCode
    case noDataReceived
    case notAnImage
    case other(rawError: Error)
}
