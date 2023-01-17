import SwiftUI

struct AuthorsView: View {
    @State private var authors = [Author: [Book]]()
    
    var body: some View {
        NavigationStack {            
            List(Array(authors.keys)) { author in
                NavigationLink(author.name) {
                    BooksView(books: authors[author]!)
                }
            }
            .navigationTitle("Authors")
            .task {
                do {
                    try await SpanUtils.startSpan("load-data-for-authors-view") { span in
                        let authorsFetcher = AuthorsFetcher()
                        let booksFetcher = BooksFetcher()
                        
                        let authors = try await authorsFetcher.getAuthors()
                        for author in authors {
                            let books = try await booksFetcher.getBooks(authorId: author.id)
                            self.authors[author] = books
                        }
                    }
                } catch let e {
                    print(String(describing: e))
                }
            }
        }
    }
}
