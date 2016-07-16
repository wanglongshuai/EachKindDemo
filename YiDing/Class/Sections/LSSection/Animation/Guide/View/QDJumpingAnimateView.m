//
//  QDJumpingAnimateView.m
//  QuDianApp
//
//  Created by 王隆帅 on 16/7/12.
//  Copyright © 2016年 wangpengbo. All rights reserved.
//

#import "QDJumpingAnimateView.h"

@interface QDJumpingAnimateView ()

@property (nonatomic, strong) QDJumpingAnimateViewModel *viewModel;

@property (nonatomic, strong) UIView *blackBgView;

@property (nonatomic, strong) UIView *whiteBgView;

@property (nonatomic, strong) UILabel *textLabel;

@property (nonatomic, strong) UIImageView *triangleImageView;

@property (nonatomic, strong) UIImageView *jumpImageView;

@property (nonatomic, strong) UITapGestureRecognizer *tap;


@property (nonatomic, strong) RACSignal *whiteAnimatedSignal;

@property (nonatomic, strong) RACSignal *textAnimatedSignal;

@property (nonatomic, strong) RACSignal *triangleAnimatedSignal;

@property (nonatomic, strong) RACSignal *textAndTriangleSignal;

@property (nonatomic, strong) RACSignal *jumpImageAnimateSignal;

@property (nonatomic, strong) RACDisposable *animateDispose;

@property (nonatomic, strong) RACDisposable *repeatedDispose;

@end
@implementation QDJumpingAnimateView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (instancetype)initWithViewModel:(QDJumpingAnimateViewModel *)viewModel {
    
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
    [self addSubview:self.whiteBgView];
    [self addSubview:self.textLabel];
    [self addSubview:self.triangleImageView];
    [self addSubview:self.jumpImageView];
    [self addGestureRecognizer:self.tap];
    [self setNeedsUpdateConstraints];
    [self updateConstraintsIfNeeded];
}

- (void)updateConstraints {

    WS(weakSelf)
    
    [self.blackBgView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.edges.equalTo(weakSelf);
    }];
    
    [self.whiteBgView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        weakSelf.viewModel.offsetY < 0
        ? make.bottom.equalTo(weakSelf.jumpImageView.mas_top).offset(weakSelf.viewModel.offsetY)
        : make.top.equalTo(weakSelf.jumpImageView.mas_bottom).offset(weakSelf.viewModel.offsetY);
        
        make.left.equalTo(weakSelf.viewModel.whiteLeftEdge);
        make.right.equalTo(-weakSelf.viewModel.whiteRightEdge);
        make.height.equalTo(65);
    }];
    
    [self.textLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.right.equalTo(weakSelf.whiteBgView);
        make.height.equalTo(20);
        make.bottom.equalTo(weakSelf.whiteBgView.mas_bottom).offset(-19);
    }];
    
    [self.triangleImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.centerX.equalTo(weakSelf.jumpImageView);
        make.size.equalTo(CGSizeMake(15, 7.5));
        
        weakSelf.viewModel.offsetY < 0
        ? make.bottom.equalTo(weakSelf.whiteBgView)
        : make.top.equalTo(weakSelf.whiteBgView);
    }];
    
    [super updateConstraints];
}

#pragma mark - private

- (void)qd_bindViewModel {

     @weakify(self);
    [[self.viewModel.refreshSubject deliverOn:[RACScheduler mainThreadScheduler]] subscribeNext:^(id x) {
       
        @strongify(self);
        self.jumpImageView.image = self.viewModel.jumpNeedImage;
        self.jumpImageView.frame = self.viewModel.jumpFrame;
    }];
    
    RAC(self.textLabel, attributedText) = [[RACObserve(self, viewModel.attributedStr) distinctUntilChanged] filter:^BOOL(NSAttributedString *value) {
        
        return value.length > 0;
    }];
    
    [[self.tap.rac_gestureSignal takeUntil:self.rac_willDeallocSignal] subscribeNext:^(id x) {
        
        @strongify(self);
        [self qd_disMiss:^{
            
        }];
    }];
}

- (void)resetView {

    self.whiteBgView.alpha = 0.0;
    self.triangleImageView.alpha = 0.0;
    self.jumpImageView.alpha = 0.0;
    self.textLabel.alpha = 0.0;
    
    WS(weakSelf)
    
    [self.whiteBgView mas_remakeConstraints:^(MASConstraintMaker *make) {
        
        weakSelf.viewModel.offsetY < 0
        ? make.bottom.equalTo(weakSelf.jumpImageView.mas_top).offset(weakSelf.viewModel.offsetY)
        : make.top.equalTo(weakSelf.jumpImageView.mas_bottom).offset(weakSelf.viewModel.offsetY);
        
        make.left.equalTo(weakSelf.viewModel.whiteLeftEdge);
        make.right.equalTo(-weakSelf.viewModel.whiteRightEdge);
        make.height.equalTo(65);
    }];
    
    [self.textLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        
        make.left.right.equalTo(weakSelf.whiteBgView);
        make.height.equalTo(20);
        make.bottom.equalTo(weakSelf.whiteBgView.mas_bottom).offset(-19);
    }];
    
    [self.triangleImageView mas_remakeConstraints:^(MASConstraintMaker *make) {
        
        make.centerX.equalTo(weakSelf.jumpImageView);
        make.size.equalTo(CGSizeMake(15, 7.5));
        
        weakSelf.viewModel.offsetY < 0
        ? make.bottom.equalTo(weakSelf.whiteBgView)
        : make.top.equalTo(weakSelf.whiteBgView);
    }];
    
}

