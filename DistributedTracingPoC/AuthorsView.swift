import SwiftUI

struct AuthorsView: View {
    @State private var authors = [Author]()
    
    var body: some View {
        NavigationStack {            
            List(authors) { author in
                NavigationLink(author.name) {
                    BooksView(authorId: author.id)
                }
            }
            .navigationTitle("Authors")
            .task {
                do {
                    try await SpanUtils.startSpan("load-data-for-authors-view") { span in
                        let authorsFetcher = AuthorsFetcher()
                        
                        self.authors = try await authorsFetcher.getAuthors()
                    }
                } catch let e {
                    print(String(describing: e))
                }
            }
        }
    }
}
