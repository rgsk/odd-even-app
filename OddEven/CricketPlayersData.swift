import Foundation

struct CricketPlayer: Codable, Identifiable {
    var id: String
    var dataId: Int
    var name: String
}

class PlayerViewModel: ObservableObject {
    var players: [CricketPlayer] = []
    var filteredPlayers: [CricketPlayer] = []
    @Published var displayedPlayers: [CricketPlayer] = []
    
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
                players = try JSONDecoder().decode([CricketPlayer].self, from: jsonData!)
                players = removeDuplicatePlayers(players)
                filteredPlayers = players
                loadMorePlayers()
            } catch {
                print("Error decoding JSON: \(error)")
            }
        } else {
            print("Unable to find players.json")
        }
    }
    
    func removeDuplicatePlayers(_ players: [CricketPlayer]) -> [CricketPlayer] {
         var uniquePlayers: [CricketPlayer] = []
         var encounteredNames: Set<String> = []
         
         for player in players {
             if !encounteredNames.contains(player.name.lowercased()) {
                 encounteredNames.insert(player.name.lowercased())
                 uniquePlayers.append(player)
             }
         }
         
         return uniquePlayers
     }
    
    func filterPlayers(with prefix: String) {
        displayedPlayers = []
        currentPage = 1
        filteredPlayers = players.filter { $0.name.lowercased().hasPrefix(prefix.lowercased()) }
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
