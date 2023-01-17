import Tracing

struct SpanUtils {
    static func startSpan(_ operationName: String) -> Span {
        if let parentSpan = TracingValues.parentSpan {
            return InstrumentationSystem.tracer.startSpan(operationName, baggage: parentSpan.baggage)
        } else {
            return InstrumentationSystem.tracer.startSpan(operationName, baggage: .topLevel)
        }
    }
    
    static func startSpan<T>(_ operationName: String, closure: (Span) async throws -> T) async throws -> T {
        let span = SpanUtils.startSpan(operationName)
        defer { span.end() }
        return try await TracingValues.$parentSpan.withValue(span) {
           try await closure(span)
        }
    }
}
