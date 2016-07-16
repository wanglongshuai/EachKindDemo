//
//  QDReadDestroyYinDaoView.m
//  QuDianApp
//
//  Created by 王隆帅 on 16/7/14.
//  Copyright © 2016年 wangpengbo. All rights reserved.
//

#import "QDReadDestroyYinDaoView.h"
#import "QDJumpingAnimateView.h"
#import "QDJumpingAnimateViewModel.h"

@interface QDReadDestroyYinDaoView ()

@property (nonatomic, strong) QDJumpingAnimateView *topAnimatedView;

@property (nonatomic, strong) QDJumpingAnimateView *bottomAnimatedView;

@property (nonatomic, strong) QDReadDestroyYinDaoViewModel *viewModel;

@property (nonatomic, strong) UIView *blackBgView;

@property (nonatomic, strong) UIView *whiteBgView;

@property (nonatomic, strong) UILabel *textLabel;

@property (nonatomic, strong) UITapGestureRecognizer *tap;


@property (nonatomic, strong) RACSignal *whiteAnimatedSignal;

@property (nonatomic, strong) RACSignal *textAnimatedSignal;

@property (nonatomic, strong) RACSignal *triangleAnimatedSignal;

@property (nonatomic, strong) RACSignal *textAndTriangleSignal;

@property (nonatomic, strong) RACDisposable *animateDispose;

@end
@implementation QDReadDestroyYinDaoView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (instancetype)initWithViewModel:(QDReadDestroyYinDaoViewModel *)viewModel {
    
    self = [super init];
    if (self) {
        
        self.viewModel = viewModel;
        [self qd_setupViews];
        [self qd_bindViewModel];
    }
    return self;
}

- (void)qd_setupViews {
    
    [self addSubview:self.blackBgView];
    [self addSubview:self.topAnimatedView];
    [self addSubview:self.bottomAnimatedView];
    [self addSubview:self.whiteBgView];
    [self addSubview:self.textLabel];
    [self addGestureRecognizer:self.tap];
    [self setNeedsUpdateConstraints];
    [self updateConstraintsIfNeeded];
}

- (void)updateConstraints {
    
    WS(weakSelf)
    
    [self.blackBgView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(weakSelf.topAnimatedView.mas_bottom);
        make.bottom.equalTo(weakSelf.bottomAnimatedView.mas_top);
        make.left.right.equalTo(weakSelf);
    }];
    
    [self.topAnimatedView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.top.right.equalTo(weakSelf);
        make.height.equalTo((SCREEN_HEIGHT - 100)/2.0);
    }];
    
    [self.bottomAnimatedView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.right.bottom.equalTo(weakSelf);
        make.height.equalTo((SCREEN_HEIGHT - 100)/2.0);
    }];
    
    [self.whiteBgView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo((SCREEN_HEIGHT - 65)/2.0 + 17.0);
        make.left.right.equalTo(weakSelf);
        make.height.equalTo(65);
    }];

    [self.textLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.right.equalTo(weakSelf.whiteBgView);
        make.height.equalTo(20);
        make.bottom.equalTo(weakSelf.whiteBgView.mas_bottom).offset(-19);
    }];

    
    [super updateConstraints];
}

#pragma mark - private

- (void)qd_bindViewModel {
    
    @weakify(self);

    RAC(self.textLabel, attributedText) = [[RACObserve(self, viewModel.attributedStr) distinctUntilChanged] filter:^BOOL(NSAttributedString *value) {
        
        return value.length > 0;
    }];
    
    [[self.tap.rac_gestureSignal takeUntil:self.rac_willDeallocSignal] subscribeNext:^(id x) {
        
        @strongify(self);
        [self qd_disMiss:^{
            
        }];
    }];
    
    self.topAnimatedView.canJumpBlock = ^(){
    
        @strongify(self);
        if (self.upCanJumpBlock) {
            
            self.upCanJumpBlock();
        }
    };
    
    self.bottomAnimatedView.canJumpBlock = ^() {
    
        @strongify(self);
        
        if (self.bottomCanJumpBlock) {
            
            self.bottomCanJumpBlock();
        }
    };
}

- (void)resetView {
    
    self.whiteBgView.alpha = 0.0;
    self.textLabel.alpha = 0.0;
    
    WS(weakSelf)
    
    [self.whiteBgView mas_remakeConstraints:^(MASConstraintMaker *make) {
        
        make.centerY.equalTo(17);
        make.left.right.equalTo(weakSelf);
        make.height.equalTo(65);
    }];
    
    [self.textLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        
        make.left.right.equalTo(weakSelf.whiteBgView);
        make.height.equalTo(20);
        make.bottom.equalTo(weakSelf.whiteBgView.mas_bottom).offset(-19);
    }];
}

#pragma mark - public

