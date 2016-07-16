//
//  LSAttributedViewModel.m
//  YiDing
//
//  Created by 王隆帅 on 16/7/14.
//  Copyright © 2016年 王隆帅. All rights reserved.
//

#import "LSAttributedViewModel.h"

@interface LSAttributedViewModel ()

@property (nonatomic, strong, readwrite) NSMutableAttributedString *changeColorString;

@property (nonatomic, strong, readwrite) NSMutableAttributedString *changeSpaceString;

@property (nonatomic, strong, readwrite) NSMutableAttributedString *changeLineSpaceString;

@property (nonatomic, strong, readwrite) NSMutableAttributedString *changeFontColorString;

@property (nonatomic, strong, readwrite) NSMutableAttributedString *changeLineAndSpaceColorString;

@end
@implementation LSAttributedViewModel

- (void)yd_initialize {

    // *******单纯改变某几个字 颜色********
    
    NSString *total1 = @"单纯改变颜色,不做其他设置";
    NSArray *subArray1 = @[@"单纯",@"其他"];
    
    self.changeColorString = [LSCoreToolCenter ls_changeCorlorWithColor:[UIColor redColor] TotalString:total1 SubStringArray:subArray1];
    
    // *******单纯改变字间距*********
    
    NSString *total2 = @"单纯改变字间距,此时为10";
    self.changeSpaceString = [LSCoreToolCenter ls_changeSpaceWithTotalString:total2 Space:10.0];
    
    // *******单纯改行间距********
    
    NSString *total3 = @"单纯改变行间距，此时行间距为10。单纯改变行间距，此时行间距为10。单纯改变行间距，此时行间距为10。单纯改变行间距，此时行间距为10。单纯改变行间距，此时行间距为10。";
    self.changeLineSpaceString = [LSCoreToolCenter ls_changeLineSpaceWithTotalString:total3 LineSpace:10.0];
    
    // ******改变某些文字的颜色,并单独设置其字体*****
    
    NSString *total4 = @"改变某些文字的颜色,并单独设置其字体";
    self.changeFontColorString = [LSCoreToolCenter ls_changeFontAndColor:[UIFont boldSystemFontOfSize:20] Color:[UIColor redColor] TotalString:total4 SubStringArray:@[@"某些",@"设置"]];
    
    // *******同时改行间距和字间距********
    
    NSString *total5 = @"同时改行间距和字间距，此时行间距为10，字间距为5。同时改行间距和字间距，此时行间距为10，字间距为5。同时改行间距和字间距，此时行间距为10，字间距为5。";
    self.changeLineAndSpaceColorString = [LSCoreToolCenter ls_changeLineAndTextSpaceWithTotalString:total5 LineSpace:10.0 textSpace:5.0];
}


@end
