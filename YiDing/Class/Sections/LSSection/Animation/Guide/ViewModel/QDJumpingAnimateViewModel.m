//
//  QDJumpingAnimateViewModel.m
//  QuDianApp
//
//  Created by 王隆帅 on 16/7/13.
//  Copyright © 2016年 wangpengbo. All rights reserved.
//

#import "QDJumpingAnimateViewModel.h"
@interface QDJumpingAnimateViewModel ()

@property (nonatomic, strong, readwrite) UIImage *jumpNeedImage;

@property (nonatomic, assign, readwrite) CGRect jumpFrame;

@end
@implementation QDJumpingAnimateViewModel

- (instancetype)init {

    self = [super init];
    
    if (self) {
        
        self.whiteLeftEdge = 0.0;
        self.whiteRightEdge = 0.0;
        self.selfOffSetY = 0.0;
        [self qd_bind];
    }
    
    return self;
}

#pragma mark - pricate

- (void)qd_bind {
    
     @weakify(self);
    [[RACObserve(self, jumpView) distinctUntilChanged] subscribeNext:^(UIView *view) {
       
        @strongify(self);
        self.jumpNeedImage = [view screenshot];
        
        UIWindow * window=[[[UIApplication sharedApplication] delegate] window];
        CGRect frame =[view convertRect:view.bounds toView:window];
        
        frame.origin.y -= self.selfOffSetY;
        self.jumpFrame = frame;
        [self.refreshSubject sendNext:nil];
    }];
    
    RAC(self, attributedStr) = [RACSignal combineLatest:@[[RACObserve(self, allString) filter:^BOOL(NSString *value) {
        
        return value.length > 0;
    }],[RACObserve(self, rangeStringArray) filter:^BOOL(NSArray *value) {
        
        return value.count > 0;
    }]] reduce:^id(NSString *str ,NSArray *rangeArray){
        
        NSMutableAttributedString *attributedStr = [[NSMutableAttributedString alloc] initWithString:str];
        [attributedStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:20.0f] range:NSMakeRange(0, attributedStr.string.length)];
        
        for (NSString *rangeStr in rangeArray) {
            
            NSRange range = [str rangeOfString:rangeStr options:NSBackwardsSearch];
            [attributedStr addAttribute:NSForegroundColorAttributeName value:UIColorFromRGB(0xff1050) range:range];
        }
        return attributedStr;
    }];
}

//- (UIImage *)imageFromView:(UIView *)theView {
//    
//    UIGraphicsBeginImageContext(theView.frame.size);
//    CGContextRef context = UIGraphicsGetCurrentContext();
//    [theView.layer renderInContext:context];
//    UIImage *theImage = UIGraphicsGetImageFromCurrentImageContext();
//    UIGraphicsEndImageContext();
//    
//    return theImage;
//}

#pragma mark - lazyLoad

- (UIView *)jumpView {

    if (!_jumpView) {
        
        _jumpView = [[UIView alloc] init];
    }
    
    return _jumpView;
}

- (UIImage *)jumpNeedImage {

    if (!_jumpNeedImage) {
        
        _jumpNeedImage = [[UIImage alloc] init];
    }
    
    return _jumpNeedImage;
}

- (RACSubject *)refreshSubject {

    if (!_refreshSubject) {
        
        _refreshSubject = [RACSubject subject];
    }
    
    return _refreshSubject;
}

- (NSArray *)rangeStringArray {

    if (!_rangeStringArray) {
        
        _rangeStringArray = [NSArray array];
    }
    
    return _rangeStringArray;
}

@end
