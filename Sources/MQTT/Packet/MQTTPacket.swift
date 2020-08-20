import Foundation

public class MQTTPacket {
    let fixedHeader: FixedHeader
    
    init(packetType: PacketType, flags: UInt8) {
        self.fixedHeader = FixedHeader(packetType: packetType, flags: flags)
    }
}

public class MQTTSendPacket: MQTTPacket {
    func encode(variableHeader: DataEncodable?, payload: DataEncodable?) -> Data {
        var body = Data()
        if let variableHeader = variableHeader {
            body.append(variableHeader.encode())
        }
        if let payload = payload {
            body.append(payload.encode())
        }
        var data = Data()
        data.append(fixedHeader.byte1)
        data.append(encodeRemainLen(body.count))
        data.append(body)
        return data
    }
    
    func encode() -> Data {
        encode(variableHeader: nil, payload: nil)
    }
}

public class MQTTRecvPacket: MQTTPacket {
    init(data: Data) throws {
        fatalError("subclass must override")
    }
    
    override init(packetType: PacketType, flags: UInt8) {
        super.init(packetType: packetType, flags: flags)
    }
}
