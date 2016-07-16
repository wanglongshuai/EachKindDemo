//
//  LSAttributedViewController.m
//  YiDing
//
//  Created by 王隆帅 on 16/7/14.
//  Copyright © 2016年 王隆帅. All rights reserved.
//

#import "LSAttributedViewController.h"
#import "LSAttributedViewModel.h"
#import "LSAttributeMainView.h"

@interface LSAttributedViewController ()

@property (nonatomic, strong) LSAttributedViewModel *viewModel;

@property (nonatomic, strong) LSAttributeMainView *mainView;
@end

@implementation LSAttributedViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - system
- (void)updateViewConstraints {
    
    WS(weakSelf)
    
    [self.mainView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.edges.equalTo(weakSelf.view);
    }];
    
    [super updateViewConstraints];
}

#pragma mark - private
- (void)yd_addSubviews {
    
    [self.view addSubview:self.mainView];
}

- (void)yd_bindViewModel {
    
}

- (void)yd_layoutNavigation {
    
    self.title = @"富文本";
    [self ls_setBackBtn];
}

#pragma mark - layzLoad
- (LSAttributeMainView *)mainView {
    
    if (!_mainView) {
        
        _mainView = [[LSAttributeMainView alloc] initWithViewModel:self.viewModel];
    }
    
    return _mainView;
}

- (LSAttributedViewModel *)viewModel {
    
    if (!_viewModel) {
        
        _viewModel = [[LSAttributedViewModel alloc] init];
    }
    
    return _viewModel;
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
