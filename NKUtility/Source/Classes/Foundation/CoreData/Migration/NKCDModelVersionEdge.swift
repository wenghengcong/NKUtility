//
//  NKCDModelVersionEdge.swift
//  TMLPersistentContainer
//
//  Distributed under the ISC license, see LICENSE.
//

import Foundation
import CoreData

///
/// This file deals with managing the 'edges' in the version graph.
/// These are discovered from nodes by using the Core Data functions to search for
/// all links between them.
///
/// Important to know whether a link is inferred or not because non-inferred paths
/// (those with mapping models the user has written) must take priority.
///
/// We are quite happy at this point to discover cycles in the graph.
///
/// TODO: Needs rework to cope with multiple explicit mapping models per edge.  This is
/// a valid technique for chunking migration work up into separate memory footprints.
/// requires slightly more sophisticated discovery, definitely more involved mapping to
/// nodes (compare version hashes), data structure work, and then execution of the
/// migrations involving ordering thoughts and status reporting back in migrateStore.
///
/// TODO: Consider user-supplied edges, completely mandraulic migrations - another valid
/// technique to avoid memory footprint issues.
///
@available(macOS 10.12, iOS 10.0, tvOS 10.0, watchOS 3.0, *)
struct NKCDModelVersionEdge: NKCDMigrationGraphEdge, CustomStringConvertible {
    let sourceNode: NKCDModelVersionNode
    let destinationNode: NKCDModelVersionNode
    let mappingModel: NSMappingModel
    let isInferred: Bool

    var source: String {
        return sourceNode.name
    }

    var destination: String {
        return destinationNode.name
    }

    func createMigrationManager() -> NSMigrationManager {
        return NSMigrationManager(sourceModel: sourceNode.model, destinationModel: destinationNode.model)
    }

    public var description: String {
        let letter = isInferred ? "i" : "e"
        return "\(source)-(\(letter))->\(destination)"
    }

    static func ==(lhs: NKCDModelVersionEdge, rhs: NKCDModelVersionEdge) -> Bool {
        return lhs.source == rhs.source &&
               lhs.destination == rhs.destination &&
               lhs.isInferred == rhs.isInferred
    }
}

@available(macOS 10.12, iOS 10.0, tvOS 10.0, watchOS 3.0, *)
final class NKCDModelVersionEdges: LogMessageEmitter {

    private var edgesDict: [String:[String:NKCDModelVersionEdge]]

    var edges: [NKCDModelVersionEdge] {
        return Array(edgesDict.values.map { $0.values }.joined())
    }

    let logMessageHandler: LogMessage.Handler?

    init(edgesDict: [String:[String:NKCDModelVersionEdge]] = [:], logMessageHandler: LogMessage.Handler?) {
        self.edgesDict = edgesDict
        self.logMessageHandler = logMessageHandler
    }

    /// Try to create an Edge object using an explicit mapping model if possible, otherwise an inferred one.
    func discoverEdge(source: NKCDModelVersionNode, destination: NKCDModelVersionNode, from bundles: [Bundle]) -> NKCDModelVersionEdge? {

        if let mappingModel = NSMappingModel(from: bundles, forSourceModel: source.model, destinationModel: destination.model) {
            log(.info, "Found explicit mapping model from \(source.name) to \(destination.name)")
            return NKCDModelVersionEdge(sourceNode: source, destinationNode: destination, mappingModel: mappingModel, isInferred: false)
        }

        if let mappingModel = try? NSMappingModel.inferredMappingModel(forSourceModel: source.model, destinationModel: destination.model) {
            log(.info, "Found inferred mapping model from \(source.name) to \(destination.name)")
            return NKCDModelVersionEdge(sourceNode: source, destinationNode: destination, mappingModel: mappingModel, isInferred: true)
        }

        log(.info, "Could not find explicit or inferred mapping model from \(source.name) to \(destination.name)")

        return nil
    }

    /// Discover all edges between provided nodes subject to given order
    func discover(from bundles: [Bundle], between nodes: [NKCDModelVersionNode]) {
        nodes.forEach { sourceNode in
            var edgesForNode: [String:NKCDModelVersionEdge] = [:]
            nodes.forEach { destinationNode in
                if sourceNode != destinationNode,
                   let edge = discoverEdge(source: sourceNode, destination: destinationNode, from: bundles) {
                    edgesForNode[destinationNode.name] = edge
                }
            }
            self.edgesDict[sourceNode.name] = edgesForNode
        }
    }

    /// Create a new set of edges by filtering ours
    func filtered(order: NKCDModelVersionOrder, allowInferredMappings: Bool) -> NKCDModelVersionEdges {
        // first filter out all edges FROM nodes that are not in the order
        let filteredEdgesDict = edgesDict.filter { sourceVersion, _ in
            order.valid(version: sourceVersion)
        }.map { sourceVersion, dict in
            // now for each remaining node, filter out all its edges that are either
            // (1) TO a node not in the order or
            // (2) not in-order according to the order or
            // (3) an inferred mapping that is excluded by the user's setting
            (sourceVersion, dict.filtered { _, edge in
                order.valid(version: edge.destination) &&
                order.precedes(sourceVersion, edge.destination) &&
                (!edge.isInferred || allowInferredMappings)
            })
        }

        return NKCDModelVersionEdges(edgesDict: Dictionary(filteredEdgesDict),
                                 logMessageHandler: logMessageHandler)
    }
}
