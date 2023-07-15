import Foundation

struct Todo: Codable, Identifiable {
    var id: Int
    var title: String
}

class TodoApi: ObservableObject {
    @Published var todos = [Todo]()
    
    func loadData(completion: @escaping ([Todo]) -> ()) {
        guard let url = URL(string: "http://192.168.29.114:8001/sample/todos") else {
            print("Invalid URL")
            return
        }
        
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            if let error = error {
                print("Error: \(error.localizedDescription)")
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse else {
                print("Invalid HTTP response")
                return
            }
            
            guard (200...299).contains(httpResponse.statusCode) else {
                print("Invalid status code: \(httpResponse.statusCode)")
                return
            }
            
            guard let data = data else {
                print("No data received")
                return
            }
            
            do {
                let todos = try JSONDecoder().decode([Todo].self, from: data)
                DispatchQueue.main.async {
                    completion(todos)
                }
            } catch {
                print("Error decoding JSON: \(error)")
            }
        }.resume()
    }
}
