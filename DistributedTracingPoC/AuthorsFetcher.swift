struct AuthorsFetcher {
    func getAuthors() async throws -> [Author] {
        return try await SpanUtils.startSpan("get-authors") { span in
            let cache = Cache()
            let network = Network()
            
            if let cachedAuthors = try? await cache.getAuthors() {
                return cachedAuthors
            } else {
                let authors = try await network.getAuthors()
                try? await cache.saveAuthors(authors)
                return authors
            }
        }
    }
}
