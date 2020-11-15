/* Server echo UDP.... */

import Socket
import Foundation

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
            let message = String(decoding: buffer, as: UTF8.self)
            print("Client Message: \(message)\n")
            let reply = "Server: \(message)"
            try serverSocket.write(from: reply, to: address)//devuelve el mensaje al cliente
        }
        buffer.removeAll()
    } while true
} catch let error {
    print("Connection error: \(error)")
}
    