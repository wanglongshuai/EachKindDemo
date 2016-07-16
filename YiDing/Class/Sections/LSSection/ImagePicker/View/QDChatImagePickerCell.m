//
//  QDChatImagePickerCell.m
//  QuDianApp
//
//  Created by 王隆帅 on 16/6/24.
//  Copyright © 2016年 wangpengbo. All rights reserved.
//

#import "QDChatImagePickerCell.h"
@interface QDChatImagePickerCell ()

@property (nonatomic, strong) UIImageView *imageView;

@property (nonatomic, strong) UIImageView *kuangImageView;

@property (nonatomic, strong) UIImageView *selectedImageView;

@end
@implementation QDChatImagePickerCell

- (instancetype)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    if (self) {
        
        [self qd_setUpViews];
    }
    return self;
}

- (void)qd_setUpViews {

    [self.contentView addSubview:self.kuangImageView];
    [self.contentView addSubview:self.imageView];
    [self.contentView addSubview:self.selectedImageView];
    
    [self setNeedsUpdateConstraints];
    [self updateConstraintsIfNeeded];
}

- (void)updateConstraints {

    WS(weakSelf)
    
    if (self.selected) {
        
        [self.imageView mas_remakeConstraints:^(MASConstraintMaker *make) {
            
            make.edges.equalTo(UIEdgeInsetsMake(10, 10, 10, 10));
        }];
        self.selectedImageView.hidden = NO;
    } else {
    
        [self.imageView mas_remakeConstraints:^(MASConstraintMaker *make) {
            
            make.edges.equalTo(weakSelf.contentView);
        }];
        self.selectedImageView.hidden = YES;
    }
    
    [self.kuangImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.edges.equalTo(UIEdgeInsetsMake(5, 5, 5, 5));
    }];
    
    [self.selectedImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.bottom.right.equalTo(-25);
        make.size.equalTo(CGSizeMake(25, 25));
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
    
     @weakify(self);
    [[RACObserve(self, selected) takeUntil:self.rac_prepareForReuseSignal] subscribeNext:^(id x) {
        
        @strongify(self);
        [UIView animateWithDuration:0.5 animations:^{
            
            @strongify(self);
            [self setNeedsUpdateConstraints];
            [self updateConstraintsIfNeeded];
        }];
    }];
}

#pragma mark - lazyLoad
- (UIImageView *)imageView {

    if (!_imageView) {
        
        _imageView = [[UIImageView alloc] init];
        _imageView.contentMode = UIViewContentModeScaleAspectFill;
        [_imageView setClipsToBounds:YES];
    }
    
    return _imageView;
}

- (UIImageView *)kuangImageView {

    if (!_kuangImageView) {
        
        _kuangImageView = [[UIImageView alloc] init];
        _kuangImageView.image = [[UIImage imageNamed:@"global_thumbnail_frame_selected"] resizableImageWithCapInsets:UIEdgeInsetsMake(5, 5, 5, 5)];
    }
    
    return _kuangImageView;
}

- (UIImageView *)selectedImageView {

    if (!_selectedImageView) {
        
        _selectedImageView = [[UIImageView alloc] init];
        _selectedImageView.image = [UIImage imageNamed:@"chat_icon_photo_selected"];
        _selectedImageView.contentMode = UIViewContentModeScaleAspectFill;
        _selectedImageView.hidden = YES;
    }
    
    return _selectedImageView;
}

@end
