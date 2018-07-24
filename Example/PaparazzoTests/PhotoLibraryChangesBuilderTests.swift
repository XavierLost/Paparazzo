import ImageSource
@testable import Paparazzo
import Photos
import XCTest

final class PhotoLibraryChangesBuilderTests: XCTestCase {
    
    // TODO: PhotoLibraryChangesBuilder
    // Static to prevent crashing on PhotoLibraryItemsServiceImpl.imageManager deallocation
    // due to disabled access to photos in unit tests
    // THIS IS A TEMPORARY WORKAROUND!
    private static let builder = PhotoLibraryItemsServiceImpl(photosOrder: .normal)
    private static let reversedBuilder = PhotoLibraryItemsServiceImpl(photosOrder: .reversed)
    
    func test_insertionToTheBeginning_withNormalOrder() {
        
        let preservedAsset1 = PHAssetMock()
        let preservedAsset2 = PHAssetMock()
        let insertedAsset1 = PHAssetMock()
        let insertedAsset2 = PHAssetMock()
        
        let changes = PHAssetFetchResultChangeDetailsMock(isStrict: false)
        changes.setFetchResultBeforeChanges(PHAssetFetchResultMock(assets: [
            preservedAsset1,
            preservedAsset2
        ]))
        changes.setFetchResultAfterChanges(PHAssetFetchResultMock(assets: [
            insertedAsset1,
            insertedAsset2,
            preservedAsset1,
            preservedAsset2
        ]))
        changes.setInsertedIndexes([0, 1])
        changes.setInsertedObjects([insertedAsset1, insertedAsset2])
        
        let result = type(of: self).builder.photoLibraryChanges(from: changes)
        let insertedItems = result.insertedItems.sorted { $0.index < $1.index }
        
        XCTAssertEqual(2, result.insertedItems.count)
        
        XCTAssertEqual(0, insertedItems[0].index)
        XCTAssertEqual(
            insertedAsset1.localIdentifier,
            (insertedItems[0].item.image as! PHAssetImageSource).asset.localIdentifier,
            "Expected insertedAsset1 on index 0"
        )
        
        XCTAssertEqual(1, insertedItems[1].index)
        XCTAssertEqual(
            insertedAsset2.localIdentifier,
            (insertedItems[1].item.image as! PHAssetImageSource).asset.localIdentifier,
            "Expected insertedAsset2 on index 1"
        )
    }
    
    func test_insertionToTheEnd_withNormalOrder() {
        
        let preservedAsset1 = PHAssetMock()
        let preservedAsset2 = PHAssetMock()
        let insertedAsset1 = PHAssetMock()
        let insertedAsset2 = PHAssetMock()
        
        let changes = PHAssetFetchResultChangeDetailsMock(isStrict: false)
        changes.setFetchResultBeforeChanges(PHAssetFetchResultMock(assets: [
            preservedAsset1,
            preservedAsset2
        ]))
        changes.setFetchResultAfterChanges(PHAssetFetchResultMock(assets: [
            preservedAsset1,
            preservedAsset2,
            insertedAsset1,
            insertedAsset2
        ]))
        changes.setInsertedIndexes([2, 3])
        changes.setInsertedObjects([insertedAsset1, insertedAsset2])
        
        let result = type(of: self).builder.photoLibraryChanges(from: changes)
        let insertedItems = result.insertedItems.sorted { $0.index < $1.index }
        
        XCTAssertEqual(2, result.insertedItems.count)
        
        XCTAssertEqual(2, insertedItems[0].index)
        XCTAssertEqual(
            insertedAsset1.localIdentifier,
            (insertedItems[0].item.image as! PHAssetImageSource).asset.localIdentifier,
            "Expected insertedAsset1 on index 2"
        )
        
        XCTAssertEqual(3, insertedItems[1].index)
        XCTAssertEqual(
            insertedAsset2.localIdentifier,
            (insertedItems[1].item.image as! PHAssetImageSource).asset.localIdentifier,
            "Expected insertedAsset2 on index 3"
        )
    }
    
    func test_insertionToTheBeginning_withReversedOrder() {
        
        let preservedAsset1 = PHAssetMock()
        let preservedAsset2 = PHAssetMock()
        let insertedAsset1 = PHAssetMock()
        let insertedAsset2 = PHAssetMock()
        
        let changes = PHAssetFetchResultChangeDetailsMock(isStrict: false)
        changes.setFetchResultBeforeChanges(PHAssetFetchResultMock(assets: [
            preservedAsset1,
            preservedAsset2
        ]))
        changes.setFetchResultAfterChanges(PHAssetFetchResultMock(assets: [
            insertedAsset1,
            insertedAsset2,
            preservedAsset1,
            preservedAsset2
        ]))
        changes.setInsertedIndexes([0, 1])
        changes.setInsertedObjects([insertedAsset1, insertedAsset2])
        
        let result = type(of: self).reversedBuilder.photoLibraryChanges(from: changes)
        let insertedItems = result.insertedItems.sorted { $0.index < $1.index }
        
        XCTAssertEqual(2, result.insertedItems.count)
        
        XCTAssertEqual(2, insertedItems[0].index)
        XCTAssertEqual(
            insertedAsset2.localIdentifier,
            (insertedItems[0].item.image as! PHAssetImageSource).asset.localIdentifier,
            "Expected insertedAsset2 on index 2"
        )
        
        XCTAssertEqual(3, insertedItems[1].index)
        XCTAssertEqual(
            insertedAsset1.localIdentifier,
            (insertedItems[1].item.image as! PHAssetImageSource).asset.localIdentifier,
            "Expected insertedAsset1 on index 3"
        )
    }
    
    func test_insertionToTheEnd_withReversedOrder() {
        
        let preservedAsset1 = PHAssetMock()
        let preservedAsset2 = PHAssetMock()
        let insertedAsset1 = PHAssetMock()
        let insertedAsset2 = PHAssetMock()
        
        let changes = PHAssetFetchResultChangeDetailsMock(isStrict: false)
        changes.setFetchResultBeforeChanges(PHAssetFetchResultMock(assets: [
            preservedAsset1,
            preservedAsset2
        ]))
        changes.setFetchResultAfterChanges(PHAssetFetchResultMock(assets: [
            preservedAsset1,
            preservedAsset2,
            insertedAsset1,
            insertedAsset2
        ]))
        changes.setInsertedIndexes([2, 3])
        changes.setInsertedObjects([insertedAsset1, insertedAsset2])
        
        let result = type(of: self).reversedBuilder.photoLibraryChanges(from: changes)
        let insertedItems = result.insertedItems.sorted { $0.index < $1.index }
        
        XCTAssertEqual(2, result.insertedItems.count)
        
        XCTAssertEqual(0, insertedItems[0].index)
        XCTAssertEqual(
            insertedAsset2.localIdentifier,
            (insertedItems[0].item.image as! PHAssetImageSource).asset.localIdentifier,
            "Expected insertedAsset2 on index 0"
        )
        
        XCTAssertEqual(1, insertedItems[1].index)
        XCTAssertEqual(
            insertedAsset1.localIdentifier,
            (insertedItems[1].item.image as! PHAssetImageSource).asset.localIdentifier,
            "Expected insertedAsset1 on index 1"
        )
    }
}
