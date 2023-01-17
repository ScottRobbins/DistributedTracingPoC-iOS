import Foundation

class Cache {
    static let shared = Cache()
    
    var authors: [Author]?
    var books: [Int: [Book]] = [:]
    
    func getAuthors() async throws -> [Author]? {
        return try await SpanUtils.startSpan("get-authors-from-cache") { span in
            span.attributes["cache-hit"] = authors != nil && (!(authors?.isEmpty ?? true))
            return authors
        }
    }
    
    func getBooks(authorId: Int) async throws -> [Book]? {
        return try await SpanUtils.startSpan("get-books-from-cache") { span in
            span.attributes["cache-hit"] = books[authorId] != nil
            span.attributes["author_id"] = authorId
            return books[authorId]
        }
    }
    
    func saveAuthors(_ authors: [Author]) async throws {
        try await SpanUtils.startSpan("save-authors-to-cache") { span in
            span.attributes["author_ids"] = authors.map { "\($0.id)" }.joined(separator: ", ")
            self.authors = authors
        }
    }
    
    func saveBooks(_ books: [Book], authorId: Int) async throws {
        try await SpanUtils.startSpan("save-books-to-cache") { span in
            span.attributes["books"] = books.map(\.name).joined(separator: ", ")
            span.attributes["author_id"] = authorId
            
            self.books[authorId] = books
        }
    }
}
