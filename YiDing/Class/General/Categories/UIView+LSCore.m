//
//  UIView+LSCore.m
//  YiDing
//
//  Created by 王隆帅 on 16/7/16.
//  Copyright © 2016年 王隆帅. All rights reserved.
//

#import "UIView+LSCore.h"

@implementation UIView (LSCore)

#pragma mark - 坐标和位置
/**
 *  view的X
 *
 *  @return X值
 */
- (CGFloat)left {
    return self.frame.origin.x;
}

/**
 *  view的Y
 *
 *  @return Y值
 */
- (CGFloat)top {
    return self.frame.origin.y;
}

/**
 *  view右边缘横向位置
 *
 *  @return 右边缘横向位置
 */
- (CGFloat)right {
    return self.frame.origin.x + self.frame.size.width;
}

/**
 *  view下边缘垂直位置
 *
 *  @return 下边缘垂直位置
 */
- (CGFloat)bottom {
    return self.frame.origin.y + self.frame.size.height;
}

/**
 *  view的宽
 *
 *  @return view的宽
 */
- (CGFloat)width {
    return self.frame.size.width;
}

/**
 *  view的高
 *
 *  @return view的高
 */
- (CGFloat)height {
    return self.frame.size.height;
}

/**
 *  中心点X坐标
 *
 *  @return 中心点X坐标
 */
- (CGFloat)centerX {
    return self.center.x;
}

/**
 *  中心点Y坐标
 *
 *  @return 中心点Y坐标
 */
- (CGFloat)centerY {
    return self.center.y;
}

/**
 *  view的origin
 *
 *  @return view的origin
 */
- (CGPoint)origin {
    return self.frame.origin;
}

/**
 *  view的Size
 *
 *  @return view的size
 */
- (CGSize)size {
    return self.frame.size;
}

/**
 *  设置横坐标
 *
 *  @param originX 需要设置成的横坐标
 */
- (void)setLeft:(CGFloat)originX {
    CGRect frame = self.frame;
    frame.origin.x = originX;
    self.frame = frame;
    return;
}

/**
 *  设置纵坐标
 *
 *  @param originX 需要设置成的纵坐标
 */
- (void)setTop:(CGFloat)originY {
    CGRect frame = self.frame;
    frame.origin.y = originY;
    self.frame = frame;
    return;
}

/**
 *  设置右边缘的位置
 *
 *  @param rightX 设置后右边缘的坐标
 */
- (void)setRight:(CGFloat)rightX {
    CGRect frame = self.frame;
    frame.origin.x = rightX - [self width];
    self.frame = frame;
    return;
}

/**
 *  设置底部边缘的位置
 *
 *  @param bottomY 设置后底部边缘的坐标
 */
- (void)setBottom:(CGFloat)bottomY {
    CGRect frame = self.frame;
    frame.origin.y = bottomY - [self height];
    self.frame = frame;
    return;
}

/**
 *  设置横中心坐标的横坐标
 *
 *  @param originX 设置成的横坐标
 */
- (void)setCenterX:(CGFloat)centerX {
    self.center = CGPointMake(centerX, self.center.y);
    return;
}

/**
 *  设置中心坐标的纵坐标
 *
 *  @param originX 设置成的纵坐标
 */
- (void)setCenterY:(CGFloat)centerY {
    self.center = CGPointMake(self.center.x, centerY);
    return;
}

/**
 *  设置宽度
 *
 *  @param originX 需要设置成的宽度
 */
- (void)setWidth:(CGFloat)width {
    CGRect frame = self.frame;
    frame.size.width = width;
    self.frame = frame;
    return;
}

/**
 *  设置高
 *
 *  @param originX 需要设置成的高
 */
- (void)setHeight:(CGFloat)height {
    CGRect frame = self.frame;
    frame.size.height = height;
    self.frame = frame;
    return;
}

/**
 *  设置origin
 *
 *  @param originX 需要设置成的origin
 */
- (void)setOrigin:(CGPoint)origin {
    CGRect frame = self.frame;
    frame.origin = origin;
    self.frame = frame;
    return;
}

/**
 *  设置size
 *
 *  @param originX 需要设置成的size
 */
- (void)setSize:(CGSize)size {
    CGRect frame = self.frame;
    frame.size = size;
    self.frame = frame;
    return;
}

/**
 *  相对于window的横坐标
 *
 *  @return 相对于window的横坐标
 */
- (CGFloat)screenX {
    CGFloat x = 0;
    for (UIView* view =self; view; view = view.superview) {
        x += view.left;
    }
    return x;
}

/**
 *  相对于window的纵坐标
 *
 *  @return 相对于window的纵坐标
 */
- (CGFloat)screenY {
    CGFloat y = 0;
    for (UIView* view =self; view; view = view.superview) {
        y += view.top;
    }
    return y;
}

/**
 *  相对于最底部View的横坐标
 *
 *  @return 相对于最底部View的横坐标
 */
- (CGFloat)screenViewX {
    CGFloat x = 0;
    for (UIView* view =self; view; view = view.superview) {
        x += view.left;
        if ([view isKindOfClass:[UIScrollView class]]) {
            UIScrollView* scrollView = (UIScrollView*)view;
            x -= scrollView.contentOffset.x;
        }
    }
    return x;
}

/**
 *  相对于最底部view的纵坐标
 *
 *  @return 相对于最底部view的纵坐标
 */
- (CGFloat)screenViewY {
    CGFloat y = 0;
    for (UIView* view =self; view; view = view.superview) {
        y += view.top;
        if ([view isKindOfClass:[UIScrollView class]]) {
            UIScrollView* scrollView = (UIScrollView*)view;
            y -= scrollView.contentOffset.y;
        }
    }
    return y;
}

/**
 *  获取相对于window的位置
 *
 *  @return 得到的位置
 */
- (CGRect)screenFrame {
    return CGRectMake(self.screenViewX,self.screenViewY,self.width,self.height);
}

/**
 *  设置本view相对于其他View的偏移量
 *
 *  @param otherView 其他View
 *
 *  @return 相对的偏移量
 */
- (CGPoint)offsetFromView:(UIView*)otherView {
    CGFloat x = 0, y =0;
    for (UIView* view =self; view && view != otherView; view = view.superview) {
        x += view.left;
        y += view.top;
    }
    return CGPointMake(x, y);
}

/**
 *  截图
 *
 *  @return 获得图片
 */
- (UIImage *)screenshot {
    
    UIGraphicsBeginImageContextWithOptions(self.frame.size, NO, 2.0);
    [self.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

@end
