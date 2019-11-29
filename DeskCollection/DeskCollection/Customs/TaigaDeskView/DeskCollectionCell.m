//
//  DeskCollectionCell.m
//  DeskCollection
//
//  Created by Taiga on 2019/11/28.
//  Copyright © 2019 Taiga. All rights reserved.
//

#import "DeskCollectionCell.h"

@implementation DeskCollectionCell

+ (DeskCollectionCell *)loadCellFromNib {
    return (DeskCollectionCell *)[[[NSBundle mainBundle] loadNibNamed:@"DeskCollectionCell" owner:nil options:nil] lastObject];
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.imageView.backgroundColor = [UIColor colorWithRGBHex:0xF0F3F7];
    self.imageView.contentMode = UIViewContentModeScaleAspectFit;
    
    self.imageView.layer.cornerRadius = 5.0;
    self.imageView.layer.masksToBounds = YES;
}

- (void)updateCellWithParams:(FileEntity *)entity {
    self.entity = entity;
    if (!entity) {
        return;
    }
    
    self.imageView.image = [UIImage imageNamed:entity.img];
    self.titleLabel.text = entity.title;
    
    if (entity.type == FileTypeAdd) {
        self.titleLabel.text = @"";
    }
    else if (entity.type == FileTypeFolder) {
        self.titleLabel.text = [[entity.files valueForKey:@"title"] componentsJoinedByString:@", "];
    }
    
    switch (entity.state) {
        case FileStateNormal:
        {
            self.alpha = 1.0;
            [self setHidden:NO];
        }
            break;
        case FileStateTarget:
        {
            self.alpha = 1.0;
            [self setHidden:YES];
        }
            break;
        case FileStateDragging:
        {
            self.alpha = 0.5;
            [self setHidden:NO];
        }
            break;
        default:
            break;
    }
}

@end
