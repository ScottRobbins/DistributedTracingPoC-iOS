import SwiftUI
import NIO
import OpenTelemetry
import Tracing
import OtlpGRPCSpanExporting

@main
struct DistributedTracingPoCApp: App {
    
    init() {
        let group = MultiThreadedEventLoopGroup(numberOfThreads: 1)
        let exporter = OtlpGRPCSpanExporter(
            config: OtlpGRPCSpanExporter.Config(
                eventLoopGroup: group
            )
        )
        let processor = OTel.SimpleSpanProcessor(exportingTo: exporter)
        let otel = OTel(serviceName: "distributed-tracing-poc-app", eventLoopGroup: group, processor: processor)

        try! otel.start().wait()
        InstrumentationSystem.bootstrap(otel.tracer())
        
        Task {
            try await SpanUtils.startSpan("initializing-application") { span in
                span.addEvent(.init(name: "application-launched"))
            }
        }
    }
    
    var body: some Scene {
        WindowGroup {
            AuthorsView()
        }
    }
}
