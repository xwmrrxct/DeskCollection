//
//  TaigaDeskView.m
//  DeskCollection
//
//  Created by Taiga on 2019/11/28.
//  Copyright © 2019 Taiga. All rights reserved.
//

#import "TaigaDeskView.h"
#import "DeskCollectionCell.h"

typedef NS_ENUM(NSInteger, DragOperation) {
    DragOperationNone   = 0,
    DragOperationMove,        // 移动
    DragOperationIntoFolder,      // 拖入文件夹
    DragOperationCancel,
};

typedef NS_ENUM(NSUInteger, DragDirection) {
    DragDirectionNone = 0,
    DragDirectionLeft,
    DragDirectionRight,
    DragDirectionUp,
    DragDirectionDown,
};

@interface TaigaDeskView () <UICollectionViewDelegate, UICollectionViewDataSource>

@property (nonatomic, assign) DragOperation dragOperation;
@property (nonatomic, assign) CFAbsoluteTime overlapTime;

@property (nonatomic, strong) UICollectionViewFlowLayout *flowLayout;
@property (nonatomic, strong) UICollectionView *collectionView;

@property (nonatomic, strong) DeskCollectionCell *draggingCell;
@property (nonatomic, strong) NSIndexPath *draggingIndexPath;
@property (nonatomic, strong) NSIndexPath *targetIndexPath;

@property (nonatomic, strong) CADisplayLink *edgeTimer;
@property (nonatomic, assign) BOOL edgeScrollEnable;
@property (nonatomic, assign) DragDirection dragDirection;

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
    self.edgeScrollEnable = YES;
    
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
    CGFloat itemHeight = 200.0;
    
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
        cell = [DeskCollectionCell loadCellFromNib];
//        DeskCollectionCell *cell = [[DeskCollectionCell alloc] initWithFrame:CGRectMake(0, 0, itemWidth, itemHeight)];
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
    CGPoint point = [longPress locationInView:self.collectionView];
    self.draggingIndexPath = [self getDragingIndexPathWithPoint:point];
    if (!self.draggingIndexPath) return;
    self.isDragging = YES;
    
    DeskCollectionCell *cell = (DeskCollectionCell *)[self.collectionView cellForItemAtIndexPath:self.draggingIndexPath];
    self.draggingCell = [self deepCopyCell:cell];
    
    FileEntity *entity = [self.dataSource objectAtIndex:self.draggingIndexPath.row];
    entity.state = FileStateTarget;
    [cell setHidden:YES];
    [self.draggingCell setHidden:NO];
    
    [self setupEdgeTimer];
    self.overlapTime = -1;
}

- (void)dragChanged:(UILongPressGestureRecognizer *)longPress {
    if (!self.draggingIndexPath) return;
    
    CGPoint point = [longPress locationInView:self.collectionView];
    self.draggingCell.center = point;
    self.targetIndexPath = [self getTargetIndexPathWithPoint:point];
    
    self.dragOperation = [self dragOperation:point];
    if (self.dragOperation == DragOperationMove) {
        [self moveCell];
    }
    else if (self.dragOperation == DragOperationIntoFolder) {
        [self intoFolder];
        [self dragEnded:longPress];
    }
}

- (void)dragEnded:(UILongPressGestureRecognizer *)longPress {
    self.isDragging = NO;
    
    [self stopEdgeTimer];
    
    if (self.dragOperation == DragOperationMove) {
        DeskCollectionCell *cell = (DeskCollectionCell *)[self.collectionView cellForItemAtIndexPath:self.draggingIndexPath];

        FileEntity *entity = [self.dataSource objectAtIndex:self.draggingIndexPath.row];
        
        [UIView animateWithDuration:0.25 animations:^{
            self.draggingCell.frame = cell.frame;
        } completion:^(BOOL finished) {
            entity.state = FileStateNormal;
            [cell setHidden:NO];
            [self.draggingCell setHidden:YES];
            [self.draggingCell removeFromSuperview];
        }];
    }
    else if (self.dragOperation == DragOperationIntoFolder) {
        DeskCollectionCell *cell = (DeskCollectionCell *)[self.collectionView cellForItemAtIndexPath:self.draggingIndexPath];
        [cell setHidden:NO];
        FileEntity *entity = [self.dataSource objectAtIndex:self.draggingIndexPath.row];
        entity.state = FileStateNormal;

        [self dragDidStop];
    }
    else {
        DeskCollectionCell *cell = (DeskCollectionCell *)[self.collectionView cellForItemAtIndexPath:self.draggingIndexPath];
        [cell setHidden:NO];
        FileEntity *entity = [self.dataSource objectAtIndex:self.draggingIndexPath.row];
        entity.state = FileStateNormal;
        
        [self dragDidStop];
    }
}


