//
//  TaigaAnimatedTransitioning.m
//  DeskCollection
//
//  Created by Taiga on 2019/11/27.
//  Copyright © 2019 Taiga. All rights reserved.
//

#import "TaigaAnimatedTransitioning.h"
#import "TaigaSuspendedEntrance.h"


@interface TaigaAnimatedTransitioning () <CAAnimationDelegate>

@property(nonatomic, strong) id<UIViewControllerContextTransitioning> context;

@end

@implementation TaigaAnimatedTransitioning

- (NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext {
    if (self.type == TaigaAnimatedTransitioningTypePresent || self.type == TaigaAnimatedTransitioningTypeDismiss) {
        return .5f;
    }
    return 0.25;
}

- (void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext {
    
    
    switch (_type) {
        case TaigaAnimatedTransitioningTypePresent:
            [self presentAnimation:transitionContext];
            break;
        case TaigaAnimatedTransitioningTypeDismiss:
            [self dismissAnimation:transitionContext];
            break;
        case TaigaAnimatedTransitioningTypePush:
            [self pushAnimation:transitionContext];
            break;
        case TaigaAnimatedTransitioningTypePop:
            [self popAnimation:transitionContext];
            break;
    }

}

#pragma mark -
- (void)presentAnimation:(id<UIViewControllerContextTransitioning>)transitionContext{
    
//    [transitionContext completeTransition:![transitionContext transitionWasCancelled]];
    [self modelAnimation:transitionContext type:TaigaAnimatedTransitioningTypePresent];
}

- (void)dismissAnimation:(id<UIViewControllerContextTransitioning>)transitionContext{
    
//    [transitionContext completeTransition:![transitionContext transitionWasCancelled]];
    [self modelAnimation:transitionContext type:TaigaAnimatedTransitioningTypeDismiss];
}


- (void)pushAnimation:(id<UIViewControllerContextTransitioning>)transitionContext{
    UIViewController * fromVC = (UIViewController *)[transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
     UIViewController * toVC = (UIViewController *)[transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    
    //取出转场前后视图控制器上的视图view
    UIView * toView = [transitionContext viewForKey:UITransitionContextToViewKey];
    UIView * fromView = [transitionContext viewForKey:UITransitionContextFromViewKey];
    
    UIView *containerView = [transitionContext containerView];
    
    //左侧动画视图
    UIView *leftFromView = [fromView snapshotViewAfterScreenUpdates:NO];
    UIView * leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, fromView.frame.size.width/2, fromView.frame.size.height)];
    leftView.clipsToBounds = YES;
    [leftView addSubview:leftFromView];
    //右侧动画视图
    UIView *rightFromView = [fromView snapshotViewAfterScreenUpdates:NO];
    rightFromView.frame = CGRectMake(- fromView.frame.size.width/2, 0, fromView.frame.size.width, fromView.frame.size.height);
    UIView * rightView = [[UIView alloc] initWithFrame:CGRectMake(fromView.frame.size.width/2, 0, fromView.frame.size.width/2, fromView.frame.size.height)];
    rightView.clipsToBounds = YES;
    [rightView addSubview:rightFromView];
    
    [containerView addSubview:toView];
    [containerView addSubview:leftView];
    [containerView addSubview:rightView];
    
    fromView.hidden = YES;
    
    [UIView animateWithDuration:[self transitionDuration:transitionContext]
                          delay:0
                        options:UIViewAnimationOptionTransitionFlipFromRight
                     animations:^{
                         leftView.frame = CGRectMake(-fromView.frame.size.width/2, 0, fromView.frame.size.width/2, fromView.frame.size.height);
                         rightView.frame = CGRectMake(fromView.frame.size.width, 0, fromView.frame.size.width/2, fromView.frame.size.height);
                     }
                     completion:^(BOOL finished) {
                         fromView.hidden = NO;
                         [leftView removeFromSuperview];
                         [rightView removeFromSuperview];
                         [transitionContext completeTransition:YES];
                     }];
}

- (void)popAnimation:(id<UIViewControllerContextTransitioning>)transitionContext{
    
    //取出转场前后视图控制器上的视图view
    UIView * toView = [transitionContext viewForKey:UITransitionContextToViewKey];
    UIView * fromView = [transitionContext viewForKey:UITransitionContextFromViewKey];
    
    UIView *containerView = [transitionContext containerView];
    
    //左侧动画视图
    UIView * leftView = [[UIView alloc] initWithFrame:CGRectMake(-toView.frame.size.width/2, 0, toView.frame.size.width/2, toView.frame.size.height)];
    leftView.clipsToBounds = YES;
    [leftView addSubview:toView];
    
    //右侧动画视图
    // 使用系统自带的snapshotViewAfterScreenUpdates:方法，参数为YES，代表视图的属性改变渲染完毕后截屏，参数为NO代表立刻将当前状态的视图截图
    UIView *rightToView = [toView snapshotViewAfterScreenUpdates:YES];
    rightToView.frame = CGRectMake(-toView.frame.size.width/2, 0, toView.frame.size.width, toView.frame.size.height);
    UIView * rightView = [[UIView alloc] initWithFrame:CGRectMake(toView.frame.size.width, 0, toView.frame.size.width/2, toView.frame.size.height)];
    rightView.clipsToBounds = YES;
    [rightView addSubview:rightToView];
    
    //加入动画视图
    [containerView addSubview:fromView];
    [containerView addSubview:leftView];
    [containerView addSubview:rightView];
    
    [UIView animateWithDuration:[self transitionDuration:transitionContext]
                          delay:0
                        options:UIViewAnimationOptionTransitionFlipFromRight
                     animations:^{
                         leftView.frame = CGRectMake(0, 0, toView.frame.size.width/2, toView.frame.size.height);
                         rightView.frame = CGRectMake(toView.frame.size.width/2, 0, toView.frame.size.width/2, toView.frame.size.height);
                     }
                     completion:^(BOOL finished) {
                         //由于加入了手势交互转场，所以需要根据手势动作是否完成/取消来做操作
                         [transitionContext completeTransition:![transitionContext transitionWasCancelled]];
                         if([transitionContext transitionWasCancelled]){
                             //手势取消
                         }else{
                             //手势完成
                             [containerView addSubview:toView];
                         }
                         
                         [leftView removeFromSuperview];
                         [rightView removeFromSuperview];
                         toView.hidden = NO;
                         
                     }];
}

- (void)modelAnimation:(id<UIViewControllerContextTransitioning>)transitionContext type:(TaigaAnimatedTransitioningType)type {
//1.持有transitionContext上下文
    _context = transitionContext;
    //2.获取view的容器
    UIView *containerView = [transitionContext containerView];
    //3.初始化toVc,把toVc的view添加到容器view
    UIViewController *toVc =[transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    
    //4.添加动画
    /*
     拆分动画
     4.1 2个圆(大小圆的中心点一致)
     4.2 贝塞尔
     4.3 蒙版
     */
    UIView *btn = taigaSuspendedEntrance.suspendedView;
    UIViewController *VC1;
    UIViewController *VC2;
    if (self.type == TaigaAnimatedTransitioningTypePresent) {
        VC1 =[transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
        VC2 = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    }else{
        VC2 =[transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
        VC1 = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    }
     [containerView addSubview:VC1.view];
     [containerView addSubview:VC2.view];
    //5.画出小圆
    UIBezierPath *smallPath =[UIBezierPath bezierPathWithOvalInRect:btn.frame];//内切圆
    CGPoint centerP;
    centerP = btn.center;
    //6.求大圆半径 勾股定理
    CGFloat radius;
    CGFloat y = CGRectGetHeight(toVc.view.bounds)-CGRectGetMaxY(btn.frame)+CGRectGetHeight(btn.bounds)/2;
    CGFloat x = CGRectGetWidth(toVc.view.bounds)-CGRectGetMaxX(btn.frame)+CGRectGetWidth(btn.bounds)/2;
    if (btn.frame.origin.x >CGRectGetWidth(toVc.view.bounds)/2) {
        //位于1，4象限
        if (CGRectGetMaxY(btn.frame)< CGRectGetHeight(toVc.view.bounds)/2) {
            //第一象限
            //sqrtf(求平方根)
            radius = sqrtf(btn.center.x *btn.center.x +y*y);
        }else{
            //第四象限
            radius = sqrtf(btn.center.x * btn.center.x + btn.center.y*btn.center.y);
        }
    }else{
        if (CGRectGetMaxY(btn.frame)<CGRectGetHeight(toVc.view.frame)) {
            //第二象限
            radius = sqrtf(x*x+y*y);
        }else{
            //第三象限
            radius = sqrtf(x*x + btn.center.y*btn.center.y);
        }
    }
    //7.画大圆
    UIBezierPath * bigPath = [UIBezierPath bezierPathWithArcCenter:centerP radius:radius startAngle:0 endAngle:2*M_PI clockwise:YES];
    //8.
    CAShapeLayer *shapeLayer =[CAShapeLayer layer];
    
    if (self.type == TaigaAnimatedTransitioningTypePresent) {
        shapeLayer.path = bigPath.CGPath;
    } else{
        shapeLayer.path = smallPath.CGPath;
    }
    
    //9.添加蒙版
//    [toVc.view.layer addSublayer:shapeLayer];
    UIViewController *VC;
    if (self.type == TaigaAnimatedTransitioningTypePresent) {
        VC = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    }else{
        VC = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    }
    VC.view.layer.mask = shapeLayer;
    
    //10.给layer添加动画
    CABasicAnimation *anim =[CABasicAnimation animationWithKeyPath:@"path"];
    if (self.type == TaigaAnimatedTransitioningTypePresent) {
         anim.fromValue = (id)smallPath.CGPath;
    }else{
         anim.fromValue = (id)bigPath.CGPath;
    }
    //重要，动画时间要和转场时间一致
    anim.duration = [self transitionDuration:transitionContext];
    anim.delegate = self;
    [shapeLayer addAnimation:anim forKey:nil];
}

#pragma mark - CAAnimationDelegate
-(void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag{
    [_context completeTransition:YES];
    //去掉蒙版
    if (self.type == TaigaAnimatedTransitioningTypePresent) {
        UIViewController * toVc = [_context viewControllerForKey:UITransitionContextToViewControllerKey];
        toVc.view.layer.mask = nil;
    }else{
        UIViewController * toVc = [_context viewControllerForKey:UITransitionContextFromViewControllerKey];
        toVc.view.layer.mask = nil;
    }
  
}



@end
