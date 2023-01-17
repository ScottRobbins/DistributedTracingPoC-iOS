//
//  DistributedTracingPoCApp.swift
//  DistributedTracingPoC
//
//  Created by Scott Robbins on 1/16/23.
//

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
        
        let rootSpan = InstrumentationSystem.tracer.startSpan("application-launched", baggage: .topLevel)
        rootSpan.addEvent(.init(name: "application-launched"))
        defer { rootSpan.end() }
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
