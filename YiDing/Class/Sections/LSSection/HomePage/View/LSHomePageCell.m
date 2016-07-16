//
//  LSHomePageCell.m
//  YiDing
//
//  Created by 王隆帅 on 16/7/13.
//  Copyright © 2016年 王隆帅. All rights reserved.
//

#import "LSHomePageCell.h"
@interface LSHomePageCell ()

@property (nonatomic, strong) UIImageView *mainImageView;

@property (nonatomic, strong) UILabel *titleLabel;

@property (nonatomic, strong) UILabel *contentLabel;

@property (nonatomic, strong) UIImageView *bottomLineImageView;

@end
@implementation LSHomePageCell

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/


#pragma mark - private
- (void)yd_setupViews {

    self.selectionStyle = UITableViewCellSelectionStyleDefault;

    [self.contentView addSubview:self.mainImageView];
    [self.contentView addSubview:self.titleLabel];
    [self.contentView addSubview:self.contentLabel];
    [self.contentView addSubview:self.bottomLineImageView];
    
    [self setNeedsUpdateConstraints];
    [self updateConstraintsIfNeeded];
}

- (void)yd_bindViewModel {

}

#pragma mark - system
- (void)updateConstraints {

    WS(weakSelf)
    
    [self.mainImageView mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.left.equalTo(7.5);
        make.size.equalTo(CGSizeMake(60, 60));
        make.centerY.equalTo(weakSelf.contentView);
    }];
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(weakSelf.mainImageView.mas_right).offset(10);
        make.top.equalTo(weakSelf.mainImageView);
        make.right.equalTo(-7.5);
        make.height.equalTo(20);
    }];
    
    [self.contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.right.equalTo(weakSelf.titleLabel);
        make.top.equalTo(weakSelf.titleLabel.mas_bottom).offset(7.5);
        make.height.equalTo(20);
    }];
    
    [self.bottomLineImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.right.bottom.equalTo(weakSelf.contentView);
        make.height.equalTo(1.0);
        make.left.equalTo(7.5);
    }];
    
    [super updateConstraints];
}

#pragma mark - updateData

- (void)setViewModel:(LSHomePageCellViewModel *)viewModel {

    if (!viewModel) {
        return;
    }
    
    _viewModel = viewModel;
    self.titleLabel.text = viewModel.title;
    self.contentLabel.text = viewModel.content;
    [self.mainImageView sd_setImageWithURL:URL(viewModel.img) placeholderImage:[UIImage imageNamed:@"defaultImage"]];
}

#pragma mark - lazyLoad
- (UIImageView *)mainImageView {

    if (!_mainImageView) {
        
        _mainImageView = [[UIImageView alloc] init];
        _mainImageView.layer.masksToBounds = YES;
        _mainImageView.layer.cornerRadius = 5.0;
    }
    
    return _mainImageView;
}

- (UILabel *)titleLabel {

    if (!_titleLabel) {
        
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.textColor = UIColorFromRGB(0x303030);
        _titleLabel.font = [UIFont systemFontOfSize:16];
    }
    
    return _titleLabel;
}

- (UILabel *)contentLabel {

    if (!_contentLabel) {
        
        _contentLabel = [[UILabel alloc] init];
        _contentLabel.textColor = RGBCOLOR(113, 112, 113);
        _contentLabel.font = [UIFont systemFontOfSize:13];
    }
    
    return _contentLabel;
}

- (UIImageView *)bottomLineImageView {

    if (!_bottomLineImageView) {
        
        _bottomLineImageView = [[UIImageView alloc] init];
        _bottomLineImageView.backgroundColor = RGBCOLOR(151, 151, 151);
    }
    
    return _bottomLineImageView;
}

@end
