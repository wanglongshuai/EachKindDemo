//
//  LSAttributedViewModel.h
//  YiDing
//
//  Created by 王隆帅 on 16/7/14.
//  Copyright © 2016年 王隆帅. All rights reserved.
//

#import "YDViewModel.h"

@interface LSAttributedViewModel : YDViewModel

@property (nonatomic, strong, readonly) NSMutableAttributedString *changeColorString;

@property (nonatomic, strong, readonly) NSMutableAttributedString *changeSpaceString;

@property (nonatomic, strong, readonly) NSMutableAttributedString *changeLineSpaceString;
@property (nonatomic, strong, readonly) NSMutableAttributedString *changeFontColorString;


@end
