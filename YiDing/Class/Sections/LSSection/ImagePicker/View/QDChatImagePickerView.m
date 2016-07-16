//
//  QDChatImagePickerView.m
//  QuDianApp
//
//  Created by 王隆帅 on 16/6/24.
//  Copyright © 2016年 wangpengbo. All rights reserved.
//

#import "QDChatImagePickerView.h"
#import "QDChatImagePickerFlowLayout.h"
#import "QDChatImagePickerCell.h"
#import "QDChatSelectedCollectionView.h"
#import "QDChatSelectedViewModel.h"

@interface QDChatImagePickerView ()  <UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>

@property (nonatomic, strong) QDChatImagePickerViewModel *viewModel;

@property (nonatomic, strong) UICollectionView *collectionView;

@property (nonatomic, strong) QDChatImagePickerFlowLayout *flowLayout;

@property (nonatomic, strong) QDChatImagePickerFlowLayout *selectedFlowLayout;

@property (nonatomic, strong) QDChatSelectedCollectionView *selectedCollectionView;

@property (nonatomic, strong) QDChatSelectedViewModel *selectedViewModel;


@end
@implementation QDChatImagePickerView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (instancetype)initWithViewModel:(QDChatImagePickerViewModel *)viewModel {
    
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
    [self addSubview:self.selectedCollectionView];
    
    [self setNeedsUpdateConstraints];
    [self updateConstraintsIfNeeded];
}

- (void)updateConstraints {
    
    WS(weakSelf)
    
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.edges.equalTo(weakSelf);
    }];
    
    [self.selectedCollectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.bottom.right.equalTo(weakSelf);
        make.top.equalTo(weakSelf.collectionView.mas_bottom);
    }];
    
    [super updateConstraints];
}

- (void)qd_bindViewModel {
    
     @weakify(self);
    [[self.viewModel.refreshUISubject takeUntil:self.rac_willDeallocSignal] subscribeNext:^(id x) {
        
        @strongify(self);
        if (self.viewModel.isSelected) {
            
            // 横向
            self.selectedFlowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
            self.selectedFlowLayout.rectArray = self.viewModel.selectedRectArray;
            self.selectedFlowLayout.scroSize = self.viewModel.horizontalScroSize;
        } else {
            
            // 纵向
            self.flowLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
            self.flowLayout.rectArray = self.viewModel.rectArray;
            self.flowLayout.scroSize = self.viewModel.verticalscroSize;
        }

        [self.collectionView reloadData];
    }];
    
    [[self.viewModel.changeStateSubject takeUntil:self.rac_willDeallocSignal] subscribeNext:^(id value) {
        
        @strongify(self);
        if (self.viewModel.isSelected) {
            
            // 横向
            [self.collectionView setCollectionViewLayout:self.selectedFlowLayout animated:YES];
            
            [self.collectionView mas_remakeConstraints:^(MASConstraintMaker *make) {
                
                @strongify(self);
                make.top.left.right.equalTo(self);
                make.bottom.equalTo(-70);
            }];
        } else {
            
            // 纵向
            [self.collectionView setCollectionViewLayout:self.flowLayout animated:YES];
            
            [self.collectionView mas_remakeConstraints:^(MASConstraintMaker *make) {
                
                @strongify(self);
                make.edges.equalTo(self);
            }];
        }

    }];
    
    [[self.selectedViewModel.selectedSubject takeUntil:self.rac_willDeallocSignal] subscribeNext:^(QDChatImagePickerCellViewModel *viewModel) {
       
        @strongify(self);
        
        if ([self.viewModel.dataArray containsObject:viewModel]) {
            
            NSInteger row = [self.viewModel.dataArray indexOfObject:viewModel];
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:row inSection:0];
            [self.collectionView scrollToItemAtIndexPath:indexPath atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:YES];
        }
    }];
}

