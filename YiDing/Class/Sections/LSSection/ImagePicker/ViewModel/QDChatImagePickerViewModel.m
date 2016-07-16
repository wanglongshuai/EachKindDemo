//
//  QDChatImagePickerViewModel.m
//  QuDianApp
//
//  Created by 王隆帅 on 16/6/24.
//  Copyright © 2016年 wangpengbo. All rights reserved.
//

#import "QDChatImagePickerViewModel.h"
#import "QDChatImagePickerCellViewModel.h"

@implementation QDChatImagePickerViewModel

- (instancetype)init {

    self = [super init];
    
    if (self) {
        
        self.selectedHeight = 372.0;
        [self qd_initialize];
    }
    
    return self;
}

- (void)qd_initialize {

     @weakify(self);
    
    dispatch_async(dispatch_get_main_queue(), ^{

        @strongify(self);
        [LSCoreToolCenter getSavedPhotoList:^(NSArray *photos) {
            
            @strongify(self);
            if (photos.count > 0) {
                
                NSMutableArray *mutabSizeArray = [NSMutableArray array];
                NSMutableArray *mutabRectArray = [NSMutableArray array];
                NSMutableArray *mutabImageArray = [NSMutableArray array];
                
                CGFloat paddingEdge = 3.0;
                CGFloat allOriginY = 0.0;
                
                NSInteger maxPhotoNum = 87;
                
                if (maxPhotoNum > photos.count) {
                    
                    maxPhotoNum = photos.count;
                }
                
                // 处理横屏
                
                NSMutableArray *selectedMuabSizeArray = [NSMutableArray array];
                NSMutableArray *selectedMuabRectArray = [NSMutableArray array];
                
                CGFloat allSelectedOriginX = 0.0;
                
                for (int i = 0; i < maxPhotoNum; i ++) {
                    
                    id asset = [photos objectAtIndex:i];
                    
                    CGSize size = [LSCoreToolCenter getSizeFromAsset:asset];
                    CGFloat pro = size.width/size.height;
                    
                    CGFloat width = self.selectedHeight * pro;
                    if (width > SCREEN_WIDTH - 40.0) {
                        
                        width = SCREEN_WIDTH - 40.0;
                    }
                    
                    CGSize selectedSize = CGSizeMake(width, self.selectedHeight);
                    CGPoint selectedPoint = CGPointMake(allSelectedOriginX, 0.0);
                    CGRect selectedRect = CGRectMake(selectedPoint.x, selectedPoint.y, selectedSize.width, selectedSize.height);
                    
                    [selectedMuabSizeArray addObject:[NSValue valueWithCGSize:selectedSize]];
                    [selectedMuabRectArray addObject:[NSValue valueWithCGRect:selectedRect]];
                    
                    allSelectedOriginX = allSelectedOriginX + selectedSize.width + paddingEdge;
                    
                }
                
                self.horizontalScroSize = CGSizeMake(allSelectedOriginX, self.selectedHeight);
                self.selectedSizeArray = [NSArray arrayWithArray:selectedMuabSizeArray];
                self.selectedRectArray = [NSArray arrayWithArray:selectedMuabRectArray];
                
                for (int i = 0; i < maxPhotoNum; i ++) {
                    
                    if (i % 2 == 1) {
                        
                        id assetLeft = [photos objectAtIndex:i - 1];
                        
                        CGSize sizeLeft = [LSCoreToolCenter getSizeFromAsset:assetLeft];
                        CGFloat proLeft = sizeLeft.height/sizeLeft.width;
                        
                        id assetRight = [photos objectAtIndex:i];
                        
                        CGSize sizeRight = [LSCoreToolCenter getSizeFromAsset:assetRight];
                        CGFloat proRight = sizeRight.height/sizeRight.width;
                        
                        CGFloat imageRightWidth = (SCREEN_WIDTH - paddingEdge) * proLeft / (proLeft + proRight);
                        CGFloat imageRightHeight = imageRightWidth * proRight;
                        
                        CGFloat imageLeftWidth = SCREEN_WIDTH - paddingEdge - imageRightWidth;
                        CGFloat imageLeftHeight = imageRightHeight;
                        
                        CGSize imageLeftSize = CGSizeMake(imageLeftWidth, imageLeftHeight);
                        CGSize imageRightSize = CGSizeMake(imageRightWidth, imageRightHeight);
                        
                        [mutabSizeArray addObject:[NSValue valueWithCGSize:imageLeftSize]];
                        [mutabSizeArray addObject:[NSValue valueWithCGSize:imageRightSize]];
                        
                        CGPoint imageLeftPoint = CGPointMake(0, allOriginY);
                        CGPoint imageRightPoint = CGPointMake(imageLeftSize.width + paddingEdge, allOriginY);
                        
                        allOriginY = allOriginY + imageLeftSize.height + paddingEdge;
                        
                        [mutabRectArray addObject:[NSValue valueWithCGRect:CGRectMake(imageLeftPoint.x, imageLeftPoint.y, imageLeftSize.width, imageLeftSize.height)]];
                        [mutabRectArray addObject:[NSValue valueWithCGRect:CGRectMake(imageRightPoint.x, imageRightPoint.y, imageRightSize.width, imageRightSize.height)]];
                        
                        QDChatImagePickerCellViewModel *cellViewModelLeft = [[QDChatImagePickerCellViewModel alloc] init];
                        cellViewModelLeft.image = [LSCoreToolCenter getThumImageFromAsset:assetLeft withSize:CGSizeMake(imageLeftWidth, imageLeftHeight)];
                        cellViewModelLeft.asset = assetLeft;
                        
                        QDChatImagePickerCellViewModel *cellViewModelRight = [[QDChatImagePickerCellViewModel alloc] init];
                        cellViewModelRight.image = [LSCoreToolCenter getThumImageFromAsset:assetRight withSize:CGSizeMake(imageRightWidth, imageRightHeight)];
                        cellViewModelRight.asset = assetRight;
                        
                        [mutabImageArray addObject:cellViewModelLeft];
                        [mutabImageArray addObject:cellViewModelRight];
                    }
                    
                    if ((i == maxPhotoNum - 1) && (i % 2 == 0)) {
                        
                        id asset = [photos objectAtIndex:i];
                        
                        CGSize sizeLast = [LSCoreToolCenter getSizeFromAsset:asset];
                        CGFloat proLast = sizeLast.height/sizeLast.width;
                        
                        CGFloat imageWidth = SCREEN_WIDTH;
                        CGFloat imageHeight = imageWidth * proLast;
                        
                        if (imageHeight > imageWidth * 3) {
                            
                            imageHeight = imageWidth * 3;
                        }
                        
                        [mutabSizeArray addObject:[NSValue valueWithCGSize:CGSizeMake(imageWidth, imageHeight)]];
                        
                        CGPoint imagePoint = CGPointMake(0, allOriginY);
                        allOriginY = allOriginY + imageHeight + paddingEdge;
                        
                        [mutabRectArray addObject:[NSValue valueWithCGRect:CGRectMake(imagePoint.x, imagePoint.y, imageWidth, imageHeight)]];
                        
                        QDChatImagePickerCellViewModel *cellViewModel = [[QDChatImagePickerCellViewModel alloc] init];
                        cellViewModel.image = [LSCoreToolCenter getThumImageFromAsset:asset withSize:CGSizeMake(imageWidth, imageHeight)];
                        cellViewModel.asset = asset;
                        [mutabImageArray addObject:cellViewModel];
                    }
                }
                
                self.verticalscroSize = CGSizeMake(SCREEN_WIDTH, allOriginY);
                self.sizeArray = [NSArray arrayWithArray:mutabSizeArray];
                self.rectArray = [NSArray arrayWithArray:mutabRectArray];
                self.dataArray = [NSArray arrayWithArray:mutabImageArray];
            }
            
        } error:^(NSError * error) {
            
        }];
        
    });

    
    [[RACObserve(self, dataArray) takeUntil:self.rac_willDeallocSignal] subscribeNext:^(id x) {
       
        @strongify(self);
        [self.refreshUISubject sendNext:nil];
    }];
    
    [[[RACObserve(self, selectedItemArray) distinctUntilChanged] takeUntil:self.rac_willDeallocSignal] subscribeNext:^(id x) {
        
        if (self.selectedItemArray.count > 0 ) {
            
            self.isSelected = YES;
            [self.changeStateSubject sendNext:@(YES)];
        } else {
            
            self.isSelected = NO;
            [self.changeStateSubject sendNext:@(NO)];
        }
        
    }];
}

