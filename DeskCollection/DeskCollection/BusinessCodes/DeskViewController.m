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

- (void)dealloc
{
    NSLog(@"desk view controller did dealloc.");
}

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
    
//    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//    });
    [self configDataSource];
}

- (void)configDataSource {
    NSMutableArray *mArray = [[NSMutableArray alloc] init];
    for (int i = 0; i < 20; i++) {
        FileEntity *entity = [[FileEntity alloc] init];
        entity.type = FileTypeNormal;
        entity.state = FileStateNormal;
        entity.title = [NSString stringWithFormat:@"taiga%i", i];
        entity.img = @"ymb_img";
        if (i == 0) {
            entity.type = FileTypeAdd;
            entity.img = @"add";
        }
        [mArray addObject:entity];
    }
    
    _deskView.dataSource = mArray;
    [_deskView reloadData];
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
