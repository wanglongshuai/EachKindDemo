//
//  QDReadDestroyYinDaoViewModel.m
//  QuDianApp
//
//  Created by 王隆帅 on 16/7/14.
//  Copyright © 2016年 wangpengbo. All rights reserved.
//

#import "QDReadDestroyYinDaoViewModel.h"
@interface QDReadDestroyYinDaoViewModel ()

@end

@implementation QDReadDestroyYinDaoViewModel

- (instancetype)init {
    
    self = [super init];
    
    if (self) {
        
        [self qd_bind];
    }
    
    return self;
}

#pragma mark - pricate

- (void)qd_bind {
    
    RAC(self, attributedStr) = [RACSignal combineLatest:@[[RACObserve(self, allString) filter:^BOOL(NSString *value) {
        
        return value.length > 0;
    }],[RACObserve(self, rangeStringArray) filter:^BOOL(NSArray *value) {
        
        return value.count > 0;
    }]] reduce:^id(NSString *str ,NSArray *rangeArray){
        
        NSMutableAttributedString *attributedStr = [[NSMutableAttributedString alloc] initWithString:str];
        [attributedStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:20.0f] range:NSMakeRange(0, attributedStr.string.length)];
        
        for (NSString *rangeStr in rangeArray) {
            
            NSRange range = [str rangeOfString:rangeStr options:NSBackwardsSearch];
            [attributedStr addAttribute:NSForegroundColorAttributeName value:UIColorFromRGBA(0xff1050, 1.0) range:range];
        }
        return attributedStr;
    }];
    
    self.allString = @"点击可添加说明文字!";
    self.rangeStringArray = @[@"点击可添加说明文字!"]; 
}

- (UIImage *)imageFromView:(UIView *)theView {
    
    UIGraphicsBeginImageContext(theView.frame.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    [theView.layer renderInContext:context];
    UIImage *theImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return theImage;
}

#pragma mark - lazyLoad

- (NSArray *)rangeStringArray {
    
    if (!_rangeStringArray) {
        
        _rangeStringArray = [NSArray array];
    }
    
    return _rangeStringArray;
}

- (QDJumpingAnimateViewModel *)topAnimatedViewModel {

    if (!_topAnimatedViewModel) {
        
        _topAnimatedViewModel = [[QDJumpingAnimateViewModel alloc] init];
        _topAnimatedViewModel.allString = @"点这里,可以设置自毁时间";
        _topAnimatedViewModel.rangeStringArray = @[@"点这里"];
        _topAnimatedViewModel.offsetY = 15;
        _topAnimatedViewModel.whiteLeftEdge = 10;
        _topAnimatedViewModel.whiteRightEdge = 50;
    }
    
    return _topAnimatedViewModel;
}

- (QDJumpingAnimateViewModel *)bottomAnimatedViewModel {
    
    if (!_bottomAnimatedViewModel) {
        
        _bottomAnimatedViewModel = [[QDJumpingAnimateViewModel alloc] init];
        _bottomAnimatedViewModel.allString = @"点这里,可保存到手机里";
        _bottomAnimatedViewModel.rangeStringArray = @[@"点这里"];
        _bottomAnimatedViewModel.offsetY = -30;
        _bottomAnimatedViewModel.selfOffSetY = SCREEN_HEIGHT - (SCREEN_HEIGHT - 100)/2.0;
        _bottomAnimatedViewModel.whiteLeftEdge = 50;
        _bottomAnimatedViewModel.whiteRightEdge = 10;
    }
    
    return _bottomAnimatedViewModel;
}

@end
