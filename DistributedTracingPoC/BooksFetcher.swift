struct BooksFetcher {
    func getBooks(authorId: Int) async throws -> [Book] {
        return try await SpanUtils.startSpan("get-books") { span in
            span.attributes["author_id"] = authorId
            
            let cache = Cache.shared
            let network = Network()
            
            if let cachedBooks = try? await cache.getBooks(authorId: authorId) {
                return cachedBooks
            } else {
                let books = try await network.getBooks(authorId: authorId)
                try? await cache.saveBooks(books, authorId: authorId)
                return books
            }
        }
    }
}
