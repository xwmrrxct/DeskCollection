//
//  DeskCollectionCell.h
//  DeskCollection
//
//  Created by Taiga on 2019/11/28.
//  Copyright © 2019 Taiga. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FileEntity.h"

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, DeskCollectionCellType) {
    DeskCollectionCellTypeFile  = 0,        // 文件
    DeskCollectionCellTypeFold,         // 文件夹
};

typedef NS_ENUM(NSInteger, DeskCollectionCellState) {
    DeskCollectionCellStateNormal   = 0,
    DeskCollectionCellStateDragging,
};

@interface DeskCollectionCell : UICollectionViewCell

@property (nonatomic, assign) DeskCollectionCellType type;
@property (nonatomic, assign) DeskCollectionCellState state;


 
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

+ (DeskCollectionCell *)loadCellFromNib;

@property (nonatomic, strong) FileEntity *entity;
- (void)updateCellWithParams:(FileEntity *)entity;

@end

NS_ASSUME_NONNULL_END
