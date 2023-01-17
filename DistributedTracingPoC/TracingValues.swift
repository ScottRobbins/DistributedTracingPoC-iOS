import Tracing

enum TracingValues {
    @TaskLocal static var parentSpan: Span?
}
