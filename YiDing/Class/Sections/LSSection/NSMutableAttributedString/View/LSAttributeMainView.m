//
//  LSAttributeMainView.m
//  YiDing
//
//  Created by 王隆帅 on 16/7/14.
//  Copyright © 2016年 王隆帅. All rights reserved.
//

#import "LSAttributeMainView.h"
#import "LSAttributedViewModel.h"

@interface LSAttributeMainView ()

@property (nonatomic, strong) LSAttributedViewModel *viewModel;

@property (nonatomic, strong) UILabel *changeColorLabel;

@property (nonatomic, strong) UILabel *changeSpaceLabel;

@property (nonatomic, strong) UILabel *changeLineSpaceLabel;

@property (nonatomic, strong) UILabel *changeFontColorLabel;

@end
@implementation LSAttributeMainView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (instancetype)initWithViewModel:(id<YDViewModelProtocol>)viewModel {

    self.viewModel = (LSAttributedViewModel *)viewModel;
    return [super initWithViewModel:viewModel];
}

- (void)yd_setupViews {

    [self addSubview:self.changeColorLabel];
    [self addSubview:self.changeSpaceLabel];
    [self addSubview:self.changeLineSpaceLabel];
    [self addSubview:self.changeFontColorLabel];
    
    [self setNeedsUpdateConstraints];
    [self updateConstraintsIfNeeded];
}

- (void)updateConstraints {

    WS(weakSelf)
    
    [self.changeColorLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.left.equalTo(@10);
        make.right.equalTo(@-10);
        make.height.equalTo(20);
    }];
    
    [self.changeSpaceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.right.equalTo(weakSelf.changeColorLabel);
        make.top.equalTo(weakSelf.changeColorLabel.mas_bottom).offset(10);
        make.height.equalTo(20);
    }];
    
    [self.changeLineSpaceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.right.equalTo(weakSelf.changeSpaceLabel);
        make.top.equalTo(weakSelf.changeSpaceLabel.mas_bottom).offset(10);
    }];
    
    [self.changeFontColorLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(weakSelf.changeLineSpaceLabel.mas_bottom).offset(10);
        make.left.right.equalTo(weakSelf.changeLineSpaceLabel);
        make.height.equalTo(20);
    }];
    
    [super updateConstraints];
}

- (void)yd_bindViewModel {

    RAC(self.changeColorLabel, attributedText) = RACObserve(self, viewModel.changeColorString);
    
    RAC(self.changeSpaceLabel, attributedText) = RACObserve(self, viewModel.changeSpaceString);
    
    RAC(self.changeLineSpaceLabel, attributedText) = RACObserve(self, viewModel.changeLineSpaceString);
    
    RAC(self.changeFontColorLabel, attributedText) = RACObserve(self, viewModel.changeFontColorString);
}

#pragma mark - lazyLoad
- (LSAttributedViewModel *)viewModel {

    if (!_viewModel) {
        
        _viewModel = [[LSAttributedViewModel alloc] init];
    }
    
    return _viewModel;
    
}

- (UILabel *)changeColorLabel {

    if (!_changeColorLabel) {
        
        _changeColorLabel = [[UILabel alloc] init];
        _changeColorLabel.textColor = UIColorFromRGB(0x303030);
        _changeColorLabel.font = [UIFont systemFontOfSize:16];
    }
    
    return _changeColorLabel;
}

- (UILabel *)changeSpaceLabel {
    
    if (!_changeSpaceLabel) {
        
        _changeSpaceLabel = [[UILabel alloc] init];
        _changeSpaceLabel.textColor = UIColorFromRGB(0x303030);
        _changeSpaceLabel.font = [UIFont systemFontOfSize:16];
    }
    
    return _changeSpaceLabel;
}

- (UILabel *)changeLineSpaceLabel {
    
    if (!_changeLineSpaceLabel) {
        
        _changeLineSpaceLabel = [[UILabel alloc] init];
        _changeLineSpaceLabel.textColor = UIColorFromRGB(0x303030);
        _changeLineSpaceLabel.font = [UIFont systemFontOfSize:16];
        _changeLineSpaceLabel.numberOfLines = 0;
        [_changeLineSpaceLabel sizeToFit];
    }
    
    return _changeLineSpaceLabel;
}

- (UILabel *)changeFontColorLabel {
    
    if (!_changeFontColorLabel) {
        
        _changeFontColorLabel = [[UILabel alloc] init];
        _changeFontColorLabel.textColor = UIColorFromRGB(0x303030);
        _changeFontColorLabel.font = [UIFont systemFontOfSize:16];
    }
    
    return _changeFontColorLabel;
}

@end
