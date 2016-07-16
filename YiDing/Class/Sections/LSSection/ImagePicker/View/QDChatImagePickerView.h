//
//  QDChatImagePickerView.h
//  QuDianApp
//
//  Created by 王隆帅 on 16/6/24.
//  Copyright © 2016年 wangpengbo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "QDChatImagePickerViewModel.h"

@interface QDChatImagePickerView : UIView

/**
 *  使用 ViewModel初始化
 *
 *  @param viewModel 初始化 所需ViewModel
 *
 *  @return 一个实例
 */
- (instancetype)initWithViewModel:(QDChatImagePickerViewModel *)viewModel;

/**
 *  去除所有的选择项
 */
- (void)qd_removeAllSelected;

@end
