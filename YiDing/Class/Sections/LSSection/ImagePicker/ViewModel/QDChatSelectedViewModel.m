//
//  QDChatSelectedViewModel.m
//  QuDianApp
//
//  Created by 王隆帅 on 16/6/28.
//  Copyright © 2016年 wangpengbo. All rights reserved.
//

#import "QDChatSelectedViewModel.h"
#import "QDChatImagePickerCellViewModel.h"
#import "RACReturnSignal.h"

@interface QDChatSelectedViewModel ()

@end
@implementation QDChatSelectedViewModel


- (instancetype)init {
    
    self = [super init];
    
    if (self) {
        
        self.selectedHeight = 70.0 - 20.0;
        [self qd_initialize];
    }
    
    return self;
}

- (void)qd_initialize {
    
}

- (NSArray *)dataArray {

    if (!_dataArray) {
        
        _dataArray = [NSArray array];
    }
    
    return _dataArray;
}

- (RACSubject *)selectedSubject {

    if (!_selectedSubject) {
        
        _selectedSubject = [RACSubject subject];
    }
    
    return _selectedSubject;
}

- (RACSubject *)refreshUISubject {

    if (!_refreshUISubject) {
        
        _refreshUISubject = [RACSubject subject];
    }
    
    return _refreshUISubject;
}

- (RACSubject *)addSubject {

    if (!_addSubject) {
        
        _addSubject = [RACSubject subject];
    }
    
    return _addSubject;
}

- (RACSubject *)deleteSubject {

    if (!_deleteSubject) {
        
        _deleteSubject  = [RACSubject subject];
    }
    
    return _deleteSubject;
}

- (RACSubject *)finishSubject {

    if (!_finishSubject) {
        
        _finishSubject = [RACSubject subject];
    }
    
    return _finishSubject;
}

@end
