//
//  LSHomePageViewModel.m
//  YiDing
//
//  Created by 王隆帅 on 16/7/13.
//  Copyright © 2016年 王隆帅. All rights reserved.
//

#import "LSHomePageViewModel.h"
@interface LSHomePageViewModel ()

@property (nonatomic, strong, readwrite) NSArray *dataArray;

@end
@implementation LSHomePageViewModel

- (void)yd_initialize {

    self.dataArray = @[@"",@"",@""];
}

- (NSArray *)dataArray {

    if (!_dataArray) {
        
        _dataArray = [NSArray array];
    }
    
    return _dataArray;
}

@end
