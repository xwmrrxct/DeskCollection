//
//  TaigaInteractiveTransitioning.h
//  DeskCollection
//
//  Created by Taiga on 2019/11/27.
//  Copyright © 2019 Taiga. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, TaigaInteractiveTransitioningType) {
    TaigaInteractiveTransitioningTypePresent   = 0,
    TaigaInteractiveTransitioningTypeDismiss,
    TaigaInteractiveTransitioningTypePush,
    TaigaInteractiveTransitioningTypePop,
};

NS_ASSUME_NONNULL_BEGIN

@interface TaigaInteractiveTransitioning : UIPercentDrivenInteractiveTransition <UIViewControllerInteractiveTransitioning>

@property (nonatomic, assign) TaigaInteractiveTransitioningType type;

@property (nonatomic, strong) UIViewController * viewController;

/**
 区分是手势交互转场还是直接pop/push、present/dissmiss转场
 */
@property (nonatomic, assign) BOOL isInteractive;

//给控制器的View添加相应的手势
- (void)addPanGestureForViewController:(UIViewController *)viewController;


@end

NS_ASSUME_NONNULL_END
