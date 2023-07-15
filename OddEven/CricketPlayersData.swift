import Foundation

struct CricketPlayer: Codable, Identifiable {
    var id: String
    var dataId: Int
    var name: String
}

class PlayerViewModel: ObservableObject {
    var playersData: [CricketPlayer] = []
    var players: [String] = []
    var filteredPlayers: [String] = []
    @Published var displayedPlayers: [String] = []
    
    var currentPage = 1
    var playersPerPage = 100
    
    init() {
        loadData()
    }
    
    func loadData() {
        if let path = Bundle.main.path(forResource: "players", ofType: "json") {
            do {
                let jsonString = try String(contentsOfFile: path)
                let jsonData = jsonString.data(using: .utf8)
                playersData = try JSONDecoder().decode([CricketPlayer].self, from: jsonData!)
                players = Array(Set(playersData.map {$0.name}))
                filteredPlayers = players
                loadMorePlayers()
            } catch {
                print("Error decoding JSON: \(error)")
            }
        } else {
            print("Unable to find players.json")
        }
    }
    
    func filterPlayers(with query: String) {
        displayedPlayers = []
        currentPage = 1
        
        let lowercaseQuery = query.lowercased()
        let prefixMatches = players.filter { $0.lowercased().hasPrefix(lowercaseQuery) }
        let otherMatches = players.filter { $0.lowercased().contains(lowercaseQuery) && !$0.lowercased().hasPrefix(lowercaseQuery) }
        
        filteredPlayers = prefixMatches + otherMatches
        loadMorePlayers()
    }

    
    func loadMorePlayers() {
        let startIndex = (currentPage - 1) * playersPerPage
         let endIndex = min(startIndex + playersPerPage, filteredPlayers.count)
         
         guard startIndex < endIndex else {
             return
         }
         
         let newPlayers = Array(filteredPlayers[startIndex..<endIndex])
         
         currentPage += 1
         displayedPlayers.append(contentsOf: newPlayers)
    }
}
