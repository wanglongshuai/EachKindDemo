//
//  LSImagePickerViewController.m
//  YiDing
//
//  Created by 王隆帅 on 16/7/16.
//  Copyright © 2016年 王隆帅. All rights reserved.
//

#import "LSImagePickerViewController.h"
#import "QDChatImagePickerView.h"
#import "QDChatImagePickerViewModel.h"

@interface LSImagePickerViewController ()

@property (nonatomic, strong) QDChatImagePickerView *pickerView;

@property (nonatomic, strong) QDChatImagePickerViewModel *pickerViewModel;

@property (nonatomic, strong) UIButton *resetBtn;

@end

@implementation LSImagePickerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor whiteColor];
}

#pragma mark - addChatPickerView

- (void)yd_addSubviews {

    [self.view addSubview:self.pickerView];
    [self.view addSubview:self.resetBtn];
    
    [self.view setNeedsUpdateConstraints];
    [self.view updateConstraintsIfNeeded];
}

- (void)updateViewConstraints {
   
    WS(weakSelf)
    
    [self.pickerView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.right.bottom.equalTo(weakSelf.view);
        make.height.equalTo(300);
    }];
    
    [self.resetBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.top.equalTo(30);
        make.size.equalTo(CGSizeMake(100, 100));
    }];
    
    [super updateViewConstraints];
}

- (void)yd_bindViewModel {

    [[[self.resetBtn rac_signalForControlEvents:UIControlEventTouchUpInside] takeUntil:self.rac_willDeallocSignal] subscribeNext:^(id x) {
        
        [self.pickerView qd_removeAllSelected];
    }];
    
    // 高度变化
    @weakify(self);
    [[self.pickerViewModel.changeStateSubject takeUntil:self.rac_willDeallocSignal] subscribeNext:^(id x) {
        
        @strongify(self);
        if (self.pickerViewModel.isSelected) {
            // 已经选择
            [self.pickerView mas_remakeConstraints:^(MASConstraintMaker *make) {
                @strongify(self);
                make.left.right.bottom.equalTo(self.view);
                make.height.equalTo(450);
            }];
        } else {
            // 没有选择
            [self.pickerView mas_remakeConstraints:^(MASConstraintMaker *make) {
                @strongify(self);
                make.left.right.bottom.equalTo(self.view);
                make.height.equalTo(300);
            }];
        }
    }];
    
    // 最终选择
    [[self.pickerViewModel.finishSubject takeUntil:self.rac_willDeallocSignal] subscribeNext:^(NSArray *dataArray) {
        
        NSLog(@"%@",dataArray);
    }];
    
}

- (void)yd_layoutNavigation {

    self.title = @"图片选择封装";
    [self ls_setBackBtn];
}

#pragma mark - lazyLoad

- (QDChatImagePickerView *)pickerView {
    
    if (!_pickerView) {
        
        _pickerView = [[QDChatImagePickerView alloc] initWithViewModel:self.pickerViewModel];
    }
    
    return _pickerView;
}

- (QDChatImagePickerViewModel *)pickerViewModel {
    
    if (!_pickerViewModel) {
        
        _pickerViewModel = [[QDChatImagePickerViewModel alloc] init];
    }
    
    return _pickerViewModel;
}

- (UIButton *)resetBtn {

    if (!_resetBtn) {
        
        _resetBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _resetBtn.backgroundColor = [UIColor redColor];
        [_resetBtn setTitle:@"Reset" forState:UIControlStateNormal];
    }
    
    return _resetBtn;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
