//
//  TaigaSuspendedEntrance.h
//  DeskCollection
//
//  Created by Taiga on 2019/11/26.
//  Copyright © 2019 Taiga. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TaigaSuspendedView.h"
#import "TaigaAnimatedTransitioning.h"
#import "TaigaInteractiveTransitioning.h"

NS_ASSUME_NONNULL_BEGIN

@interface TaigaSuspendedEntrance : UIView <UIViewControllerTransitioningDelegate, UINavigationControllerDelegate>

@property(class, nonatomic, readonly) TaigaSuspendedEntrance *sharedInstance;

@property (nonatomic, strong) TaigaSuspendedView *suspendedView;

@property (nonatomic, strong) UIWindow *window;

- (void)show;

@end

#define taigaSuspendedEntrance [TaigaSuspendedEntrance sharedInstance]

NS_ASSUME_NONNULL_END