#pragma mark - public

- (void)qd_startShowWithFinish:(Finish)finsh {

    if (![[UIApplication sharedApplication].keyWindow.subviews containsObject:self]) {
    
        [[UIApplication sharedApplication].keyWindow addSubview:self];
        
        [self mas_makeConstraints:^(MASConstraintMaker *make) {
        
            make.edges.equalTo([UIApplication sharedApplication].keyWindow);
        }];
        
        [self zh_startShowWithFinish:^{
            
            if (finsh) {
                
                double delayInSeconds = 1.f;
                dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
                
                dispatch_after(popTime, dispatch_get_main_queue(), ^{
                    
                    finsh();
                    
                });
                
            }
        }];
    }
}

- (void)qd_disMiss:(Finish)finsh {

    if ([[UIApplication sharedApplication].keyWindow.subviews containsObject:self]) {
        
        [self.animateDispose dispose];
        [self.repeatedDispose dispose];
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

#pragma mark - 组合使用
- (void)zh_startShowWithFinish:(Finish)finsh {
    
    self.jumpImageView.image = self.viewModel.jumpNeedImage;
    self.jumpImageView.frame = self.viewModel.jumpFrame;
    
    @weakify(self);
    self.animateDispose = [[[[self.whiteAnimatedSignal deliverOnMainThread] then:^RACSignal *{
        
        @strongify(self);
        return [self.textAndTriangleSignal deliverOnMainThread];
    }] then:^RACSignal *{
        
        @strongify(self);
        
        if (self.canJumpBlock) {
            
            self.canJumpBlock();
        }
        return [self.jumpImageAnimateSignal deliverOnMainThread];
    }] subscribeNext:^(id x) {
        
        @strongify(self);
        
        if (finsh) {
            
            finsh();;
        }
        
        if (self.animateFinish) {
            
            self.animateFinish();
        }
        
        self.repeatedDispose = [[RACSignal interval:3.0 onScheduler:[RACScheduler mainThreadScheduler]]subscribeNext:^(id x) {
            
            @strongify(self);
            [self.jumpImageAnimateSignal subscribeNext:^(id x) {
                
            }];
        }];
        
    }];
}

- (void)zh_removeTap {

    [self removeGestureRecognizer:self.tap];
}

- (void)zh_disMiss:(Finish)finsh {
    
    [self.animateDispose dispose];
    [self.repeatedDispose dispose];
    [self.layer removeAllAnimations];
    [self resetView];
    
    if (self.disMissFinish) {
        
        self.disMissFinish();
    }
    
    if (finsh) {
        
        finsh();
    }
}

#pragma mark - lazyLoad
- (QDJumpingAnimateViewModel *)viewModel {

    if (!_viewModel) {
        
        _viewModel = [[QDJumpingAnimateViewModel alloc] init];
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
        _whiteBgView.layer.masksToBounds = YES;
        _whiteBgView.layer.cornerRadius = self.viewModel.whiteLeftEdge > 0 ? 5.0 : 0.0;
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

- (UIImageView *)triangleImageView {

    if (!_triangleImageView) {
        
        _triangleImageView = [[UIImageView alloc] init];
        _triangleImageView.image = [UIImage imageNamed:@"01提示类-三角icon"];
        _triangleImageView.alpha = 0.0;
        _triangleImageView.transform = self.viewModel.offsetY < 0 ? CGAffineTransformIdentity : CGAffineTransformMakeRotation(180 * M_PI / 180.0);
    }
    
    return _triangleImageView;
}

- (UIImageView *)jumpImageView {
    
    if (!_jumpImageView) {
        
        _jumpImageView = [[UIImageView alloc] init];
        _jumpImageView.frame = CGRectMake(100, 400, 30, 30);
        _jumpImageView.alpha = 0.0;
    }
    
    return _jumpImageView;
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

- (RACSignal *)triangleAnimatedSignal {

    if (!_triangleAnimatedSignal) {
        
         @weakify(self);
        _triangleAnimatedSignal = [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
            
            @strongify(self);
            [UIView animateWithDuration:5/50.0 delay:5/50.0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
                
                @strongify(self);
                self.triangleImageView.alpha = 1.0;
                self.triangleImageView.centerY = self.viewModel.offsetY < 0 ?  self.triangleImageView.centerY + 7.5 : self.triangleImageView.centerY - 7.5;
                
            } completion:^(BOOL finished) {
               
                [subscriber sendNext:nil];
                [subscriber sendCompleted];
                
            }];
            
            return nil;
        }];
    }
    
    return _triangleAnimatedSignal;
}

- (RACSignal *)textAndTriangleSignal {

    if (!_textAndTriangleSignal) {
        
        _textAndTriangleSignal = [self.textAnimatedSignal combineLatestWith:self.triangleAnimatedSignal];
    }
    
    return _textAndTriangleSignal;
}

- (RACSignal *)jumpImageAnimateSignal {

    if (!_jumpImageAnimateSignal) {
        
         @weakify(self);
        _jumpImageAnimateSignal = [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
          
            @strongify(self);
            self.jumpImageView.alpha = 1.0;
            JumpAnimation(self.jumpImageView, 1.0, - 30);
            [self.jumpImageView startAnimating];
            
            [subscriber sendNext:nil];
            [subscriber sendCompleted];
            return nil;
        }];
    }
    
    return _jumpImageAnimateSignal;
}

@end
