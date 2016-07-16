//
//  QDChatImagePickerViewModel.h
//  QuDianApp
//
//  Created by 王隆帅 on 16/6/24.
//  Copyright © 2016年 wangpengbo. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface QDChatImagePickerViewModel : NSObject

@property (nonatomic, strong) NSArray *dataArray;

@property (nonatomic, strong) NSArray *sizeArray;

@property (nonatomic, strong) NSArray *rectArray;

@property (nonatomic, assign) CGSize verticalscroSize;


@property (nonatomic, strong) NSArray *selectedSizeArray;

@property (nonatomic, strong) NSArray *selectedRectArray;

@property (nonatomic, assign) CGSize horizontalScroSize;

@property (nonatomic, strong) NSMutableArray *selectedItemArray;


@property (nonatomic, strong) RACSubject *refreshUISubject;

@property (nonatomic, strong) RACSubject *changeStateSubject;

@property (nonatomic, strong) RACSubject *finishSubject;

@property (nonatomic, assign) BOOL isSelected;

@property (nonatomic, assign) CGFloat selectedHeight;

@end
