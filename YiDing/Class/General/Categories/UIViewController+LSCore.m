//
//  UIViewController+LSCore.m
//  LSCoreFramework
//
//  Created by 王隆帅 on 15/5/14.
//  Copyright (c) 2015年 王隆帅. All rights reserved.
//

#import "UIViewController+LSCore.h"


@implementation UIViewController (LSCore)

- (void)ls_setBackBtn {

    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(0, 0, 44, 44);
    button.imageEdgeInsets = UIEdgeInsetsMake(0, -20, 0, 0);
    [button setImage:V_IMAGE(@"global_btn_top_return_w") forState:UIControlStateNormal];
    [button setImage:V_IMAGE(@"global_btn_top_return_w_press") forState:UIControlStateHighlighted];
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:button];
    
     @weakify(self);
    [[button rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        
        @strongify(self);
        
        if (self.presentingViewController) {
            
            [self dismissViewControllerAnimated:YES completion:nil];
        }
        
        if (self.navigationController) {
            
            [self.navigationController popViewControllerAnimated:YES];
        }
    }];
    
}

@end
