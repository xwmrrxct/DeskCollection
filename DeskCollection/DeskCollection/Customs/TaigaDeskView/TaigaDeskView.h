//
//  TaigaDeskView.h
//  DeskCollection
//
//  Created by Taiga on 2019/11/28.
//  Copyright © 2019 Taiga. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FileEntity.h"


typedef NS_ENUM(int, TaigaDeskViewOperation) {
    TaigaDeskViewOperationItemPressed   = 0,
    TaigaDeskViewOperationMoveItem,
    TaigaDeskViewOperationIntoFolder,
    TaigaDeskViewOperationDragOutside,
};

@class TaigaDeskView;
@protocol TaigaDeskViewDelegate <NSObject>

@optional
- (void)taigaDeskView:(TaigaDeskView *)deskView
            operation:(TaigaDeskViewOperation)operation
           indexPaths:(NSArray<NSIndexPath *> *)indexPaths
             entities:(NSArray<FileEntity *> *)entities;

@end


NS_ASSUME_NONNULL_BEGIN

@interface TaigaDeskView : UIView

@property (nonatomic, strong, readonly) UICollectionView *collectionView;

//@property (nonatomic, assign) BOOL isEditing;
@property (nonatomic, assign) BOOL isDragging;

@property (nonatomic, assign) BOOL enableIntoFloder;    // 默认YES
@property (nonatomic, assign) BOOL enableDragOutside;   // 默认NO

@property (nonatomic, strong) NSMutableArray<FileEntity *> *dataSource;

- (void)reloadData;
@property (nonatomic, copy, nullable) void (^deskViewBlcok)(TaigaDeskView *block_deskView, TaigaDeskViewOperation operation, NSArray<NSIndexPath *> *indexPaths, NSArray<FileEntity *> *entities);
@property (nonatomic, weak) id<TaigaDeskViewDelegate> delegate;

@end

NS_ASSUME_NONNULL_END