#pragma mark - public
- (void)qd_removeAllSelected {

    NSArray *selectedArray = [NSArray arrayWithArray:self.viewModel.selectedItemArray];
    self.viewModel.selectedItemArray = [NSMutableArray array];
    [self.selectedCollectionView qd_removeAllSelected];

    for (QDChatImagePickerCellViewModel *viewModel in selectedArray) {
        
        if ([self.viewModel.dataArray containsObject:viewModel]) {
            
            NSInteger row = [self.viewModel.dataArray indexOfObject:viewModel];
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:row inSection:0];
            [self.collectionView deselectItemAtIndexPath:indexPath animated:NO];
        }        
    }
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
        _collectionView.allowsMultipleSelection = YES;
        [_collectionView registerClass:[QDChatImagePickerCell class] forCellWithReuseIdentifier:[NSString stringWithUTF8String:object_getClassName([QDChatImagePickerCell class])]];
    }
    return _collectionView;
}

- (QDChatImagePickerFlowLayout *)flowLayout {
    
    if (!_flowLayout) {
        
        _flowLayout = [[QDChatImagePickerFlowLayout alloc] init];
        _flowLayout.minimumLineSpacing = 3.0f;
        _flowLayout.minimumInteritemSpacing = 3.0f;
        _flowLayout.rectArray = self.viewModel.rectArray;
        _flowLayout.scroSize = self.viewModel.verticalscroSize;
    }
    
    return _flowLayout;
}

- (QDChatImagePickerFlowLayout *)selectedFlowLayout {

    if (!_selectedFlowLayout) {
        
        _selectedFlowLayout = [[QDChatImagePickerFlowLayout alloc] init];
        _selectedFlowLayout.minimumLineSpacing = 3.0f;
        _selectedFlowLayout.minimumInteritemSpacing = 3.0f;
        _selectedFlowLayout.rectArray = self.viewModel.selectedRectArray;
        _selectedFlowLayout.scroSize = self.viewModel.horizontalScroSize;
    }
    
    return _selectedFlowLayout;
}

- (QDChatImagePickerViewModel *)viewModel {

    if (!_viewModel) {
        
        _viewModel = [[QDChatImagePickerViewModel alloc] init];
    }

    return _viewModel;
}

- (QDChatSelectedCollectionView *)selectedCollectionView {

    if (!_selectedCollectionView) {
        
        _selectedCollectionView = [[QDChatSelectedCollectionView alloc] initWithViewModel:self.selectedViewModel];
    }
    
    return _selectedCollectionView;
}

- (QDChatSelectedViewModel *)selectedViewModel {

    if (!_selectedViewModel) {
        
        _selectedViewModel = [[QDChatSelectedViewModel alloc] init];
        _selectedViewModel.finishSubject = self.viewModel.finishSubject;
    }
    
    return _selectedViewModel;
}

#pragma mark - UICollectionViewDataSource, UICollectionViewDelegateFlowLayout

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    return self.viewModel.dataArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    QDChatImagePickerCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:[NSString stringWithUTF8String:object_getClassName([QDChatImagePickerCell class])] forIndexPath:indexPath];
    cell.viewModel = self.viewModel.dataArray[indexPath.row];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    if (![self.viewModel.selectedItemArray containsObject:self.viewModel.dataArray[indexPath.row]]) {
        
        NSMutableArray *mutabArray = [NSMutableArray arrayWithArray:self.viewModel.selectedItemArray];
        [mutabArray addObject:self.viewModel.dataArray[indexPath.row]];
        self.viewModel.selectedItemArray = mutabArray;
        [self.selectedViewModel.addSubject sendNext:self.viewModel.dataArray[indexPath.row]];
    }
    
    [self.collectionView scrollToItemAtIndexPath:indexPath atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:YES];
}

- (void)collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath {

    if ([self.viewModel.selectedItemArray containsObject:self.viewModel.dataArray[indexPath.row]]) {
        
        NSMutableArray *mutabArray = [NSMutableArray arrayWithArray:self.viewModel.selectedItemArray];
        [mutabArray removeObject:self.viewModel.dataArray[indexPath.row]];
        self.viewModel.selectedItemArray = mutabArray;
        [self.selectedViewModel.deleteSubject sendNext:self.viewModel.dataArray[indexPath.row]];
    }
}

- (BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    return self.viewModel.selectedItemArray.count < 10 ? YES : NO;
}

- (BOOL)collectionView:(UICollectionView *)collectionView shouldDeselectItemAtIndexPath:(NSIndexPath *)indexPath {

    return YES;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    return [self.viewModel.sizeArray[indexPath.row] CGSizeValue];
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    
    return UIEdgeInsetsMake(0, 0, 0, 0);
}

@end
