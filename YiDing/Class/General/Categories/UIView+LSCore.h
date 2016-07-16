//
//  UIView+LSCore.h
//  YiDing
//
//  Created by 王隆帅 on 16/7/16.
//  Copyright © 2016年 王隆帅. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (LSCore)

#pragma mark - 坐标和位置
@property (nonatomic) CGFloat left;
@property (nonatomic) CGFloat top;
@property (nonatomic) CGFloat right;
@property (nonatomic) CGFloat bottom;
@property (nonatomic) CGFloat width;
@property (nonatomic) CGFloat height;
@property (nonatomic) CGFloat centerX;
@property (nonatomic) CGFloat centerY;
@property (nonatomic) CGPoint origin;
@property (nonatomic) CGSize size;
@property (nonatomic) CGFloat screenX;
@property (nonatomic) CGFloat screenY;
@property (nonatomic) CGFloat screenViewX;
@property (nonatomic) CGFloat screenViewY;
@property (nonatomic) CGRect screenFrame;

- (CGPoint)offsetFromView:(UIView*)otherView;

- (void)setLeft:(CGFloat)originX;
- (void)setTop:(CGFloat)originY;
- (void)setRight:(CGFloat)rightX;
- (void)setBottom:(CGFloat)bottomY;
- (void)setCenterX:(CGFloat)centerX;
- (void)setCenterY:(CGFloat)centerY;
- (void)setWidth:(CGFloat)width;
- (void)setHeight:(CGFloat)height;
- (void)setOrigin:(CGPoint)origin;
- (void)setSize:(CGSize)size;

/**
 *  截图
 *
 *  @return 获得图片
 */
- (UIImage *)screenshot;

@end