#pragma mark - private methods
- (DragOperation)dragOperation:(CGPoint)point {
    
    if (!self.draggingIndexPath || !self.targetIndexPath) {
        return DragOperationNone;
    }
    DeskCollectionCell *target = (DeskCollectionCell *)[self.collectionView cellForItemAtIndexPath:self.targetIndexPath];
    
    CGFloat foldX = CGRectGetWidth(target.frame) / 4.0;
    CGFloat foldY = CGRectGetHeight(target.frame) / 4.0;
    
    CGFloat dx = fabs(target.center.x - point.x);
    CGFloat dy = fabs(target.center.y - point.y);
//    if (CGRectContainsPoint(target.frame, point))
    if (dx > foldX || dy > foldY) {
        CFAbsoluteTime t = CFAbsoluteTimeGetCurrent();
        if (self.overlapTime <= 0) {
            self.overlapTime = t;
        }
        else if (t - self.overlapTime > 0.5) {
            return DragOperationIntoFolder;
        }
        
    }
    else {
        self.overlapTime = -1;
        return DragOperationMove;
    }
    
    return DragOperationNone;
}

- (void)moveCell {
    if (!self.draggingIndexPath || !self.targetIndexPath) {
        return;
    }
    
    id obj = [self.dataSource objectAtIndex:self.draggingIndexPath.row];
    [self.dataSource removeObject:obj];
    [self.dataSource insertObject:obj atIndex:self.targetIndexPath.row];

    [self.collectionView moveItemAtIndexPath:self.draggingIndexPath toIndexPath:self.targetIndexPath];
    self.draggingIndexPath = self.targetIndexPath;
}
 
- (void)intoFolder {
    if (!self.draggingIndexPath || !self.targetIndexPath) {
        return;
    }
    FileEntity *f1 = [self.dataSource objectAtIndex:self.draggingIndexPath.row];
    if (f1.type != FileTypeNormal) {
        return;
    }
    FileEntity *f2 = [self.dataSource objectAtIndex:self.targetIndexPath.row];
    
    FileEntity *f3 = [FileEntity folderEntity];
    f3.files = [[NSMutableArray alloc] init];
    
    if (f2.type == FileTypeNormal) {
        [f3.files addObject:f1];
        [f3.files addObject:f2];
    }
    else if (f2.type == FileTypeFolder) {
        [f3.files addObject:f1];
        [f3.files addObjectsFromArray:f2.files];
    }
    
    [self.dataSource replaceObjectAtIndex:self.targetIndexPath.row withObject:f3];
    [self.collectionView reloadItemsAtIndexPaths:@[self.targetIndexPath]];
    
    [self.dataSource removeObject:f1];
    [self.collectionView deleteItemsAtIndexPaths:@[self.draggingIndexPath]];
    
    DeskCollectionCell *target = (DeskCollectionCell *)[self.collectionView cellForItemAtIndexPath:self.targetIndexPath];
    self.draggingCell.frame = target.frame;
    self.draggingIndexPath = nil;
    self.targetIndexPath = nil;
    
    self.collectionView.userInteractionEnabled = NO;
    [UIView animateWithDuration:1.8 animations:^{
        self.draggingCell.transform = CGAffineTransformMakeScale(0.2, 0.2);
    } completion:^(BOOL finished) {
        [self dragDidStop];
        self.collectionView.userInteractionEnabled = YES;
    }];
}

- (void)dragDidStop {
    [self.draggingCell setHidden:YES];
    [self.draggingCell removeFromSuperview];
    
    self.draggingIndexPath = nil;
    self.targetIndexPath = nil;
}


#pragma mark 辅助方法
//获取被拖动IndexPath的方法
- (NSIndexPath *)getDragingIndexPathWithPoint:(CGPoint)point{
    NSIndexPath *dragIndexPath = nil;
    //最后剩一个不排序
    if ([self.collectionView numberOfItemsInSection:0] == 1) {return nil;}
    for (NSIndexPath *indexPath in self.collectionView.indexPathsForVisibleItems) {
        //找出相对应的Item
        if (CGRectContainsPoint([self.collectionView cellForItemAtIndexPath:indexPath].frame, point)) {
            FileEntity *entity = [self.dataSource objectAtIndex:indexPath.row];
            if ([entity canMove]) {
                dragIndexPath = indexPath;
            }
            break;
        }
    }
    return dragIndexPath;
}

//获取目标IndexPath的方法
- (NSIndexPath *)getTargetIndexPathWithPoint:(CGPoint)point {
    NSIndexPath *targetIndexPath = nil;
    for (NSIndexPath *indexPath in self.collectionView.indexPathsForVisibleItems) {
        //如果是自己不需要排序
        if ([indexPath isEqual:self.draggingIndexPath]) {continue;}
        //在第一组中找出将被替换位置的Item
        if (CGRectContainsPoint([self.collectionView cellForItemAtIndexPath:indexPath].frame, point)) {
            FileEntity *entity = [self.dataSource objectAtIndex:indexPath.row];
            if ([entity canMove]) {
                targetIndexPath = indexPath;
            }
            break;
        }
    }
    return targetIndexPath;
}

