import Foundation
import Tracing

struct Network {
    func getAuthors() async throws -> [Author] {
        let url = URL(string: "http://localhost:8080/authors")!
        
        let (data, _) = try await URLSession.dataWithTracing(from: url)
        
        return try JSONDecoder().decode(Array<Author>.self, from: data)
    }
    
    func getBooks(authorId: Int) async throws -> [Book] {
        let url = URL(string: "http://localhost:8080/books?authorId=\(authorId)")!
        
        let (data, _) = try await URLSession.dataWithTracing(from: url)
                
        return try JSONDecoder().decode(Array<Book>.self, from: data)
    }
}
