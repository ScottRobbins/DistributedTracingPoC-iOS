import SwiftUI

struct BooksView: View {
    private let authorId: Int
    @State private var books = [Book]()
    
    init(authorId: Int) {
        self.authorId = authorId
    }
    
    var body: some View {
        NavigationStack {            
            List(books, id: \.name) { book in
                Text(book.name)
            }
        }
        .navigationTitle("Books")
        .task {
            do {
                try await SpanUtils.startSpan("load-data-for-books-view") { span in
                    let booksFetcher = BooksFetcher()
                    self.books = try await booksFetcher.getBooks(authorId: authorId)
                }
            } catch let e {
                print(String(describing: e))
            }
        }
    }
}
