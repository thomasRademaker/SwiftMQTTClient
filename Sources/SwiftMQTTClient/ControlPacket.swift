//
//  ControlPacket.swift
//  
//
//  Created by Thomas Rademaker on 12/20/20.
//

public enum ControlPacket {
    case connect
    case connack
    case publish
    case puback
    case pubrec
    case pubrel
    case pubcomp
    case subscribe
    case suback
    case unsubscribe
    case unsuback
    case pingreq
    case pingres
    case disconnect
    case auth
}
