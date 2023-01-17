import Foundation
import Tracing

extension URLSession {
    static func dataWithTracing(from url: URL) async throws -> (Data, URLResponse) {
        return try await SpanUtils.startSpan("HTTP GET \(url.path)") { span in
            span.attributes["http.method"] = "GET"
            span.attributes["http.url"] = url.absoluteString
            
            let config = URLSessionConfiguration.default
            
            InstrumentationSystem.instrument.inject(
                span.baggage,
                into: &config.httpAdditionalHeaders,
                using: HTTPHeadersInjector()
              )
            
            let (data, response) = try await URLSession.init(configuration: config).data(from: url)
            
            span.attributes["http.status_code"] = (response as? HTTPURLResponse)?.statusCode
            
            return (data, response)
        }
    }
}

struct HTTPHeadersInjector: Injector {
    func inject(_ value: String, forKey key: String, into carrier: inout [AnyHashable : Any]?) {
        if var carrier = carrier {
            carrier[key] = value
        } else {
            carrier = [key: value]
        }
    }
    
    typealias Carrier = [AnyHashable: Any]?
    
    public init() {}
}
