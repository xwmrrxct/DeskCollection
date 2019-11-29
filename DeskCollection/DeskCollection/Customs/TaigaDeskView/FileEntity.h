//
//  FileEntity.h
//  DeskCollection
//
//  Created by Taiga on 2019/11/29.
//  Copyright © 2019 Taiga. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, FileType) {
    FileTypeNormal  = 0,
    FileTypeFolder,
    FileTypeAdd,
};

typedef NS_ENUM(NSInteger, FileState) {
    FileStateNormal = 0,
    FileStateTarget,
    FileStateDragging,
};

NS_ASSUME_NONNULL_BEGIN

@interface FileEntity : NSObject

@property (nonatomic, assign) FileType type;
@property (nonatomic, assign) FileState state;
- (BOOL)canMove;

@property (nonatomic, strong) NSString *img;
@property (nonatomic, strong) NSString *title;

// FileTypeFolder 文件夹下的文件列表
@property (nonatomic, strong) NSMutableArray<FileEntity *> *files;

+ (FileEntity *)fileEntity;
+ (FileEntity *)folderEntity;

@end

NS_ASSUME_NONNULL_END
