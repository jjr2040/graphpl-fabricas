import UIKit

enum SearchStrategy {
    case dfs, bfs, none
}

protocol GraphType {
    
    var nodes: [Node] { get }
    var arcs: [Arc] { get }
    var isDirected: Bool { get }
    
    func searchAlgorithm()
    func add(arc: Arc)
    func addSearchWith(strategy: SearchStrategy)
}

protocol Search {
    init(graph: GraphType)
    func search()
}

protocol Weightable {
    var weight: Float { get set }
}

class Node {
    let name: String
    
    init(name: String) {
        self.name = name
    }
}

class Arc: Weightable {
    let source: Node
    let target: Node
    var weight: Float
    var isDirected: Bool = false
    
    init(source: Node, target: Node, weight: Float = 0) {
        self.source = source
        self.target = target
        self.weight = weight
    }
}

struct GraphConfig {
    let isDirected: Bool
    let numNodes: Int
    let searchStrategy: SearchStrategy
}

struct GraphBuilder {
    
    static var config: GraphConfig?
    
    static func createGraph(config: GraphConfig) -> GraphType {
        self.config = config
        let graph = Graph(numNodes: config.numNodes, isDirected: config.isDirected)
        graph.addSearchWith(strategy: config.searchStrategy)
        
        return graph
    }
}

struct SearchBuilder {
    
    static func createSearch(forGraph graph: GraphType, strategy: SearchStrategy) -> Search? {
        switch strategy {
        case .bfs:
            return SearchBFS(graph: graph)
        case .dfs:
            return SearchDFS(graph: graph)
        case .none:
            return nil
        }
    }
}

struct SearchDFS: Search {
    
    private let graph: GraphType
    
    init(graph: GraphType) {
        self.graph = graph
    }
    
    func search() {
        print("Made search with DFS. Is graph directed: \(graph.isDirected)")
    }
}

struct SearchBFS: Search {
    
    private let graph: GraphType
    
    init(graph: GraphType) {
        self.graph = graph
    }
    
    func search() {
        print("Made search with BFS. Is graph directed: \(graph.isDirected)")
    }
}

class Graph: GraphType {
    
    var nodes: [Node] = []
    var arcs: [Arc] = []
    
    private var search: Search?
    var isDirected: Bool
    
    init(numNodes: Int, isDirected: Bool) {
        self.isDirected = isDirected
        buildNodes(numNodes: numNodes)
    }
    
    func searchAlgorithm() {
        search?.search()
    }
    
    func add(arc: Arc) {
        arc.isDirected = isDirected
        arcs.append(arc)
    }
    
    func addSearchWith(strategy: SearchStrategy) {
        search = SearchBuilder.createSearch(forGraph: self, strategy: strategy)
    }
    
    private func buildNodes(numNodes: Int) {
        for i in 0..<numNodes {
            nodes.append(Node(name: "node_\(i)"))
        }
    }
}

// Esta configuración puede ser cargada de un archivo de propiedades o de un servicio.
let config = GraphConfig(isDirected: false, numNodes: 15, searchStrategy: .bfs)
let graph = GraphBuilder.createGraph(config: config)

graph.searchAlgorithm()
