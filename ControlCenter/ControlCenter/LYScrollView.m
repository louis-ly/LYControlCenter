//
//  LYScrollView.m
//  ControlCenter
//
//  Created by louis on 2017/3/3.
//  Copyright © 2017年 louis. All rights reserved.
//


#import "LYScrollView.h"
#import <objc/runtime.h>

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wincomplete-implementation"
@implementation MyScrollView
#pragma clang diagnostic pop
@end


#define kScreenWidth [UIScreen mainScreen].bounds.size.width
#define kScreenHeight [UIScreen mainScreen].bounds.size.height
#define kLeftRightMargin 8
#define kBottomMargin 16
#define kImageViewWidth (kScreenWidth - kLeftRightMargin*2)
#define kImageViewHeight (kImageViewWidth*392/344.5)
#define kImageViewY (kScreenHeight*2 - kBottomMargin - kImageViewHeight)
#define kBlackViewMaxAlpha 0.6

@interface LYScrollView () <UIScrollViewDelegate>
@property (nonatomic, strong) UIImageView *imageViewLeft;
@property (nonatomic, strong) UIImageView *imageViewRight;
@property (nonatomic, assign) BOOL targetIsEnd;
@property (nonatomic, assign) BOOL canMove;
@end

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wincomplete-implementation"
@implementation LYScrollView
#pragma clang diagnostic pop
{
    CGPoint _beginDragPoint;
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setupControlCenter];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super initWithCoder:aDecoder]) {
        [self setupControlCenter];
    }
    return self;
}

- (void)setupControlCenter {
    [self.panGestureRecognizer setMaximumNumberOfTouches:1];
    self.delegate = self;
    self.contentSize = CGSizeMake(kScreenWidth*2, kScreenHeight*2);
    self.pagingEnabled = YES;
    self.showsHorizontalScrollIndicator = NO;
    self.showsVerticalScrollIndicator = NO;
    self.directionalLockEnabled = YES;
    self.alwaysBounceVertical = YES;
    self.delegate = self;
    [self addSubview:self.imageViewLeft];
    [self addSubview:self.imageViewRight];
}


#pragma mark - UIScrollViewDelegate
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    // 记录开始滚动时的位置信息，便于后面判断滚动方向
    _beginDragPoint = scrollView.contentOffset;
    _targetIsEnd = NO;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    // 背景色修改
    if (scrollView.contentOffset.y < kScreenHeight) {
        CGFloat alpha = scrollView.contentOffset.y / kScreenHeight - (1 - kBlackViewMaxAlpha);
        self.backgroundColor = [UIColor colorWithWhite:0 alpha:alpha];
    } else {
        self.backgroundColor = [UIColor colorWithWhite:0 alpha:kBlackViewMaxAlpha];
    }
    
    // 如果正在结束动画中，就不要再执行更改contentOffset
    if (_targetIsEnd) return;
    
    // 下面代码需配合 directionalLockEnabled 属性一起使用
    // 如果滑动方向处于45度左右，属性directionalLockEnabled则失效了
    // 通过下面设置，辅助滚到是一个方向
    if (scrollView.contentOffset.x == _beginDragPoint.x) {
        self.contentOffset = CGPointMake(_beginDragPoint.x, (self.contentOffset.y));
    } else {
        self.contentOffset = CGPointMake((self.contentOffset.x), _beginDragPoint.y);
    }
}

- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset {
    // 判断视图是否将要隐藏
    if ((*targetContentOffset).y == 0) {
        // 设置此值是为了在scrollViewDidScroll方法中contentOffset值不要再被更改，保持0,0
        _targetIsEnd = YES;
        // 防止消失过程中又被滑动了
        self.userInteractionEnabled = NO;
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    // 停止滚动时判断视图是否滚到下面了
    if (scrollView.contentOffset.y == 0) {
        // 移除视图
        [self removeFromSuperview];
        // 设置为初始位置
        [self setContentOffset:CGPointMake(0, 0)];
    }
}

- (void)handlePan:(UIPanGestureRecognizer *)pan {
    CGPoint point = [pan locationInView:pan.view];
    
    if (pan.state == UIGestureRecognizerStateBegan) {
        [pan setTranslation:CGPointZero inView:pan.view];
        [super handlePan:pan];
    } else if (pan.state == UIGestureRecognizerStateChanged) {
        
        // 一旦手指位置到达视图时，则开始移动
        if (!_canMove && point.y > kImageViewY) {
            _canMove = YES;
            [pan setTranslation:CGPointZero inView:pan.view];
        }
        
        if (_canMove) {
            [super handlePan:pan];
        }
        
    } else if (pan.state == UIGestureRecognizerStateEnded || pan.state == UIGestureRecognizerStateCancelled) {
        _canMove = NO;
        [pan setTranslation:CGPointZero inView:pan.view];
        [super handlePan:pan];
    }
}

#pragma mark - Public Methods
- (void)showToView:(UIView *)view {
    self.userInteractionEnabled = YES;
    [view addSubview:self];
    [self setContentOffset:CGPointMake(0, kScreenHeight) animated:YES];
}

- (UIImageView *)imageViewLeft {
    if (!_imageViewLeft) {
        _imageViewLeft = [[UIImageView alloc] initWithFrame:CGRectMake(kLeftRightMargin, kImageViewY, kImageViewWidth, kImageViewHeight)];
        _imageViewLeft.image = [UIImage imageNamed:@"WechatIMG7"];
        _imageViewLeft.layer.cornerRadius = 15;
        _imageViewLeft.layer.masksToBounds = YES;
    }
    return _imageViewLeft;
}

- (UIImageView *)imageViewRight {
    if (!_imageViewRight) {
        _imageViewRight = [[UIImageView alloc] initWithFrame:CGRectMake(kLeftRightMargin+kScreenWidth, kImageViewY, kImageViewWidth, kImageViewHeight)];
        _imageViewRight.image = [UIImage imageNamed:@"WechatIMG8"];
        _imageViewRight.layer.cornerRadius = 15;
        _imageViewRight.layer.masksToBounds = YES;
    }
    return _imageViewRight;
}
@end
