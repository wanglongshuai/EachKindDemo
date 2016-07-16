//
//  LSAttributedViewModel.m
//  YiDing
//
//  Created by 王隆帅 on 16/7/14.
//  Copyright © 2016年 王隆帅. All rights reserved.
//

#import "LSAttributedViewModel.h"
#import <CoreText/CoreText.h>

@interface LSAttributedViewModel ()

@property (nonatomic, strong, readwrite) NSMutableAttributedString *changeColorString;

@property (nonatomic, strong, readwrite) NSMutableAttributedString *changeSpaceString;

@property (nonatomic, strong, readwrite) NSMutableAttributedString *changeLineSpaceString;

@property (nonatomic, strong, readwrite) NSMutableAttributedString *changeFontColorString;

@end
@implementation LSAttributedViewModel

- (void)yd_initialize {

    // *******单纯改变某几个字 颜色********
    
    NSString *total1 = @"单纯改变颜色,不做其他设置";
    NSArray *subArray1 = @[@"单纯",@"其他"];
    
    self.changeColorString = [self ls_changeCorlorWithColor:[UIColor redColor] TotalString:total1 SubStringArray:subArray1];
    
    // *******单纯改变字间距*********
    
    NSString *total2 = @"单纯改变字间距,此时为10";
    self.changeSpaceString = [self ls_changeSpaceWithTotalString:total2 Space:10.0];
    
    // *******单纯改行间距********
    
    NSString *total3 = @"单纯改变行间距，此时行间距为10。单纯改变行间距，此时行间距为10。单纯改变行间距，此时行间距为10。单纯改变行间距，此时行间距为10。单纯改变行间距，此时行间距为10。";
    self.changeLineSpaceString = [self ls_changeLineSpaceWithTotalString:total3 LineSpace:10.0];
    
    // ******改变某些文字的颜色,并单独设置其字体*****
    
    NSString *total4 = @"改变某些文字的颜色,并单独设置其字体";
    self.changeFontColorString = [self ls_changeFontAndColor:[UIFont boldSystemFontOfSize:20] Color:[UIColor redColor] TotalString:total4 SubStringArray:@[@"某些",@"设置"]];
}

#pragma mark - 封装的API

/**
 *  单纯改变一句话中的某些字的颜色（一种颜色）
 *
 *  @param color    需要改变成的颜色
 *  @param totalStr 总的字符串
 *  @param subArray 需要改变颜色的文字数组(要是有相同的 只取第一个)
 *
 *  @return 生成的富文本
 */
- (NSMutableAttributedString *)ls_changeCorlorWithColor:(UIColor *)color TotalString:(NSString *)totalStr SubStringArray:(NSArray *)subArray {

    NSMutableAttributedString *attributedStr = [[NSMutableAttributedString alloc] initWithString:totalStr];
    for (NSString *rangeStr in subArray) {
        
        NSRange range = [totalStr rangeOfString:rangeStr options:NSBackwardsSearch];
        [attributedStr addAttribute:NSForegroundColorAttributeName value:color range:range];
    }
    
    return attributedStr;
}

/**
 *  单纯改变句子的字间距（需要 <CoreText/CoreText.h>）
 *
 *  @param totalString 需要更改的字符串
 *  @param space       字间距
 *
 *  @return 生成的富文本
 */
- (NSMutableAttributedString *)ls_changeSpaceWithTotalString:(NSString *)totalString Space:(CGFloat)space {

    NSMutableAttributedString *attributedStr = [[NSMutableAttributedString alloc] initWithString:totalString];
    long number = space;
    CFNumberRef num = CFNumberCreate(kCFAllocatorDefault,kCFNumberSInt8Type,&number);
    [attributedStr addAttribute:(id)kCTKernAttributeName value:(__bridge id)num range:NSMakeRange(0,[attributedStr length])];
    CFRelease(num);
    
    return attributedStr;
}

/**
 *  单纯改变段落的行间距
 *
 *  @param totalString 需要更改的字符串
 *  @param lineSpace   行间距
 *
 *  @return 生成的富文本
 */
- (NSMutableAttributedString *)ls_changeLineSpaceWithTotalString:(NSString *)totalString LineSpace:(CGFloat)lineSpace {

    NSMutableAttributedString *attributedStr = [[NSMutableAttributedString alloc] initWithString:totalString];
    
    NSMutableParagraphStyle * paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle setLineSpacing:4.0];
    
    [attributedStr addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [totalString length])];

    return attributedStr;
}

/**
 *  改变某些文字的颜色 并单独设置其字体
 *
 *  @param font        设置的字体
 *  @param color       颜色
 *  @param totalString 总的字符串
 *  @param subArray    想要变色的字符数组
 *
 *  @return 生成的富文本
 */
- (NSMutableAttributedString *)ls_changeFontAndColor:(UIFont *)font Color:(UIColor *)color TotalString:(NSString *)totalString SubStringArray:(NSArray *)subArray {

    NSMutableAttributedString *attributedStr = [[NSMutableAttributedString alloc] initWithString:totalString];
    
    for (NSString *rangeStr in subArray) {
        
        NSRange range = [totalString rangeOfString:rangeStr options:NSBackwardsSearch];
        
        [attributedStr addAttribute:NSForegroundColorAttributeName value:color range:range];
        [attributedStr addAttribute:NSFontAttributeName value:font range:range];
    }
    
    return attributedStr;
}

@end
