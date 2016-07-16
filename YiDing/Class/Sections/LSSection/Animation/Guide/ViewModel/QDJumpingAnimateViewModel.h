//
//  QDJumpingAnimateViewModel.h
//  QuDianApp
//
//  Created by 王隆帅 on 16/7/13.
//  Copyright © 2016年 wangpengbo. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface QDJumpingAnimateViewModel : NSObject

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


// **********组合使用********
/**
 *  白色底色 距离左右的间隔 不为0的时候 为圆角 默认都是0
 */
@property (nonatomic, assign) CGFloat whiteLeftEdge;
/**
 *  白色底色 距离左右的间隔 不为0的时候 为圆角 默认都是0
 */
@property (nonatomic, assign) CGFloat whiteRightEdge;
/**
 *  组合view相对于顶部的偏移量 默认都是0
 */
@property (nonatomic, assign) CGFloat selfOffSetY;

// ***********内部使用**********
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
