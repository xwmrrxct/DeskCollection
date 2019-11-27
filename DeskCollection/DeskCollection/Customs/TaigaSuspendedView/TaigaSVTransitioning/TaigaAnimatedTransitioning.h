//
//  TaigaAnimatedTransitioning.h
//  DeskCollection
//
//  Created by Taiga on 2019/11/27.
//  Copyright © 2019 Taiga. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, TaigaAnimatedTransitioningType) {
    TaigaAnimatedTransitioningTypePresent   = 0,
    TaigaAnimatedTransitioningTypeDismiss,
    TaigaAnimatedTransitioningTypePush,
    TaigaAnimatedTransitioningTypePop,
};

NS_ASSUME_NONNULL_BEGIN

@interface TaigaAnimatedTransitioning : NSObject <UIViewControllerAnimatedTransitioning>

@property (nonatomic, assign) TaigaAnimatedTransitioningType type;

@end

NS_ASSUME_NONNULL_END
