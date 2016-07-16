//
//  QDChatSelectedCollectionView.h
//  QuDianApp
//
//  Created by 王隆帅 on 16/6/28.
//  Copyright © 2016年 wangpengbo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "QDChatSelectedViewModel.h"

@interface QDChatSelectedCollectionView : UIView

- (instancetype)initWithViewModel:(QDChatSelectedViewModel *)viewModel;

/**
 *  去除所有的选择项
 */
- (void)qd_removeAllSelected;

@end
