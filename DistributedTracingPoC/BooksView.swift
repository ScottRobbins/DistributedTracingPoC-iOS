import SwiftUI

struct BooksView: View {
    private let books: [Book]
    
    init(books: [Book]) {
        self.books = books
    }
    
    var body: some View {
        NavigationStack {            
            List(books, id: \.name) { book in
                Text(book.name)
            }
        }.navigationTitle("Books")
    }
}
