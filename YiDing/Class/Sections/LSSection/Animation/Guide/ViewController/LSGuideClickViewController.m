//
//  LSGuideClickViewController.m
//  YiDing
//
//  Created by 王隆帅 on 16/7/14.
//  Copyright © 2016年 王隆帅. All rights reserved.
//

#import "LSGuideClickViewController.h"
#import "QDJumpingAnimateView.h"
#import "QDJumpingAnimateViewModel.h"
#import "QDReadDestroyYinDaoView.h"
#import "QDReadDestroyYinDaoViewModel.h"

@interface LSGuideClickViewController ()

@property (nonatomic, strong) QDJumpingAnimateView *jumpingAnimateView;

@property (nonatomic, strong) QDJumpingAnimateViewModel *jumpingnimatedViewModel;

@property (nonatomic, strong) QDReadDestroyYinDaoView *zHJumpingAnimatedView;

@property (nonatomic, strong) QDReadDestroyYinDaoViewModel *zHJumpingAnimatedViewModel;

@property (nonatomic, strong) UIButton *topBtn;

@property (nonatomic, strong) UIButton *bottomBtn;

@end

@implementation LSGuideClickViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)yd_addSubviews {

    [self.view addSubview:self.topBtn];
    [self.view addSubview:self.bottomBtn];
    
    [self.view setNeedsUpdateConstraints];
    [self.view updateConstraintsIfNeeded];
}

- (void)updateViewConstraints {
    
    [self.topBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(80);
        make.left.equalTo(60);
        make.size.equalTo(CGSizeMake(80, 40));
    }];
    
    [self.bottomBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.bottom.equalTo(-30);
        make.left.equalTo(250);
        make.size.equalTo(CGSizeMake(100, 50));
    }];
    
    [super updateViewConstraints];
}

- (void)yd_bindViewModel {

     @weakify(self);
    [[[self.topBtn rac_signalForControlEvents:UIControlEventTouchUpInside] takeUntil:self.rac_willDeallocSignal] subscribeNext:^(id x) {
        
        @strongify(self);
        self.jumpingnimatedViewModel.jumpView = self.topBtn;
        [self.jumpingAnimateView qd_startShowWithFinish:^{
            
            
        }];
    }];
    
    self.jumpingAnimateView.canJumpBlock = ^(){
    
        @strongify(self);
        self.topBtn.hidden = YES;
    };
    
    self.jumpingAnimateView.disMissFinish = ^(){
    
        @strongify(self);
        self.topBtn.hidden = NO;
    };
    
    [[[self.bottomBtn rac_signalForControlEvents:UIControlEventTouchUpInside] takeUntil:self.rac_willDeallocSignal] subscribeNext:^(id x) {
        
        @strongify(self);
        self.zHJumpingAnimatedViewModel.topAnimatedViewModel.jumpView = self.topBtn;
        self.zHJumpingAnimatedViewModel.bottomAnimatedViewModel.jumpView = self.bottomBtn;
        
        [self.zHJumpingAnimatedView qd_startShowWithFinish:^{
            
        }];
    }];
    
    self.zHJumpingAnimatedView.upCanJumpBlock = ^(){
    
        @strongify(self);
        self.topBtn.hidden = YES;
    };
    
    self.zHJumpingAnimatedView.bottomCanJumpBlock = ^(){
    
        @strongify(self);
        self.bottomBtn.hidden = YES;
    };
    
    self.zHJumpingAnimatedView.disMissFinish = ^(){
    
        @strongify(self);
        self.topBtn.hidden = NO;
        self.bottomBtn.hidden = NO;
    };
}

- (void)yd_layoutNavigation {

    self.title = @"引导提示动画";
    [self ls_setBackBtn];
}

#pragma mark - lazyLoad

- (QDJumpingAnimateView *)jumpingAnimateView {
    
    if (!_jumpingAnimateView) {
        
        _jumpingAnimateView = [[QDJumpingAnimateView alloc] initWithViewModel:self.jumpingnimatedViewModel];
    }
    
    return _jumpingAnimateView;
}

- (QDJumpingAnimateViewModel *)jumpingnimatedViewModel {
    
    if (!_jumpingnimatedViewModel) {
        
        _jumpingnimatedViewModel = [[QDJumpingAnimateViewModel alloc] init];
        _jumpingnimatedViewModel.allString = @"点击拍照，按住录视频";
        _jumpingnimatedViewModel.rangeStringArray = @[@"点击",@"按住"];
        _jumpingnimatedViewModel.offsetY = 80;
    }
    
    return _jumpingnimatedViewModel;
}

- (QDReadDestroyYinDaoView *)zHJumpingAnimatedView {
    
    if (!_zHJumpingAnimatedView) {
        
        _zHJumpingAnimatedView = [[QDReadDestroyYinDaoView alloc] initWithViewModel:self.zHJumpingAnimatedViewModel];
    }
    
    return _zHJumpingAnimatedView;
}

- (QDReadDestroyYinDaoViewModel *)zHJumpingAnimatedViewModel {
    
    if (!_zHJumpingAnimatedViewModel) {
        
        _zHJumpingAnimatedViewModel = [[QDReadDestroyYinDaoViewModel alloc] init];
    }
    
    return _zHJumpingAnimatedViewModel;
}

- (UIButton *)topBtn {

    if (!_topBtn) {
        
        _topBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _topBtn.backgroundColor = [UIColor redColor];
        [_topBtn setTitle:@"单个跳" forState:UIControlStateNormal];
    }
    
    return _topBtn;
}

- (UIButton *)bottomBtn {
    
    if (!_bottomBtn) {
        
        _bottomBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _bottomBtn.backgroundColor = [UIColor redColor];
        [_bottomBtn setTitle:@"组合跳" forState:UIControlStateNormal];
    }
    
    return _bottomBtn;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
