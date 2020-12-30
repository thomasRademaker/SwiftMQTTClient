//
//  MQTTClient.swift
//  
//
//  Created by Thomas Rademaker on 12/20/20.
//

import Foundation
import Combine

public enum MQTTClientError: Error {
    case generic
}

public class MQTTClient {
    private var storage = Set<AnyCancellable>()
    private let webSocket = WebSocket()
    
    public func connect() {
        let url = URL(string: "ws://127.0.0.1:9001")!
        webSocket.connectToSocket(at: url)
        webSocket.webSocketSubject.sink { [weak self] result in
            switch result {
            case .success(let message):
                self?.handleWebSocketMessage(message)
            case .failure(let error):
                self?.handleWebSocketError(error)
            }
        }
        .store(in: &storage)
    }
    
    public func subscribe(to topic: String, with qos: QOS) -> AnyPublisher<ApplicationMessage, Never> {
       return Just(TestMessage())
        .eraseToAnyPublisher()
    }
    
    public func publish(to topic: String, with qos: QOS) throws {
        throw MQTTClientError.generic
    }
    
    private func handleWebSocketMessage(_ message: WebSocketMessage) {
        // This message will have to be passed to the correct subscribe publisher
        // but how??
        switch message {
        case .data(let data):
            print("data: \(data)")
            break
        case .string(let string):
            print("string: \(string)")
            break
        }
    }
    
    private func handleWebSocketError(_ error: WebSocketError) {
        // TODO: implement handleWebSocketError with a switch
    }
}

public protocol ApplicationMessage {}

private class TestMessage: ApplicationMessage {}
