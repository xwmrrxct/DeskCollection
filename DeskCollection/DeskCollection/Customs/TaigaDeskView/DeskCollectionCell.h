//
//  DeskCollectionCell.h
//  DeskCollection
//
//  Created by Taiga on 2019/11/28.
//  Copyright © 2019 Taiga. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, DeskCollectionCellType) {
    DeskCollectionCellTypeFile  = 0,
    
};

typedef NS_ENUM(NSInteger, DeskCollectionCellState) {
    DeskCollectionCellStateNormal   = 0,
};

@interface DeskCollectionCell : UICollectionViewCell

@property (nonatomic, assign) DeskCollectionCellType type;
@property (nonatomic, assign) DeskCollectionCellState state;
 
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@end

NS_ASSUME_NONNULL_END
