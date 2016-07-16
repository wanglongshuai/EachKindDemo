//
//  QDChatSelectedViewModel.h
//  QuDianApp
//
//  Created by 王隆帅 on 16/6/28.
//  Copyright © 2016年 wangpengbo. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface QDChatSelectedViewModel : NSObject

@property (nonatomic, strong) NSArray *dataArray;

@property (nonatomic, strong) NSArray *sizeArray;

@property (nonatomic, strong) RACSubject *selectedSubject;

@property (nonatomic, strong) RACSubject *refreshUISubject;

@property (nonatomic, strong) RACSubject *addSubject;

@property (nonatomic, strong) RACSubject *deleteSubject;

@property (nonatomic, assign) CGFloat selectedHeight;

@property (nonatomic, strong) RACSubject *finishSubject;

@end
