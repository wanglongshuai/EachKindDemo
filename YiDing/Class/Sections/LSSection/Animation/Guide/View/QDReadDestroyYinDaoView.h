//
//  QDReadDestroyYinDaoView.h
//  QuDianApp
//
//  Created by 王隆帅 on 16/7/14.
//  Copyright © 2016年 wangpengbo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "QDReadDestroyYinDaoViewModel.h"

typedef void(^Finish)();

@interface QDReadDestroyYinDaoView : UIView

- (instancetype)initWithViewModel:(QDReadDestroyYinDaoViewModel *)viewModel;

- (void)qd_startShowWithFinish:(Finish)finsh;

- (void)qd_disMiss:(Finish)finsh;

@property (nonatomic, copy) Finish animateFinish;

@property (nonatomic, copy) Finish disMissFinish;

@property (nonatomic, copy) Finish upCanJumpBlock;

@property (nonatomic, copy) Finish bottomCanJumpBlock;


@end