- (DeskCollectionCell *)deepCopyCell:(DeskCollectionCell *)cell {
    if (!cell) {
        return nil;
    }
    
    DeskCollectionCell *copy = [DeskCollectionCell loadCellFromNib];
    copy.frame = cell.frame;
    
    [copy updateCellWithParams:cell.entity];
    
    [copy setHidden:YES];
    [self.collectionView addSubview:copy];
    return copy;
}


- (void)reloadData {
    [self.collectionView reloadData];
}


#pragma mark - timer methods

- (void)setupEdgeTimer{
    if (!_edgeTimer && _edgeScrollEnable) {
        _edgeTimer = [CADisplayLink displayLinkWithTarget:self selector:@selector(edgeScroll)];
        [_edgeTimer addToRunLoop:[NSRunLoop mainRunLoop] forMode:NSRunLoopCommonModes];
    }
}

- (void)stopEdgeTimer{
    if (_edgeTimer) {
        [_edgeTimer invalidate];
        _edgeTimer = nil;
    }
}


- (void)determineScrollDirection{
    _dragDirection = DragDirectionNone;
    UIScrollView *scrollView = self.collectionView;
    UIView *draggingView = self.draggingCell;
    if (scrollView.bounds.size.height + scrollView.contentOffset.y - draggingView.center.y < draggingView.bounds.size.height / 2 && scrollView.bounds.size.height + scrollView.contentOffset.y < scrollView.contentSize.height) {
        _dragDirection = DragDirectionDown;
    }
    if (draggingView.center.y - scrollView.contentOffset.y < draggingView.bounds.size.height / 2 && scrollView.contentOffset.y > 0) {
        _dragDirection = DragDirectionUp;
    }
    if (scrollView.bounds.size.width + scrollView.contentOffset.x - draggingView.center.x < draggingView.bounds.size.width / 2 && scrollView.bounds.size.width + scrollView.contentOffset.x < scrollView.contentSize.width) {
        _dragDirection = DragDirectionRight;
    }
    if (draggingView.center.x - scrollView.contentOffset.x < draggingView.bounds.size.width / 2 && scrollView.contentOffset.x > 0) {
        _dragDirection = DragDirectionLeft;
    }
}

- (void)edgeScroll {
    [self determineScrollDirection];
    UIScrollView *scrollView = self.collectionView;
    UIView *draggingView = self.draggingCell;
    CGFloat step = 4;
    switch (_dragDirection) {
        case DragDirectionLeft:{
            //这里的动画必须设为NO
            [scrollView setContentOffset:CGPointMake(scrollView.contentOffset.x - step, scrollView.contentOffset.y) animated:NO];
            draggingView.center = CGPointMake(draggingView.center.x - step, draggingView.center.y);
//            _lastPoint.x -= step;
            
        }
            break;
        case DragDirectionRight:{
            [scrollView setContentOffset:CGPointMake(scrollView.contentOffset.x + step, scrollView.contentOffset.y) animated:NO];
            draggingView.center = CGPointMake(draggingView.center.x + step, draggingView.center.y);
        }
            break;
        case DragDirectionUp:{
            [scrollView setContentOffset:CGPointMake(scrollView.contentOffset.x, scrollView.contentOffset.y - step) animated:NO];
            draggingView.center = CGPointMake(draggingView.center.x, draggingView.center.y - step);
        }
            break;
        case DragDirectionDown:{
            [scrollView setContentOffset:CGPointMake(scrollView.contentOffset.x, scrollView.contentOffset.y + step) animated:NO];
            draggingView.center = CGPointMake(draggingView.center.x, draggingView.center.y + step);
        }
            break;
        default:
            break;
    }
    
}


#pragma mark - UICollectionViewDelegate, UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.dataSource.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    DeskCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"DeskCollectionCell" forIndexPath:indexPath];
    
    FileEntity *entity = self.dataSource[indexPath.row];
    [cell updateCellWithParams:entity];
    
//    [cell setHidden:NO];
//    cell.titleLabel.text = [NSString stringWithFormat:@"taiga%i", (int)indexPath.row];
//    cell.imageView.image = [UIImage imageNamed:(indexPath.row == 0 ? @"add" : @"book")];
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    FileEntity *entity = self.dataSource[indexPath.row];
    if (entity.type == FileTypeAdd) {
        static int i = 0;
        FileEntity *e = [FileEntity fileEntity];
        e.title = [NSString stringWithFormat:@"taiga_add%i", ++i];
        [self.dataSource addObject:e];
        [self reloadData];
    }
    else {
        
    }
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
