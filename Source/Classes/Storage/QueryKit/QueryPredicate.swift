import Foundation
import CoreData

/// Returns an and predicate from the given predicates
public func && (left: NSPredicate, right: NSPredicate) -> NSPredicate {
  return NSCompoundPredicate(type: NSCompoundPredicate.LogicalType.and, subpredicates: [left, right])
}

/// Returns an or predicate from the given predicates
public func || (left: NSPredicate, right: NSPredicate) -> NSPredicate {
  return NSCompoundPredicate(type: NSCompoundPredicate.LogicalType.or, subpredicates: [left, right])
}

///// Returns a predicate reversing the given predicate
//fileprivate prefix func ! (left: NSPredicate) -> NSPredicate {
//  return NSCompoundPredicate(type: NSCompoundPredicate.LogicalType.not, subpredicates: [left])
//}

// MARK: QueryPredicate Type

/// Represents a predicate for a specific model
public struct QueryPredicate<ModelType : NSManagedObject> {
  let predicate:NSPredicate

  init(predicate:NSPredicate) {
    self.predicate = predicate
  }
}

public func == <T: NSManagedObject, AttributeType>(left: QueryAttribute<AttributeType>, right: AttributeType?) -> QueryPredicate<T> {
  return QueryPredicate(predicate: left == right)
}

public func != <T: NSManagedObject, AttributeType>(left: QueryAttribute<AttributeType>, right: AttributeType?) -> QueryPredicate<T> {
  return QueryPredicate(predicate: left != right)
}

public func > <T: NSManagedObject, AttributeType>(left: QueryAttribute<AttributeType>, right: AttributeType?) -> QueryPredicate<T> {
  return QueryPredicate(predicate: left > right)
}

public func >= <T: NSManagedObject, AttributeType>(left: QueryAttribute<AttributeType>, right: AttributeType?) -> QueryPredicate<T> {
  return QueryPredicate(predicate: left >= right)
}

public func < <T: NSManagedObject, AttributeType>(left: QueryAttribute<AttributeType>, right: AttributeType?) -> QueryPredicate<T> {
  return QueryPredicate(predicate: left < right)
}

public func <= <T: NSManagedObject, AttributeType>(left: QueryAttribute<AttributeType>, right: AttributeType?) -> QueryPredicate<T> {
  return QueryPredicate(predicate: left <= right)
}

public func ~= <T: NSManagedObject, AttributeType>(left: QueryAttribute<AttributeType>, right: AttributeType?) -> QueryPredicate<T> {
  return QueryPredicate(predicate: left ~= right)
}

public func << <T: NSManagedObject, AttributeType>(left: QueryAttribute<AttributeType>, right: [AttributeType]) -> QueryPredicate<T> {
  return QueryPredicate(predicate: left << right)
}

public func << <T: NSManagedObject, AttributeType>(left: QueryAttribute<AttributeType>, right: Range<AttributeType>) -> QueryPredicate<T> {
  return QueryPredicate(predicate: left << right)
}

/// Returns an and predicate from the given predicates
public func && <T>(left: QueryPredicate<T>, right: QueryPredicate<T>) -> QueryPredicate<T> {
  return QueryPredicate(predicate: left.predicate && right.predicate)
}

/// Returns an or predicate from the given predicates
public func || <T>(left: QueryPredicate<T>, right: QueryPredicate<T>) -> QueryPredicate<T> {
  return QueryPredicate(predicate: left.predicate || right.predicate)
}

/// Returns a predicate reversing the given predicate
public prefix func ! <T>(predicate: QueryPredicate<T>) -> QueryPredicate<T> {
  return QueryPredicate(predicate: !predicate.predicate)
}