- (void)qd_startShowWithFinish:(Finish)finsh {
    
    if (![[UIApplication sharedApplication].keyWindow.subviews containsObject:self]) {
        
        [[UIApplication sharedApplication].keyWindow addSubview:self];
        
        [self mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.edges.equalTo([UIApplication sharedApplication].keyWindow);
        }];
        
        [self.topAnimatedView zh_startShowWithFinish:^{
            
            
        }];
        
        [self.bottomAnimatedView zh_startShowWithFinish:^{
            
        }];
       
        @weakify(self);
        self.animateDispose = [[self.whiteAnimatedSignal then:^RACSignal *{
            
            @strongify(self);
            return self.textAnimatedSignal;
        }] subscribeNext:^(id x) {
            
            @strongify(self);
            
            if (finsh) {
                
                double delayInSeconds = 1.f;
                dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
                
                dispatch_after(popTime, dispatch_get_main_queue(), ^{
                    
                    finsh();
                    
                });

            }
            
            if (self.animateFinish) {
                
                self.animateFinish();
            }
        }];
    }
}

- (void)qd_disMiss:(Finish)finsh {
    
    if ([[UIApplication sharedApplication].keyWindow.subviews containsObject:self]) {
        
        [self.topAnimatedView zh_disMiss:^{
            
        }];
        
        [self.bottomAnimatedView zh_disMiss:^{
            
        }];
        
        [self.animateDispose dispose];
        [self.layer removeAllAnimations];
        [self removeFromSuperview];
        [self resetView];
        
        if (self.disMissFinish) {
            
            self.disMissFinish();
        }
        
        if (finsh) {
            
            finsh();
        }
    }
}

#pragma mark - lazyLoad
- (QDReadDestroyYinDaoViewModel *)viewModel {

    if (!_viewModel) {
        
        _viewModel = [[QDReadDestroyYinDaoViewModel alloc] init];
    }
    
    return _viewModel;
}

- (UITapGestureRecognizer *)tap {
    
    if (!_tap) {
        
        _tap = [[UITapGestureRecognizer alloc] init];
        _tap.numberOfTapsRequired = 1;
        _tap.numberOfTouchesRequired = 1;
    }
    
    return _tap;
}

- (UIView *)blackBgView {
    
    if (!_blackBgView) {
        
        _blackBgView = [[UIView alloc] init];
        _blackBgView.backgroundColor = UIColorFromRGBA(0x000000, 0.6);
    }
    
    return _blackBgView;
}

- (UIView *)whiteBgView {
    
    if (!_whiteBgView) {
        
        _whiteBgView = [[UIView alloc] init];
        _whiteBgView.backgroundColor = [UIColor whiteColor];
        _whiteBgView.alpha = 0.0;
    }
    
    return _whiteBgView;
}

- (UILabel *)textLabel {
    
    if (!_textLabel) {
        
        _textLabel = [[UILabel alloc] init];
        _textLabel.font = [UIFont systemFontOfSize:20.0f];
        _textLabel.textColor = UIColorFromRGBA(0x333333, 1.0);
        _textLabel.textAlignment = NSTextAlignmentCenter;
        _textLabel.alpha = 0.0;
    }
    
    return _textLabel;
}

- (RACSignal *)whiteAnimatedSignal {
    
    
    if (!_whiteAnimatedSignal) {
        
        @weakify(self);
        _whiteAnimatedSignal = [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
            
            @strongify(self);
            [UIView animateWithDuration:12/50.0 animations:^{
                
                @strongify(self);
                self.whiteBgView.alpha = 1.0;
                self.whiteBgView.centerY -= 17.0;
                
            } completion:^(BOOL finished) {
                
                [subscriber sendNext:nil];
                [subscriber sendCompleted];
            }];
            
            return nil;
        }];
    }
    
    return _whiteAnimatedSignal;
}

- (RACSignal *)textAnimatedSignal {
    
    if (!_textAnimatedSignal) {
        
        @weakify(self);
        _textAnimatedSignal = [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
            
            @strongify(self);
            [UIView animateWithDuration:10/50.0 animations:^{
                
                @strongify(self);
                self.textLabel.alpha = 1.0;
                self.textLabel.centerY -= 3.5;
                
            } completion:^(BOOL finished) {
                
                [subscriber sendNext:nil];
                [subscriber sendCompleted];
            }];
            
            return nil;
        }];
    }
    
    return _textAnimatedSignal;
}

- (QDJumpingAnimateView *)topAnimatedView {

    if (!_topAnimatedView) {
        
        _topAnimatedView = [[QDJumpingAnimateView alloc] initWithViewModel:self.viewModel.topAnimatedViewModel];
        [_topAnimatedView zh_removeTap];
    }
    
    return _topAnimatedView;
}

- (QDJumpingAnimateView *)bottomAnimatedView {

    if (!_bottomAnimatedView) {
        
        _bottomAnimatedView = [[QDJumpingAnimateView alloc] initWithViewModel:self.viewModel.bottomAnimatedViewModel];
        [_bottomAnimatedView zh_removeTap];
    }
    
    return _bottomAnimatedView;
}

@end
