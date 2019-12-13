//
//  FileEntity.m
//  DeskCollection
//
//  Created by Taiga on 2019/11/29.
//  Copyright © 2019 Taiga. All rights reserved.
//

#import "FileEntity.h"

@implementation FileEntity

- (BOOL)canMove {
    return (self.type == FileTypeNormal || self.type == FileTypeFolder);
}

+ (FileEntity *)fileEntity {
    FileEntity *e = [[FileEntity alloc] init];
    e.type = FileTypeNormal;
    e.state = FileStateNormal;
    e.name = @"taiga";
    e.img = @"ymb_img";
    
    return e;
}

+ (FileEntity *)folderEntity {
    FileEntity *e = [[FileEntity alloc] init];
    e.type = FileTypeFolder;
    e.state = FileStateNormal;
    
    e.img = @"book";
    
    return e;
}

@end
