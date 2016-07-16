//
//  LSCoreToolCenter.m
//  LSCoreFramework
//
//  Created by 王隆帅 on 15/5/14.
//  Copyright (c) 2015年 王隆帅. All rights reserved.
//

#import "LSCoreToolCenter.h"

#import <SDWebImageManager.h>
#import <SDWebImageCompat.h>
#import <SVProgressHUD.h>
#import <AVFoundation/AVFoundation.h>
#import <CoreText/CoreText.h>

@implementation LSCoreToolCenter

+ (void)load{
   
    [SVProgressHUD setBackgroundColor:RGBACOLOR(0, 0, 0, 0.8)];
    [SVProgressHUD setForegroundColor:[UIColor whiteColor]];
    [SVProgressHUD setInfoImage:nil];
}

void ShowSuccessStatus(NSString *statues){
    if (![NSThread isMainThread]) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [SVProgressHUD showSuccessWithStatus:statues];
        });
    }else{
        [SVProgressHUD showSuccessWithStatus:statues];
    }
}


void ShowMessage(NSString *statues){
    if (![NSThread isMainThread]) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [SVProgressHUD showInfoWithStatus:statues];
        });
    }else{
        [SVProgressHUD showInfoWithStatus:statues];
    }
}

void ShowErrorStatus(NSString *statues){
    if (![NSThread isMainThread]) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [SVProgressHUD showErrorWithStatus:statues];
            [SVProgressHUD showProgress:0.5 status:@"上传" maskType:SVProgressHUDMaskTypeGradient];
        });
    }else{
        [SVProgressHUD showErrorWithStatus:statues];
    }
}


void ShowMaskStatus(NSString *statues){
    if (![NSThread isMainThread]) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [SVProgressHUD showWithStatus:statues maskType:SVProgressHUDMaskTypeGradient];
        });
    }else{
        [SVProgressHUD showWithStatus:statues maskType:SVProgressHUDMaskTypeGradient];
    }
}

void ShowProgress(CGFloat progress){
    if (![NSThread isMainThread]) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [SVProgressHUD showProgress:progress maskType:SVProgressHUDMaskTypeGradient];
        });
    }else{
        [SVProgressHUD showProgress:progress maskType:SVProgressHUDMaskTypeGradient];
    }
}

void DismissHud(void){
    if (![NSThread isMainThread]) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [SVProgressHUD dismiss];
        });
    }else{
        [SVProgressHUD dismiss];
    }
}


#pragma mark - 富文本操作

/**
 *  单纯改变一句话中的某些字的颜色（一种颜色）
 *
 *  @param color    需要改变成的颜色
 *  @param totalStr 总的字符串
 *  @param subArray 需要改变颜色的文字数组(要是有相同的 只取第一个)
 *
 *  @return 生成的富文本
 */
+ (NSMutableAttributedString *)ls_changeCorlorWithColor:(UIColor *)color TotalString:(NSString *)totalStr SubStringArray:(NSArray *)subArray {
    
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
+ (NSMutableAttributedString *)ls_changeSpaceWithTotalString:(NSString *)totalString Space:(CGFloat)space {
    
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
+ (NSMutableAttributedString *)ls_changeLineSpaceWithTotalString:(NSString *)totalString LineSpace:(CGFloat)lineSpace {
    
    NSMutableAttributedString *attributedStr = [[NSMutableAttributedString alloc] initWithString:totalString];
    
    NSMutableParagraphStyle * paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle setLineSpacing:lineSpace];
    
    [attributedStr addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [totalString length])];
    
    return attributedStr;
}

/**
 *  同时更改行间距和字间距
 *
 *  @param totalString 需要改变的字符串
 *  @param lineSpace   行间距
 *  @param textSpace   字间距
 *
 *  @return 生成的富文本
 */
+ (NSMutableAttributedString *)ls_changeLineAndTextSpaceWithTotalString:(NSString *)totalString LineSpace:(CGFloat)lineSpace textSpace:(CGFloat)textSpace {
    
    NSMutableAttributedString *attributedStr = [[NSMutableAttributedString alloc] initWithString:totalString];
    
    NSMutableParagraphStyle * paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle setLineSpacing:lineSpace];
    
    [attributedStr addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [totalString length])];
    
    long number = textSpace;
    CFNumberRef num = CFNumberCreate(kCFAllocatorDefault,kCFNumberSInt8Type,&number);
    [attributedStr addAttribute:(id)kCTKernAttributeName value:(__bridge id)num range:NSMakeRange(0,[attributedStr length])];
    CFRelease(num);
    
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
+ (NSMutableAttributedString *)ls_changeFontAndColor:(UIFont *)font Color:(UIColor *)color TotalString:(NSString *)totalString SubStringArray:(NSArray *)subArray {
    
    NSMutableAttributedString *attributedStr = [[NSMutableAttributedString alloc] initWithString:totalString];
    
    for (NSString *rangeStr in subArray) {
        
        NSRange range = [totalString rangeOfString:rangeStr options:NSBackwardsSearch];
        
        [attributedStr addAttribute:NSForegroundColorAttributeName value:color range:range];
        [attributedStr addAttribute:NSFontAttributeName value:font range:range];
    }
    
    return attributedStr;
}

/**
 *  为某些文字改为链接形式
 *
 *  @param totalString 总的字符串
 *  @param subArray    需要改变颜色的文字数组(要是有相同的 只取第一个)
 *
 *  @return 生成的富文本
 */
+ (NSMutableAttributedString *)ls_addLinkWithTotalString:(NSString *)totalString SubStringArray:(NSArray *)subArray {
    
    NSMutableAttributedString *attributedStr = [[NSMutableAttributedString alloc] initWithString:totalString];
    
    for (NSString *rangeStr in subArray) {
        
        NSRange range = [totalString rangeOfString:rangeStr options:NSBackwardsSearch];
        [attributedStr addAttribute:NSLinkAttributeName value:totalString range:range];
    }
    
    return attributedStr;
}

@end
