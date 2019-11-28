//
//  TaigaSuspendedView.h
//  DeskCollection
//
//  Created by Taiga on 2019/11/26.
//  Copyright © 2019 Taiga. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface TaigaSuspendedView : UIView

@property(nonatomic, nullable, copy) NSArray *gradientColors;

@property (nonatomic, assign, readonly) CGFloat width;

@property (nonatomic, strong, readonly) UIButton *button;
@property (nonatomic, copy, nullable) void (^actionBlcok)(TaigaSuspendedView *block_sv, int operation);

//- (void)addTapGestureRecognizer;
//- (void)removeTapGestureRecognizer;

@end

NS_ASSUME_NONNULL_END
