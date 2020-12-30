//
//  WebSocket.swift
//  
//
//  Created by SparrowTek on 12/20/20.
//

import Foundation
import Combine

enum WebSocketError: Error {
    case incomingMessageFailed(_: Error)
    case sendStringMessageFailed(_: Error)
    case sendDataMessageFailed(_: Error)
    case dataEncodingFailed(_: Error)
    case pingError(_:Error)
    case notConnected
    case unknownMessageReceived
}

enum WebSocketMessage {
    case string(_: String)
    case data(_: Data)
}

class WebSocket: NSObject {
    var socketConnection:  URLSessionWebSocketTask?
    var webSocketSubject = PassthroughSubject<Result<WebSocketMessage, WebSocketError>, Never>()
    
    func connectToSocket(at url: URL) {
        socketConnection = URLSession.shared.webSocketTask(with: url)
        socketConnection?.resume()
        listen()
    }
    
    func disconnect() {
        socketConnection?.cancel()
    }
    
    func ping() {
        socketConnection?.sendPing { [weak self] error in
            if let error = error {
                self?.webSocketSubject.send(.failure(.pingError(error)))
            }
        }
    }
    
    func sendString(_ message: String) {
        guard let socketConnection = socketConnection else {
            webSocketSubject.send(.failure(.notConnected))
            return
        }
        
        let message = URLSessionWebSocketTask.Message.string(message)
        
        socketConnection.send(message) { [weak self] error in
            if let error = error {
                self?.webSocketSubject.send(.failure(.sendStringMessageFailed(error)))
            }
        }
    }
    
    func sendDataMessage<T: Encodable>(_ data: T) {
        guard let socketConnection = socketConnection else {
            webSocketSubject.send(.failure(.notConnected))
            return
        }
        
        do {
            let encoder = JSONEncoder()
            let data = try encoder.encode(data)
            let message = URLSessionWebSocketTask.Message.data(data)
            
            socketConnection.send(message) { [weak self] error in
                if let error = error {
                    self?.webSocketSubject.send(.failure(.sendDataMessageFailed(error)))
                }
            }
        } catch {
            webSocketSubject.send(.failure(.dataEncodingFailed(error)))
        }
    }
    
    func listen() {
        guard let socketConnection = socketConnection else {
            webSocketSubject.send(.failure(.notConnected))
            return
        }
        
        socketConnection.receive { [weak self] result in
            defer { self?.listen() }
            
            do {
                let message = try result.get()
                switch message {
                case .string(let string):
                    self?.webSocketSubject.send(.success(.string(string)))
                case .data(let data):
                    self?.webSocketSubject.send(.success(.data(data)))
                @unknown default:
                    self?.webSocketSubject.send(.failure(.unknownMessageReceived))
                }
            } catch {
                self?.webSocketSubject.send(.failure(.incomingMessageFailed(error)))
            }
        }
    }
}
