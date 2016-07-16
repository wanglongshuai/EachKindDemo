//
//  QDChatSelectedCollectionView.m
//  QuDianApp
//
//  Created by 王隆帅 on 16/6/28.
//  Copyright © 2016年 wangpengbo. All rights reserved.
//

#import "QDChatSelectedCollectionView.h"
#import "QDChatSelectedImageCell.h"

@interface QDChatSelectedCollectionView () <UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>

@property (nonatomic, strong) QDChatSelectedViewModel *viewModel;

@property (nonatomic, strong) UICollectionView *collectionView;

@property (nonatomic, strong) UICollectionViewFlowLayout *flowLayout;

@property (nonatomic, strong) UIButton *selectedBtn;

@property (nonatomic, strong) UIImageView *lineImageView;

@end
@implementation QDChatSelectedCollectionView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/


- (instancetype)initWithViewModel:(QDChatSelectedViewModel *)viewModel {
    
    self = [super init];
    if (self) {
        
        self.viewModel = viewModel;
        [self qd_setupViews];
        [self qd_bindViewModel];
    }
    return self;
}

- (void)qd_setupViews {
    
    [self addSubview:self.collectionView];
    [self addSubview:self.selectedBtn];
    [self addSubview:self.lineImageView];
    
    [self setNeedsUpdateConstraints];
    [self updateConstraintsIfNeeded];
}

- (void)updateConstraints {
    
    WS(weakSelf)
    
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.top.bottom.equalTo(weakSelf);
        make.right.equalTo(weakSelf.selectedBtn.mas_left);
    }];
    
    [self.selectedBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.right.bottom.equalTo(weakSelf);
        make.width.equalTo(60);
    }];
    
    [self.lineImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.top.right.equalTo(weakSelf);
        make.height.equalTo(1.0);
    }];
    
    [super updateConstraints];
}

- (void)qd_bindViewModel {
    
    @weakify(self);
    
//    self.selectedBtn.rac_command = self.viewModel.selectedCommand;
    
    [[self.viewModel.refreshUISubject takeUntil:self.rac_willDeallocSignal] subscribeNext:^(id x) {
        
        @strongify(self);
        [self.collectionView reloadData];
    }];
    
    [[self.viewModel.addSubject takeUntil:self.rac_willDeallocSignal] subscribeNext:^(QDChatImagePickerCellViewModel *viewModel) {
        
        @strongify(self);
        if (![self.viewModel.dataArray containsObject:viewModel]) {
            
            NSMutableArray *mutabArray = [NSMutableArray arrayWithArray:self.viewModel.dataArray];
            [mutabArray addObject:viewModel];
            self.viewModel.dataArray = mutabArray;
            
            self.viewModel.sizeArray = [[[self.viewModel.dataArray rac_sequence] map:^id(QDChatImagePickerCellViewModel *viewModel) {
                
                CGFloat pro = viewModel.image.size.width / viewModel.image.size.height;
                return [NSValue valueWithCGSize:CGSizeMake(self.viewModel.selectedHeight * pro, self.viewModel.selectedHeight)];
            }] array];
            
            NSInteger row = [self.viewModel.dataArray indexOfObject:viewModel];
            [self.collectionView reloadData];
            
            if ([self.collectionView numberOfItemsInSection:0] > row) {
                
                [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForRow:row inSection:0] atScrollPosition:UICollectionViewScrollPositionRight animated:YES];
            }

        }
    }];
    
    [[self.viewModel.deleteSubject takeUntil:self.rac_willDeallocSignal] subscribeNext:^(QDChatImagePickerCellViewModel *viewModel) {
        
        @strongify(self);
        if ([self.viewModel.dataArray containsObject:viewModel]) {
            
            NSInteger row = [self.viewModel.dataArray indexOfObject:viewModel];
            
            NSMutableArray *mutabArray = [NSMutableArray arrayWithArray:self.viewModel.dataArray];
            [mutabArray removeObject:viewModel];
            self.viewModel.dataArray = mutabArray;
            
            self.viewModel.sizeArray = [[[self.viewModel.dataArray rac_sequence] map:^id(QDChatImagePickerCellViewModel *viewModel) {
                
                CGFloat pro = viewModel.image.size.width / viewModel.image.size.height;
                return [NSValue valueWithCGSize:CGSizeMake(self.viewModel.selectedHeight * pro, self.viewModel.selectedHeight)];
            }] array];

            [self.collectionView deleteItemsAtIndexPaths:@[[NSIndexPath indexPathForRow:row inSection:0]]];
            
            dispatch_time_t delayTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC));
            dispatch_after(delayTime, dispatch_get_main_queue(), ^{
                
                @strongify(self);
                [self.collectionView reloadData];
            });
        }
    }];
    
    [[[self.selectedBtn rac_signalForControlEvents:UIControlEventTouchUpInside] takeUntil:self.rac_willDeallocSignal] subscribeNext:^(id x) {
      
        @strongify(self);
        [self.viewModel.finishSubject sendNext:self.viewModel.dataArray];
    }];
}

#pragma mark - public

- (void)qd_removeAllSelected {

    self.viewModel.dataArray  = [NSArray array];
    self.viewModel.sizeArray = [NSArray array];
    [self.collectionView reloadData];
}

#pragma mark - lazyLoad

- (UICollectionView *)collectionView {
    
    if (!_collectionView) {
        
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:self.flowLayout];
        _collectionView.collectionViewLayout = self.flowLayout;
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.backgroundColor = [UIColor clearColor];
        _collectionView.showsHorizontalScrollIndicator = NO;
        _collectionView.showsVerticalScrollIndicator = NO;
        [_collectionView registerClass:[QDChatSelectedImageCell class] forCellWithReuseIdentifier:[NSString stringWithUTF8String:object_getClassName([QDChatSelectedImageCell class])]];
    }
    return _collectionView;
}

- (UICollectionViewFlowLayout *)flowLayout {
    
    if (!_flowLayout) {
        
        _flowLayout = [[UICollectionViewFlowLayout alloc] init];
        _flowLayout.minimumLineSpacing = 5.0f;
        _flowLayout.minimumInteritemSpacing = 5.0f;
        _flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    }
    
    return _flowLayout;
}

- (QDChatSelectedViewModel *)viewModel {
    
    if (!_viewModel) {
        
        _viewModel = [[QDChatSelectedViewModel alloc] init];
    }
    
    return _viewModel;
}

- (UIButton *)selectedBtn {

    if (!_selectedBtn) {
        
        _selectedBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_selectedBtn setImage:[UIImage imageNamed:@"chat_btn_sent_arrow"] forState:UIControlStateNormal];
    }
    
    return _selectedBtn;
}

- (UIImageView *)lineImageView {

    if (!_lineImageView) {
        
        _lineImageView = [[UIImageView alloc] init];
        _lineImageView.backgroundColor = [UIColor colorWithRed:244.0/255.0 green:243.0/255.0 blue:244.0/255.0 alpha:1.0];
    }
    
    return _lineImageView;
}

#pragma mark - UICollectionViewDataSource, UICollectionViewDelegateFlowLayout

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    return self.viewModel.dataArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    QDChatSelectedImageCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:[NSString stringWithUTF8String:object_getClassName([QDChatSelectedImageCell class])] forIndexPath:indexPath];
    cell.viewModel = self.viewModel.dataArray[indexPath.row];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    [self.viewModel.selectedSubject sendNext:self.viewModel.dataArray[indexPath.row]];
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    return [self.viewModel.sizeArray[indexPath.row] CGSizeValue];
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    
    return UIEdgeInsetsMake(10.0, 10.0, 10.0, 10.0);
}

@end
