//
//  ViewController.m
//  ControlCenter
//
//  Created by louis on 2017/3/3.
//  Copyright © 2017年 louis. All rights reserved.
//

#import "ViewController.h"
#import "LYScrollView.h"

@interface ViewController ()
@property (nonatomic, strong) LYScrollView *scrollView;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (IBAction)alertBtnClicked:(UIButton *)sender {
    [self.scrollView showToView:self.view];
}

- (LYScrollView *)scrollView {
    if (!_scrollView) {
        _scrollView = [[LYScrollView alloc] initWithFrame:self.view.bounds];
    }
    return _scrollView;
}
@end
