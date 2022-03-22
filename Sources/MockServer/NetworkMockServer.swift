//
// Copyright © 2022 Stream.io Inc. All rights reserved.
//

import Foundation
import Swifter

/// This func mocks given HTTP request with your HTTP Response
public typealias MockResponse = ((HttpRequest) -> HttpResponse)

// MARK: Network mock server

/// NOTE: Every HTTP request is described with a type-safe wrapper conforming to `EndpointMock` protocol.
///       Possible HTTP responses for given HTTP request are then described as e.g. associated values on enum that conforms to `EndpointMockResponse` protocol.
///
/// The main goal of using `EndpointMock` and corresponding `EndpointMockResponse` is to help engineers and SETs to stop copy-pasting the stubbed payloads and URIs all across the project(s).
///
/// Once you create your `Mocks` and `Mocked responses` you'll no longer have a hard time to test a specific scenarios, that require network stubbing.
public final class NetworkMockServer {

    /// Mock server url in localhost
    public var serverUrl: String {
        "http://localhost:\(String(port))"
    }

    public init() {}

    private(set) var port: UInt16!

    /// Swifter server
    public let server = HttpServer()

    /// Starts the mock server
    /// - Parameters:
    ///   - port: A range of ports on localhost, default range: `8080..<10000`
    ///   - maximumOfAttempts: describes maximum attempts when the mock server will try to start
    public func start(port: in_port_t = in_port_t.random(in: 8080..<10000),
                      maximumOfAttempts: Int = 10) {

        // Try until maximum count reached
        guard maximumOfAttempts > 0 else { fatalError("Unable to start mock server!") }

        do {
            try server.start(port, forceIPv4: true)
            self.port = port
            print("Server has started ( port = \(port) ).")
            usleep(UInt32(0.5 * 1000000))
        } catch SocketError.bindFailed(let message) where message == "Address already in use" {
            start(maximumOfAttempts: maximumOfAttempts - 1)
        } catch {
            print("Server start error: \(error)")
        }
    }

    /// Stops the mock server
    public func stop() {
        server.stop()
    }

    /// Stubs HTTP endpoint with given `EndpointMock`
    /// - Parameter endpoint: EndpointMock describes HTTP method, URI path and `MockResponse`
    ///
    /// Example:
    ///         mockServer.stub(endpoint: CommentsGET(with: .agentResponseWithHyperlink))
    public func stub<T: EndpointMock>(endpoint: T) {
        stub(endpoint.method, endpoint.path, endpoint.response)
    }

    /// Stubs HTTP endpoint with given method, path and mocked response
    ///
    /// - Parameters:
    ///   - method: HTTP method, e.g. 'GET'
    ///   - path: URI path in string format, e.g. 'categories/1'
    ///   - response: closure that provides mocked HTTP response for given HTTP request
    public func stub(_ method: HttpMethod,
                     _ path: String,
                     _ response: @escaping ((HttpRequest) -> HttpResponse)) {
        switch method {
        case .GET:
            server.GET[path] = response
        case .PUT:
            server.PUT[path] = response
        case .POST:
            server.POST[path] = response
        case .DELETE:
            server.DELETE[path] = response
        case .PATCH:
            server.PATCH[path] = response
        case .HEAD:
            server.HEAD[path] = response
        }
    }
}

/// Http Methods
public enum HttpMethod: String {

    /// GET
    case GET

    /// PUTH
    case PUT

    /// POST
    case POST

    /// DELETE
    case DELETE

    /// PATCH
    case PATCH

    /// HEAD
    case HEAD
}

// MARK: Mocked endpoint protocols

/// This interface describes a HTTP endpoint and related mocked response
///
///   Example Declaration:
///         public struct CommentsGET: EndpointMock {
///             public var method = HttpMethod.GET
///             public var path = "api/mobile/requests/*/comments.json"
///             public let responseType: CommentsEndpointResponse
///
///             public init(with responseType: CommentsEndpointResponse = .veryLongConversation) {
///                 self.responseType = responseType
///             }
///         }
///   Usage:
///         CommentsGET() will create a mocked endpoint that can be passed to `NetworkMockServer`'s `stub` func
public protocol EndpointMock {
    associatedtype ResponseType = EndpointMockResponse

    /// HTTP method
    var method: HttpMethod { get }

    /// URI path, e.g. "categories/1"
    var path: String { get }

    /// Type-safe wrapper describing your mocked response,
    /// usually represented as enum with associated values
    var responseType: ResponseType { get }

    /// Mocked HTTP response for given HTTP Request.
    ///
    /// NOTE: Don't implemented this property, this is automatically inferred & computed var that passes the `response` variable from given `responseType`
    var response: MockResponse { get }
}

public extension EndpointMock where ResponseType: EndpointMockResponse {
    var response: MockResponse {
        responseType.response
    }
}

/// Type-safe wrapper that describes the mocked response
///
///   Example Declaration:
///         public enum CommentsEndpointResponse: EndpointMockResponse {
///             case veryLongConversation
///             case agentResponseWithHyperlink
///
///             public var response: MockResponse {
///                 switch self {
///                     case .veryLongConversation:
///                         return { _ in
///                             HttpResponse.ok(.jsonFile("Comments_veryLongConversation"))
///                         }
///                     case .agentResponseWithHyperlink:
///                         return { _ in
///                             HttpResponse.ok(.jsonFile("Comments_agentResponseWithHyperlink"))
///                         }
///                 }
///             }
///         }
///   Usage with `EndpointMock`:
///         CommentsGET(.agentResponseWithHyperlink)
public protocol EndpointMockResponse {
    var response: MockResponse { get }
}
