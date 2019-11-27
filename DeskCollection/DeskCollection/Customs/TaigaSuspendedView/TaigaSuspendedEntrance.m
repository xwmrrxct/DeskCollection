//
//  TaigaSuspendedEntrance.m
//  DeskCollection
//
//  Created by Taiga on 2019/11/26.
//  Copyright © 2019 Taiga. All rights reserved.
//

#import "TaigaSuspendedEntrance.h"

static TaigaSuspendedEntrance *suspended_entrance = nil;

@interface TaigaSuspendedEntrance ()

@property (nonatomic, strong) TaigaAnimatedTransitioning *animatedTransitioning;
@property (nonatomic, strong) TaigaInteractiveTransitioning *interactiveTransitioning;

@end

@implementation TaigaSuspendedEntrance

+ (TaigaSuspendedEntrance *)sharedInstance {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (!suspended_entrance) {
            suspended_entrance = [[TaigaSuspendedEntrance alloc] init];
        }
    });
    return suspended_entrance;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self initEntrance];
    }
    return self;
}

- (TaigaAnimatedTransitioning *)animatedTransitioning {
    if (!_animatedTransitioning) {
        _animatedTransitioning = [[TaigaAnimatedTransitioning alloc] init];
    }
    return _animatedTransitioning;
}

- (TaigaInteractiveTransitioning *)interactiveTransitioning {
    if (!_interactiveTransitioning) {
        _interactiveTransitioning = [[TaigaInteractiveTransitioning alloc] init];
    }
    return _interactiveTransitioning;
}

- (void)initEntrance {
    self.suspendedView = [[TaigaSuspendedView alloc] initWithFrame:CGRectMake(0, 200, 50, 50)];
    
    UIWindow* window = nil;
     
    if (@available(iOS 13.0, *)) {
        for (UIWindowScene* windowScene in [UIApplication sharedApplication].connectedScenes) {
            if (windowScene.activationState == UISceneActivationStateForegroundActive) {
                window = windowScene.windows.firstObject;
                break;
            }
        }
    }
    if (!window) {
        window = [UIApplication sharedApplication].keyWindow;
    }
    self.window = window;
}

- (void)show {
    [self.window addSubview:self.suspendedView];
}



#pragma mark -- UIViewControllerTransitioningDelegate

//返回一个处理present动画过渡的对象
-(id<UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented presentingController:(UIViewController *)presenting sourceController:(UIViewController *)source{
    self.animatedTransitioning.type = TaigaAnimatedTransitioningTypePresent;
    return self.animatedTransitioning;
}
//返回一个处理dismiss动画过渡的对象
- (id<UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed{
    //这里我们初始化dismissType
    self.animatedTransitioning.type = TaigaAnimatedTransitioningTypeDismiss;
    return self.animatedTransitioning;
}

#pragma mark - UINavigationControllerDelegate
- (id<UIViewControllerAnimatedTransitioning>)navigationController:(UINavigationController *)navigationController animationControllerForOperation:(UINavigationControllerOperation)operation fromViewController:(UIViewController *)fromVC toViewController:(UIViewController *)toVC {
    return self.animatedTransitioning;
}

- (id<UIViewControllerInteractiveTransitioning>)navigationController:(UINavigationController *)navigationController interactionControllerForAnimationController:(id<UIViewControllerAnimatedTransitioning>)animationController {
    return self.interactiveTransitioning;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
