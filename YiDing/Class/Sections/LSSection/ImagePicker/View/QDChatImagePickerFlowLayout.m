//
//  QDChatImagePickerFlowLayout.m
//  QuDianApp
//
//  Created by 王隆帅 on 16/6/27.
//  Copyright © 2016年 wangpengbo. All rights reserved.
//

#import "QDChatImagePickerFlowLayout.h"
@interface QDChatImagePickerFlowLayout ()

@property (nonatomic, strong) NSMutableArray *array;

@end
@implementation QDChatImagePickerFlowLayout

- (instancetype)init {
    
    self = [super init];
    
    if (self) {

        _array = [NSMutableArray array];
    }
    
    return self;
}

/**
 *  准备好布局时调用
 */
- (void)prepareLayout {
    
    [super prepareLayout];
    
    NSInteger count = [self.collectionView numberOfItemsInSection:0];
    
    //得到每个item的属性值进行存储
    [_array removeAllObjects];
    for (NSInteger i = 0 ; i < count; i ++) {
        
        NSIndexPath *indexPath = [NSIndexPath indexPathForItem:i inSection:0];
        [_array addObject:[self layoutAttributesForItemAtIndexPath:indexPath]];
    }
}

/**
 *  设置可滚动区域范围
 */
- (CGSize)collectionViewContentSize {
    
    return self.scroSize;
}

/**
 *  计算indexPath下item的属性的方法
 *
 *  @return item的属性
 */
- (UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    //通过indexPath创建一个item属性attr
    UICollectionViewLayoutAttributes *attr = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];
    if (self.rectArray.count > indexPath.row) {
        
        attr.frame = [self.rectArray[indexPath.row] CGRectValue];
    }
    return attr;
}

/**
 *  返回视图框内item的属性，可以直接返回所有item属性
 */
- (NSArray *)layoutAttributesForElementsInRect:(CGRect)rect {
   
    return _array;
}

- (NSArray *)rectArray {

    if (!_rectArray) {
        
        _rectArray = [NSArray array];
    }
    
    return _rectArray;
}

@end
