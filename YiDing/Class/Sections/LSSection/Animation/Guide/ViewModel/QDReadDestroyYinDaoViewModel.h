//
//  QDReadDestroyYinDaoViewModel.h
//  QuDianApp
//
//  Created by 王隆帅 on 16/7/14.
//  Copyright © 2016年 wangpengbo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "QDJumpingAnimateViewModel.h"

@interface QDReadDestroyYinDaoViewModel : NSObject

@property (nonatomic, strong) QDJumpingAnimateViewModel *topAnimatedViewModel;

@property (nonatomic, strong) QDJumpingAnimateViewModel *bottomAnimatedViewModel;

/**
 *  需要的传入的view
 */
@property (nonatomic, strong) UIView *jumpView;
/**
 *  传入的全部文字
 */
@property (nonatomic, strong) NSString *allString;
/**
 *  传入的标红的文字数组
 */
@property (nonatomic, strong) NSArray *rangeStringArray;

/**
 *  相对于原View的 *间隔* 偏移量 + 为下 - 为上
 */
@property (nonatomic, assign) CGFloat offsetY;

/**
 *  得到的截图Image
 */
@property (nonatomic, strong, readonly) UIImage *jumpNeedImage;
/**
 *  得到的frame
 */
@property (nonatomic, assign, readonly) CGRect jumpFrame;
/**
 *  刷新UI
 */
@property (nonatomic, strong) RACSubject *refreshSubject;
/**
 *  得到的富文本
 */
@property (nonatomic, strong) NSMutableAttributedString *attributedStr;

@end
