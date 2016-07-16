//
//  QDJumpingAnimateView.h
//  QuDianApp
//
//  Created by 王隆帅 on 16/7/12.
//  Copyright © 2016年 wangpengbo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "QDJumpingAnimateViewModel.h"

typedef void(^Finish)();

@interface QDJumpingAnimateView : UIView

- (instancetype)initWithViewModel:(QDJumpingAnimateViewModel *)viewModel;

- (void)qd_startShowWithFinish:(Finish)finsh;

- (void)qd_disMiss:(Finish)finsh;

@property (nonatomic, copy) Finish animateFinish;

@property (nonatomic, copy) Finish disMissFinish;

@property (nonatomic, copy) Finish canJumpBlock;


// ******组合使用*****
- (void)zh_startShowWithFinish:(Finish)finsh;

- (void)zh_removeTap;

- (void)zh_disMiss:(Finish)finsh;

@end
