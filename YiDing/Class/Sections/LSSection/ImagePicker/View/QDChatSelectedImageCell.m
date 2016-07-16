//
//  QDChatSelectedImageCell.m
//  QuDianApp
//
//  Created by 王隆帅 on 16/6/28.
//  Copyright © 2016年 wangpengbo. All rights reserved.
//

#import "QDChatSelectedImageCell.h"
@interface QDChatSelectedImageCell ()

@property (nonatomic, strong) UIImageView *imageView;

@end
@implementation QDChatSelectedImageCell


- (instancetype)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    if (self) {
        
        [self qd_setUpViews];
    }
    return self;
}

- (void)qd_setUpViews {
    
    [self.contentView addSubview:self.imageView];
    
    [self setNeedsUpdateConstraints];
    [self updateConstraintsIfNeeded];
}

- (void)updateConstraints {
    
    WS(weakSelf)
    
    [self.imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.edges.equalTo(weakSelf.contentView);
    }];
    
    [super updateConstraints];
}

#pragma mark - updateData

- (void)setViewModel:(QDChatImagePickerCellViewModel *)viewModel {
    
    if (!viewModel) {
        
        return;
    }
    
    _viewModel = viewModel;
    self.imageView.image = _viewModel.image;
}

#pragma mark - lazyLoad
- (UIImageView *)imageView {
    
    if (!_imageView) {
        
        _imageView = [[UIImageView alloc] init];
        _imageView.contentMode = UIViewContentModeScaleAspectFill;
        [_imageView setClipsToBounds:YES];
        _imageView.layer.masksToBounds = YES;
        _imageView.layer.cornerRadius = 5.0;
    }
    
    return _imageView;
}

@end
