//
//  LSHomePageViewModel.m
//  YiDing
//
//  Created by 王隆帅 on 16/7/13.
//  Copyright © 2016年 王隆帅. All rights reserved.
//

#import "LSHomePageViewModel.h"
#import "LSHomePageCellViewModel.h"

@interface LSHomePageViewModel ()

@property (nonatomic, strong, readwrite) NSArray *dataArray;

@end
@implementation LSHomePageViewModel

- (void)yd_initialize {

    NSArray *array = [NSArray arrayWithContentsOfFile:[NSString stringWithFormat:@"%@/homePage.plist",[[NSBundle mainBundle] resourcePath]]];
    self.dataArray = [[array.rac_sequence map:^id(NSDictionary *dict) {
        
        LSHomePageCellViewModel *cellViewModel = [[LSHomePageCellViewModel alloc] init];
        cellViewModel.title = dict[@"title"];
        cellViewModel.content = dict[@"content"];
        cellViewModel.img = dict[@"img"];
        cellViewModel.viewController = dict[@"viewController"];
        
        return cellViewModel;
    }] array];
}

- (NSArray *)dataArray {

    if (!_dataArray) {
        
        _dataArray = [NSArray array];
    }
    
    return _dataArray;
}

- (RACSubject *)cellClickSubject {

    if (!_cellClickSubject) {
        
        _cellClickSubject = [RACSubject subject];
    }
    
    return _cellClickSubject;
}

@end
