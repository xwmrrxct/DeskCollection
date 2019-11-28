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

@property (nonatomic, strong) UIPanGestureRecognizer *pan;

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

- (void)setWindow:(UIWindow *)window {
    _window = window;
    
    // bounds - safeAreaInsets的top和bottom
    CGFloat top = 20.0;
    CGFloat bottom = 0;
    if (@available(iOS 11.0, *)) {
        top = window.safeAreaInsets.top;
        bottom = window.safeAreaInsets.bottom;
    }
    
    CGRect rect = window.bounds;
    rect.origin.y += top;
    rect.size.height -= (top + bottom);
    self.activityRect = rect;
}

- (void)initEntrance {
    self.suspendedView = [[TaigaSuspendedView alloc] initWithFrame:CGRectMake(0, 200, 50, 50)];
    [self addPanGesture];
    
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

- (void)addPanGesture {
    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(gestureHandle:)];
    self.pan = pan;
    [self.suspendedView addGestureRecognizer:pan];
}

- (void)gestureHandle:(UIGestureRecognizer *)sender {
    if (sender == self.pan) {
        UIPanGestureRecognizer *pan = (UIPanGestureRecognizer *)sender;
        UIView *targetView = pan.view;
        switch (pan.state) {
            case UIGestureRecognizerStateBegan:
            {
                
            }
                break;
            case UIGestureRecognizerStateChanged:
            {
                CGPoint transition = [pan translationInView:targetView];
                [pan setTranslation:CGPointZero inView:self];
                CGRect frame = targetView.frame;
                
                CGFloat x = CGRectGetMinX(frame) + transition.x;
                CGFloat y = CGRectGetMinY(frame) + transition.y;
                
                CGRect enableRect = self.window.bounds;
                CGFloat minX = CGRectGetMinX(enableRect);
                CGFloat minY = CGRectGetMinY(enableRect);
                CGFloat maxX = CGRectGetMaxX(enableRect) - CGRectGetWidth(frame);
                CGFloat maxY = CGRectGetMaxY(enableRect) - CGRectGetHeight(frame);
                
                if (x < minX) x = minX;
                if (x > maxX) x = maxX;
                if (y < minY) y = minY;
                if (y > maxY) y = maxY;
                
                frame.origin.x = x;
                frame.origin.y = y;
                
                targetView.frame = frame;
            }
                break;
            case UIGestureRecognizerStateFailed:
            case UIGestureRecognizerStateCancelled:
            case UIGestureRecognizerStateEnded:
            {
                [self adjustSuspendedViewFrame:YES];
            }
                break;
                
            default:
                break;
        }
    }
}

- (void)adjustSuspendedViewFrame:(BOOL)animated {

    CGRect frame = self.suspendedView.frame;
    CGFloat x = CGRectGetMinX(frame);
    CGFloat y = CGRectGetMinY(frame);
    CGFloat cX = self.suspendedView.center.x;
    
    CGRect enableRect = self.activityRect;
    CGFloat minX = CGRectGetMinX(enableRect);
    CGFloat minY = CGRectGetMinY(enableRect);
    CGFloat maxX = CGRectGetMaxX(enableRect) - CGRectGetWidth(frame);
    CGFloat maxY = CGRectGetMaxY(enableRect) - CGRectGetHeight(frame);
    CGFloat centerX = CGRectGetWidth(enableRect) / 2.0;
    
    // 靠左
    if (cX < centerX) {
        x = minX;
    }
    // 靠右
    else {
        x = maxX;
    }
    if (y < minY) y = minY;
    if (y > maxY) y = maxY;

    frame.origin.x = x;
    frame.origin.y = y;
    
    if (animated) {
        self.userInteractionEnabled = NO;
        [UIView animateWithDuration:0.55 delay:0 usingSpringWithDamping:0.78 initialSpringVelocity:0.1 options:kNilOptions animations:^{
            self.suspendedView.frame = frame;
        } completion:^(BOOL finished) {
            self.userInteractionEnabled = YES;
        }];
    } else {
        self.suspendedView.frame = frame;
        self.userInteractionEnabled = YES;
    }
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
    
    if (operation == UINavigationControllerOperationPush) {
        self.animatedTransitioning.type = TaigaAnimatedTransitioningTypePush;
    }
    else if (operation == UINavigationControllerOperationPop) {
        self.animatedTransitioning.type = TaigaAnimatedTransitioningTypePop;
    }
    
    return self.animatedTransitioning;
}

- (id<UIViewControllerInteractiveTransitioning>)navigationController:(UINavigationController *)navigationController interactionControllerForAnimationController:(id<UIViewControllerAnimatedTransitioning>)animationController {
    //手势开始的时候才需要传入手势过渡代理，如果直接pop或push，应该返回nil，否者无法正常完成pop/push动作
    if (self.animatedTransitioning.type == UINavigationControllerOperationPop) {
        return self.interactiveTransitioning.isInteractive ? self.interactiveTransitioning : nil;
    }
    return nil;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
