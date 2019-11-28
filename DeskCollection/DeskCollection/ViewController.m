//
//  ViewController.m
//  DeskCollection
//
//  Created by Taiga on 2019/11/26.
//  Copyright © 2019 Taiga. All rights reserved.
//

#import "ViewController.h"
#import "TaigaSuspendedEntrance.h"

#import "DeskViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = @"Root";
    
//    self.automaticallyAdjustsScrollViewInsets = NO;
//    [self.navigationController setNavigationBarHidden:YES];
    
    [[TaigaSuspendedEntrance sharedInstance] show];
    
    UIWindow *window = taigaSuspendedEntrance.window;
    CGFloat left = 10.0;
    CGFloat top = 20.0;
    CGFloat bottom = 0;
    if (@available(iOS 11.0, *)) {
        top = window.safeAreaInsets.top;
        bottom = window.safeAreaInsets.bottom;
    }
    
    CGRect rect = window.bounds;
    rect.origin.x += left;
    rect.origin.y += top;
    rect.size.width -= (left * 2);
    rect.size.height -= (top + bottom);
    taigaSuspendedEntrance.activityRect = rect;
    
    __weak typeof(self) weakself = self;
    taigaSuspendedEntrance.suspendedView.actionBlcok = ^(TaigaSuspendedView * _Nonnull block_sv, int operation) {
        [weakself showDeskVC];
    };
}

- (void)showDeskVC {
    UINavigationController *nav = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"DeskNavigationController"];
    nav.transitioningDelegate = taigaSuspendedEntrance;
    nav.modalPresentationStyle = UIModalPresentationFullScreen;
    [self presentViewController:nav animated:YES completion:nil];
    
    
//    DeskViewController *vc = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"DeskViewController"];
//    vc.modalPresentationStyle = UIModalPresentationFullScreen;
//    self.navigationController.delegate = taigaSuspendedEntrance;
//    [self.navigationController pushViewController:vc animated:YES];
}

- (void)showDeskVCWithAnimatedTransitioning {
    UINavigationController *nav = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"DeskNavigationController"];
    
    UIViewController *superVC = self;
    UIViewController *childVC = nav;
    
    [superVC addChildViewController:childVC];
    [childVC willMoveToParentViewController:superVC];
    
    childVC.view.frame = superVC.view.bounds;
    [superVC.view addSubview:childVC.view];
    
    [childVC didMoveToParentViewController:superVC];
    
    childVC.view.frame = taigaSuspendedEntrance.suspendedView.frame;
    [UIView animateWithDuration:0.25 animations:^{
        childVC.view.frame = superVC.view.bounds;
    }];
    
}


@end
