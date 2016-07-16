//
//  LSHomePageViewModel.h
//  YiDing
//
//  Created by 王隆帅 on 16/7/13.
//  Copyright © 2016年 王隆帅. All rights reserved.
//

#import "YDViewModel.h"

@interface LSHomePageViewModel : YDViewModel

@property (nonatomic, strong, readonly) NSArray *dataArray;

@property (nonatomic, strong) RACSubject *cellClickSubject;

@end
