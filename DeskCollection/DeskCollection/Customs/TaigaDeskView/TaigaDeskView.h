//
//  TaigaDeskView.h
//  DeskCollection
//
//  Created by Taiga on 2019/11/28.
//  Copyright © 2019 Taiga. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FileEntity.h"

NS_ASSUME_NONNULL_BEGIN

@interface TaigaDeskView : UIView

@property (nonatomic, assign) BOOL isEditing;
@property (nonatomic, assign) BOOL isDragging;

@property (nonatomic, strong) NSMutableArray<FileEntity *> *dataSource;

- (void)reloadData;

@end

NS_ASSUME_NONNULL_END
