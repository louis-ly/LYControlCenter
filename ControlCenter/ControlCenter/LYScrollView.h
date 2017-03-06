//
//  LYScrollView.h
//  ControlCenter
//
//  Created by louis on 2017/3/3.
//  Copyright © 2017年 louis. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MyScrollView : UIScrollView
- (void)handlePan:(UIPanGestureRecognizer *)pan;
@end

@interface LYScrollView : MyScrollView
@property (nonatomic, assign) CGFloat canTouchY;
- (void)showToView:(UIView *)view;
@end
