//
//  NetworkManagerProtocol.swift
//  StreamChat
//
//  Created by 최정민 on 2021/08/16.
//

import Foundation

protocol URLSessionConfigurationProtocol {
    var `default`: URLSessionConfiguration { get }
    var protocolClasses: [AnyClass]? { get set }
}
