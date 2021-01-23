Core Data Learn

官方指南：
https://developer.apple.com/library/archive/documentation/Cocoa/Conceptual/CoreData/CreatingObjects.html#//apple_ref/doc/uid/TP40001075-CH5-SW1


1. UIColor attribute can assign Transformer,it will auto convert UIColor to NSData to save, and read NSData to UIColor.

2. Image data assign Binary Data, and "Allows External Storage"

	```swift
	// save
		func imagePickerController(_ picker: UIEUImageRowPickerController, didFinishPickingMediaWithInfo info: [UIEUImageRowPickerController.InfoKey : Any]) {
	// Local variable inserted by Swift 4.2 migrator.
		let info = convertFromUIEUImageRowPickerControllerInfoKeyDictionary(info)
	let image = info[convertFromUIEUImageRowPickerControllerInfoKey(UIEUImageRowPickerController.InfoKey.originalImage)] as! UIImage
	let friend = isFiltered ? filtered[selected.row] : friends[selected.row]
	friend.photo = image.pngData() as NSData?
	appDelegate.saveContext()
	collectionView?.reloadItems(at: [selected])
	picker.dismiss(animated: true, completion: nil)
		}
	    
	// read
	if let data = friend.photo as Data? {
	   cell.pictureImageView.image = UIImage(data: data)
	} 
	    
	```

3. predicates

4. filtering by NSSortDescriptor

5. NSFetchedResultsController

	1. notified of changes
	2. cache the data
	3. order data by section

6. delete rules

	1. no action: no effect on related items
	2. nullify: removes the reference when deleted
	3. cascade: deletes related items
	4. deny: does not delete if has related items

7. 





CloudKit Learn

https://www.raywenderlich.com/4247-beginning-cloudkit

https://www.andrewcbancroft.com/blog/ios-development/data-persistence/getting-started-with-nspersistentcloudkitcontainer/
