//
//  TaigaDeskView.m
//  DeskCollection
//
//  Created by Taiga on 2019/11/28.
//  Copyright © 2019 Taiga. All rights reserved.
//

#import "TaigaDeskView.h"
#import "DeskCollectionCell.h"

@interface TaigaDeskView () <UICollectionViewDelegate, UICollectionViewDataSource>

@property (nonatomic, strong) UICollectionViewFlowLayout *flowLayout;
@property (nonatomic, strong) UICollectionView *collectionView;

@property (nonatomic, strong) DeskCollectionCell *draggingCell;

@end

@implementation TaigaDeskView

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        [self setupView];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupView];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    [self updateCollectionLayout];
}

- (void)setupView {
    self.backgroundColor = [UIColor whiteColor];
    
    [self updateCollectionLayout];
    
    UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:self.bounds collectionViewLayout:self.flowLayout];
    self.collectionView = collectionView;
    collectionView.delegate = self;
    collectionView.dataSource = self;
    collectionView.backgroundColor = [UIColor whiteColor];
    
    [self addSubview:collectionView];
    
    [collectionView registerNib:[UINib nibWithNibName:@"DeskCollectionCell" bundle:nil] forCellWithReuseIdentifier:@"DeskCollectionCell"];
    
    [self.draggingCell setHidden:YES];
    [collectionView addSubview:self.draggingCell];
    
    UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(gestureHandle:)];
    longPress.minimumPressDuration = 0.3f;
    [self.collectionView addGestureRecognizer:longPress];
}

- (void)updateCollectionLayout {
    CGFloat width = CGRectGetWidth(self.frame);
    
    int colCount = 3;
    
    CGFloat spaceX = 30.0;
    CGFloat spaceY = 30.0;
    CGFloat sectionInsetX = 20.0;
    CGFloat sectionInsetY = 20.0;

    CGFloat itemWidth = (width - (2 * sectionInsetX) - ((colCount - 1) * spaceX)) / colCount;
    itemWidth = floor(itemWidth);
    CGFloat itemHeight = 180.0;
    
    UICollectionViewFlowLayout *layout = self.flowLayout;
    if (!layout) {
        layout = [[UICollectionViewFlowLayout alloc] init];
        self.flowLayout = layout;
    }
    
    layout.sectionInset = UIEdgeInsetsMake(sectionInsetY, sectionInsetX, sectionInsetY, sectionInsetX);
    layout.itemSize = CGSizeMake(itemWidth, itemHeight);
    layout.minimumInteritemSpacing = spaceX;
    layout.minimumLineSpacing = spaceY;
    layout.scrollDirection = UICollectionViewScrollDirectionVertical;
    
    DeskCollectionCell *cell = self.draggingCell;
    if (!cell) {
        DeskCollectionCell *cell = [[DeskCollectionCell alloc] initWithFrame:CGRectMake(0, 0, itemWidth, itemHeight)];
        self.draggingCell = cell;
    }
    cell.frame = CGRectMake(0, 0, itemWidth, itemHeight);
}


- (void)gestureHandle:(UIGestureRecognizer *)sender {
    UILongPressGestureRecognizer *longPresss = (UILongPressGestureRecognizer *)sender;
    if (sender.state == UIGestureRecognizerStateBegan) {
        [self dragBegan:longPresss];
    }
    else if (sender.state == UIGestureRecognizerStateChanged) {
        [self dragChanged:longPresss];
    }
    else if (sender.state == UIGestureRecognizerStateEnded || sender.state == UIGestureRecognizerStateCancelled || sender.state == UIGestureRecognizerStateFailed) {
        [self dragEnded:longPresss];
    }
}


- (void)dragBegan:(UILongPressGestureRecognizer *)longPress {
    
}

- (void)dragChanged:(UILongPressGestureRecognizer *)longPress {
    
}

- (void)dragEnded:(UILongPressGestureRecognizer *)longPress {
    
}



#pragma mark 辅助方法
//获取被拖动IndexPath的方法
- (NSIndexPath*)getDragingIndexPathWithPoint:(CGPoint)point{
    NSIndexPath* dragIndexPath = nil;
    //最后剩一个怎不可以排序
    if ([self.collectionView numberOfItemsInSection:0] == 1) {return dragIndexPath;}
    for (NSIndexPath *indexPath in self.collectionView.indexPathsForVisibleItems) {
        //下半部分不需要排序
        if (indexPath.section > 0) {continue;}
        //在上半部分中找出相对应的Item
        if (CGRectContainsPoint([self.collectionView cellForItemAtIndexPath:indexPath].frame, point)) {
            if (indexPath.row != 0) {
                dragIndexPath = indexPath;
            }
            break;
        }
    }
    return dragIndexPath;
}

//获取目标IndexPath的方法
- (NSIndexPath*)getTargetIndexPathWithPoint:(CGPoint)point {
    NSIndexPath *targetIndexPath = nil;
    for (NSIndexPath *indexPath in self.collectionView.indexPathsForVisibleItems) {
        //如果是自己不需要排序
//        if ([indexPath isEqual:self.dragingIndexPath]) {continue;}
        //第二组不需要排序
        if (indexPath.section > 0) {continue;}
        //在第一组中找出将被替换位置的Item
        if (CGRectContainsPoint([self.collectionView cellForItemAtIndexPath:indexPath].frame, point)) {
            if (indexPath.row != 0) {
                targetIndexPath = indexPath;
            }
        }
    }
    return targetIndexPath;
}



#pragma mark - UICollectionViewDelegate, UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return 20.0;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    DeskCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"DeskCollectionCell" forIndexPath:indexPath];
    
    cell.titleLabel.text = [NSString stringWithFormat:@"taiga%i", (int)indexPath.row];
    
    return cell;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
