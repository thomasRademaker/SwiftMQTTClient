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
//    private var storage = Set<AnyCancellable>()
//    private let webSocket = WebSocket()
    
    private var webSockets = [String: WebSocket]()
    
    //    private var port: Int?
    //    private var tls = false
    //    private var keepAlive: Int?
    //    private var clean = false
    //    private var auth = false
    //    private var userName: String?
    //    private var password: String?
    //    private var will = false
    //    private var willTopic: String?
    //    private var willMessage: Data?
    //    private var willQos: QOS?
    //    private var willRetainFlag = false
    //    private var clientId: String?
    //    private var securityPolicy: MQTTSSLSecurityPolicy?
    //    private var certificates: NSArray?
    //    private var protocolLevel: MQTTProtocolVersion

    //    connectToLast: error
    
    deinit {
        webSockets.forEach { $0.value.disconnect() }
    }
    
    public func connect() {
//        let url = URL(string: "ws://127.0.0.1:9001")!
//        webSocket.connectToSocket(at: url)
//        webSocket.webSocketSubject.sink { [weak self] result in
//            switch result {
//            case .success(let message):
//                self?.handleWebSocketMessage(message)
//            case .failure(let error):
//                self?.handleWebSocketError(error)
//            }
//        }
//        .store(in: &storage)
    }
    
    public func subscribe(to topic: String, with qos: QOS) -> AnyPublisher<ApplicationMessage, Never> {
        let webSocket = WebSocket()
        webSocket.connectToSocket(at: URL(string: "")!)
        webSockets[topic] = webSocket

        return webSocket.webSocketSubject.map { result -> ApplicationMessage in
            switch result {
            case .success(let message):
                return self.handleWebSocketMessage(message)
            case .failure(let error):
                return self.handleWebSocketError(error)
            }
        }
        .eraseToAnyPublisher()
    }
    
    public func unsubscribe(from topic: String) {
        guard let socket = webSockets[topic] else { return }
        socket.disconnect()
        webSockets.removeValue(forKey: topic)
    }
    
    public func publish(to topic: String, with qos: QOS) throws {
        throw MQTTClientError.generic
    }
    
    private func handleWebSocketMessage(_ message: WebSocketMessage) -> ApplicationMessage {
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
        
        #warning("This is a placeholder")
        return TestMessage()
    }
    
    private func handleWebSocketError(_ error: WebSocketError) -> ApplicationMessage {
        // TODO: implement handleWebSocketError with a switch
        #warning("This is a placeholder")
        return TestMessage()
    }
}

public protocol ApplicationMessage {}

private class TestMessage: ApplicationMessage {}

private class ookok {
    let client = MQTTClient()
    private var storage = Set<AnyCancellable>()
    
    func testSubscribe() {
        client.subscribe(to: "", with: .atLeastOnce)
            .sink { _ in
                
            }
            .store(in: &storage)
    }
    
    func testPublish() {
        do {
            try client.publish(to: "", with: .exactlyOnce)
        } catch {
            print("PUBLISH FAILED")
        }
    }
}
