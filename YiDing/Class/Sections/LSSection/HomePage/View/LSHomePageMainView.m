//
//  LSHomePageMainView.m
//  YiDing
//
//  Created by 王隆帅 on 16/7/13.
//  Copyright © 2016年 王隆帅. All rights reserved.
//

#import "LSHomePageMainView.h"
#import "LSHomePageViewModel.h"
#import "LSHomePageCell.h"

@interface LSHomePageMainView () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) LSHomePageViewModel *viewModel;

@property (nonatomic, strong) UITableView *mainTableView;

@end
@implementation LSHomePageMainView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

#pragma mark - system

- (instancetype)initWithViewModel:(id<YDViewModelProtocol>)viewModel {
    
    self.viewModel = (LSHomePageViewModel *)viewModel;
    return [super initWithViewModel:viewModel];
}

- (void)updateConstraints {
    
    WS(weakSelf)
    [self.mainTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.edges.equalTo(weakSelf);
    }];
    [super updateConstraints];
}

#pragma mark - private
- (void)yd_setupViews {
    
    [self addSubview:self.mainTableView];
    [self setNeedsUpdateConstraints];
    [self updateConstraintsIfNeeded];
}

- (void)yd_bindViewModel {
    
}

#pragma mark - lazyLoad
- (LSHomePageViewModel *)viewModel {
    
    if (!_viewModel) {
        
        _viewModel = [[LSHomePageViewModel alloc] init];
    }
    
    return _viewModel;
}

- (UITableView *)mainTableView {
    
    if (!_mainTableView) {
        
        _mainTableView = [[UITableView alloc] init];
        _mainTableView.delegate = self;
        _mainTableView.dataSource = self;
        _mainTableView.backgroundColor = GX_BGCOLOR;
        _mainTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [_mainTableView registerClass:[LSHomePageCell class] forCellReuseIdentifier:[NSString stringWithUTF8String:object_getClassName([LSHomePageCell class])]];
    }
    
    return _mainTableView;
}

#pragma mark - delegate

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.viewModel.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    LSHomePageCell *cell = [tableView dequeueReusableCellWithIdentifier:[NSString stringWithUTF8String:object_getClassName([LSHomePageCell class])] forIndexPath:indexPath];
    
    if (self.viewModel.dataArray.count > indexPath.row) {
        
        cell.viewModel = self.viewModel.dataArray[indexPath.row];
    }
    
    return cell;
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 100;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

@end
