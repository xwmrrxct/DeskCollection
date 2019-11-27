//
//  TaigaSuspendedView.m
//  DeskCollection
//
//  Created by Taiga on 2019/11/26.
//  Copyright © 2019 Taiga. All rights reserved.
//

#import "TaigaSuspendedView.h"

@interface TaigaSuspendedView ()

@property (nonatomic, strong) CALayer *shadowLayer;
@property (nonatomic, strong) CALayer *cornerLayer;

//@property (nonatomic, assign) CGFloat width;
@property (nonatomic, strong) UITapGestureRecognizer *tap;


@end

@implementation TaigaSuspendedView

- (instancetype)init
{
    return [self initWithFrame:CGRectMake(0, 0, self.width, self.width)];
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
    
    [self updateShadowLayer];
}


- (void)updateShadowLayer {
    
    CALayer *layer = self.layer;
    layer.backgroundColor = [UIColor clearColor].CGColor;
    
    CGSize size = layer.bounds.size;
    CGFloat inset = -0.0;
    CGFloat edgeInset = 10.0;
    CGFloat shadowOffset = edgeInset + inset;
    
    
    if (!self.shadowLayer) {
        self.shadowLayer = [CALayer layer];
    }
    CALayer *shadowLayer = self.shadowLayer;
    shadowLayer.frame = CGRectMake(0, 0, size.width - (edgeInset * 2.0), size.height - (edgeInset * 2.0));
    shadowLayer.position = CGPointMake(layer.bounds.size.width / 2.0, layer.bounds.size.height / 2.0);
    shadowLayer.backgroundColor = [UIColor whiteColor].CGColor;
    shadowLayer.shadowColor = [UIColor colorWithWhite:0.0 alpha:1.0].CGColor;
    shadowLayer.shadowOpacity = 0.3;
    shadowLayer.shadowOffset = CGSizeMake(0.0, 0.0);
    shadowLayer.shadowRadius = 5.0;
    
    UIBezierPath *path = [UIBezierPath bezierPathWithRect:CGRectMake(-shadowOffset, -shadowOffset, CGRectGetWidth(shadowLayer.frame) + (shadowOffset * 2), CGRectGetHeight(shadowLayer.frame) + (shadowOffset * 2))];
    shadowLayer.shadowPath = path.CGPath;
    
    path = [UIBezierPath bezierPathWithArcCenter:CGPointMake(CGRectGetWidth(shadowLayer.frame) / 2.0, CGRectGetHeight(shadowLayer.frame) / 2.0) radius:(size.width / 2.0 + 5.0) startAngle:0 endAngle:2 * M_PI clockwise:NO];
    shadowLayer.shadowPath = path.CGPath;
    
    
    if (!self.cornerLayer) {
        self.cornerLayer = [CALayer layer];
    }
    CALayer *cornerLayer = self.cornerLayer;
    cornerLayer.frame = layer.bounds;
    
    cornerLayer.backgroundColor = [UIColor blueColor].CGColor;
    cornerLayer.cornerRadius = CGRectGetWidth(self.frame) / 2.0;
    cornerLayer.masksToBounds = YES;
    
    [layer insertSublayer:cornerLayer atIndex:0];
    [layer insertSublayer:shadowLayer atIndex:0];
}


- (CGFloat)width {
    return 50.0;
}

- (void)setupView {
//    self.width = 50.0;
    self.backgroundColor = [UIColor clearColor];
    
    [self addTapGestureRecognizer];
}

- (void)addTapGestureRecognizer {
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(gestureHandle:)];
    tap.numberOfTapsRequired = 1;
    [self addGestureRecognizer:tap];
    
    self.tap = tap;
}

- (void)removeTapGestureRecognizer {
    [self removeGestureRecognizer:self.tap];
}


- (void)gestureHandle:(UIGestureRecognizer *)sender {
    if (sender == _tap) {
        if (self.actionBlcok) {
            self.actionBlcok(self, 0);
        }
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