#pragma mark - lazyLoad

- (NSArray *)dataArray {

    if (!_dataArray) {
        
        _dataArray = [NSArray array];
    }
    
    return _dataArray;
}

- (NSArray *)sizeArray {

    if (!_sizeArray) {
        
        _sizeArray = [NSArray array];
    }
    
    return _sizeArray;
}

- (NSArray *)rectArray {

    if (!_rectArray) {
        
        _rectArray = [NSArray array];
    }
    
    return _rectArray;
}

- (NSArray *)selectedSizeArray {

    if (!_selectedSizeArray) {
        
        _selectedSizeArray = [NSArray array];
    }
    
    return _selectedSizeArray;
}

- (NSArray *)selectedRectArray {

    if (!_selectedRectArray) {
        
        _selectedRectArray = [NSArray array];
    }
    
    return _selectedRectArray;
}

- (RACSubject *)refreshUISubject {

    if (!_refreshUISubject) {
        
        _refreshUISubject = [RACSubject subject];
    }
    
    return _refreshUISubject;
}

- (RACSubject *)changeStateSubject {

    if (!_changeStateSubject) {
        
        _changeStateSubject = [RACSubject subject];
    }
    
    return _changeStateSubject;
}

- (RACSubject *)finishSubject {

    if (!_finishSubject) {
        
        _finishSubject = [RACSubject subject];
    }
    
    return _finishSubject;
}

- (NSMutableArray *)selectedItemArray {

    if (!_selectedItemArray) {
        
        _selectedItemArray = [NSMutableArray array];
    }
    
    return _selectedItemArray;
}

@end
