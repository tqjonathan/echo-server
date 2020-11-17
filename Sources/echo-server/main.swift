/* Server echo UDP.... */

import Socket
import Foundation

// let port = 7667

// struct Point {
//     var x: Double
//     var y: Double
// }

do {
    let port = Int(CommandLine.arguments[1])!

    // socket servidor
    let serverSocket = try Socket.create(family: .inet, type: .datagram, proto: .udp)
    // escucha en un puerto especifico
    try serverSocket.listen(on: port)
    print("listening on \(port)")
    // Buffer con determinada capacidad para almacenar datos
    var buffer = Data(capacity: 1000)

    repeat {
        // extrae datos y direccion del ciente del datagrama 
        let (bytesRead, clientAddress) = try serverSocket.readDatagram(into: &buffer)
        if let address = clientAddress {
            let (clientHostname, clientPort) = Socket.hostnameAndPort(from: address)!
            print("Received lenght \(bytesRead) from \(clientHostname):\(clientPort)")
            
            //accedemos a los bytes del buffer de recepcion
            // var offset = 0
            // let point = buffer.withUnsafeBytes {
            //     $0.load(fromByteOffset: offset ,as: Point.self)
            // }
            // offset += MemoryLayout<Point>.size
            // print("Point: \(point)")
            // let number = buffer.withUnsafeBytes {
            //     $0.load(fromByteOffset: offset, as: Int.self)
            // }
            // print("Number: \(number)")
            
            let message = String(decoding: buffer, as: UTF8.self)
            print("Client Message: \(message)\n")
            let reply = "Server reply: \(message)\n"
            try serverSocket.write(from: reply, to: address)//devuelve el mensaje al cliente
        }
        buffer.removeAll()
    } while true
} catch let error {
    print("Connection error: \(error)")
}
    