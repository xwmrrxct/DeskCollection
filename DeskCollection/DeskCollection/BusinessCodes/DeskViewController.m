//
//  DeskViewController.m
//  DeskCollection
//
//  Created by Taiga on 2019/11/26.
//  Copyright © 2019 Taiga. All rights reserved.
//

#import "DeskViewController.h"
#import "TaigaSuspendedEntrance.h"

#import "TaigaDeskView.h"

@interface DeskViewController ()

@property (nonatomic, strong) TaigaDeskView *deskView;

@end

@implementation DeskViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = @"Desk";
    
    self.view.backgroundColor = [UIColor orangeColor];
    
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithTitle:@"完成" style:UIBarButtonItemStylePlain target:self action:@selector(barButtonPressed:)];
    
    [self.navigationItem setRightBarButtonItems:@[item]];
    
    
    TaigaDeskView *deskView = [[TaigaDeskView alloc] initWithFrame:self.view.bounds];
    self.deskView = deskView;
    [self.view addSubview:deskView];
    
}

- (void)barButtonPressed:(UIBarButtonItem *)sender {
    [self dismissVC];
//    [self popVC];
}

- (void)dismissVC {
    [self dismissViewControllerAnimated:YES completion:^{}];
    
//    [UIView animateWithDuration:0.25 animations:^{
//        self.navigationController.view.frame = taigaSuspendedEntrance.suspendedView.frame;
//    } completion:^(BOOL finished) {
//        [self.navigationController.view removeFromSuperview];
//        [self.navigationController removeFromParentViewController];
//    }];
    
}

- (void)popVC {
    [self.navigationController popViewControllerAnimated:YES];
}

//- (void)removeFromParentViewController

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
