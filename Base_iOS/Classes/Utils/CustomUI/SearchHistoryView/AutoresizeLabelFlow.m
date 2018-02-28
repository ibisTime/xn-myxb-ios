//
//  AutoresizeLabelFlow.m
//  Base_iOS
//
//  Created by 蔡卓越 on 2018/2/28.
//  Copyright © 2018年 caizhuoyue. All rights reserved.
//

#import "AutoresizeLabelFlow.h"
#import "AutoresizeLabelFlowLayout.h"
#import "AutoresizeLabelFlowCell.h"
#import "AutoresizeLabelFlowConfig.h"

static NSString *const cellId = @"cellId";

@interface AutoresizeLabelFlow()<UICollectionViewDataSource,UICollectionViewDelegate,AutoresizeLabelFlowLayoutDataSource,AutoresizeLabelFlowLayoutDelegate>

@property (nonatomic,strong) UICollectionView *collection;
@property (nonatomic,  copy) selectedHandler  handler;

@end

@implementation AutoresizeLabelFlow

- (instancetype)initWithFrame:(CGRect)frame selectedHandler:(selectedHandler)handler {
    self = [super initWithFrame:frame];
    
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        self.handler = handler;
        [self setup];
    }
    return self;
}

- (void)setup {
    AutoresizeLabelFlowLayout *layout = [[AutoresizeLabelFlowLayout alloc]init];
    layout.delegate = self;
    layout.dataSource = self;
    self.collection = [[UICollectionView alloc]initWithFrame:self.bounds collectionViewLayout:layout];
    self.collection.backgroundColor = [AutoresizeLabelFlowConfig shareConfig].backgroundColor;
    self.collection.allowsMultipleSelection = YES;
    self.collection.delegate = self;
    self.collection.dataSource = self;
    [self.collection registerClass:[AutoresizeLabelFlowCell class] forCellWithReuseIdentifier:cellId];
    [self addSubview:self.collection];
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.data.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    AutoresizeLabelFlowCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellId forIndexPath:indexPath];
    
    cell.model = self.data[indexPath.item];
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    AutoresizeLabelModel *model = self.data[indexPath.item];

    [self.data enumerateObjectsUsingBlock:^(AutoresizeLabelModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        obj.isSelected = obj == model ? YES: NO;
    }];
    
    [collectionView reloadData];
    
    if (self.handler) {
        
        self.handler(indexPath.item, model.title);
    }
}

- (NSString *)titleForLabelAtIndexPath:(NSIndexPath *)indexPath {
    
    AutoresizeLabelModel *model = self.data[indexPath.item];

    return model.title;
}

- (void)layoutFinishWithNumberOfline:(NSInteger)number {
    static NSInteger numberCount;
    if (numberCount == number) {
        return;
    }
    numberCount = number;
    AutoresizeLabelFlowConfig *config = [AutoresizeLabelFlowConfig shareConfig];
    CGFloat h = config.contentInsets.top+config.contentInsets.bottom+config.itemHeight*number+config.lineSpace*(number-1);
    self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, self.frame.size.width, h);
    [UIView animateWithDuration:0.2 animations:^{
        self.collection.frame = self.bounds;
    }];
}

//- (void)insertLabelWithTitle:(NSString *)title atIndex:(NSUInteger)index animated:(BOOL)animated {
//    NSIndexPath *indexPath = [NSIndexPath indexPathForItem:index inSection:0];
//    [self.data insertObject:title atIndex:index];
//    [self performBatchUpdatesWithAction:UICollectionUpdateActionInsert indexPaths:@[indexPath] animated:animated];
//}
//
//- (void)insertLabelsWithTitles:(NSArray *)titles atIndexes:(NSIndexSet *)indexes animated:(BOOL)animated {
//    NSArray *indexPaths = [self indexPathsWithIndexes:indexes];
//    [self.data insertObjects:titles atIndexes:indexes];
//    [self performBatchUpdatesWithAction:UICollectionUpdateActionInsert indexPaths:indexPaths animated:animated];
//}
//
//- (void)deleteLabelAtIndex:(NSUInteger)index animated:(BOOL)animated {
//    [self deleteLabelsAtIndexes:[NSIndexSet indexSetWithIndex:index] animated:animated];
//}
//
//- (void)deleteLabelsAtIndexes:(NSIndexSet *)indexes animated:(BOOL)animated {
//    NSArray *indexPaths = [self indexPathsWithIndexes:indexes];
//    [self.data removeObjectsAtIndexes:indexes];
//    [self performBatchUpdatesWithAction:UICollectionUpdateActionDelete indexPaths:indexPaths animated:animated];
//}

- (void)reloadAllWithTitles:(NSArray *)titles {
    self.data = [titles mutableCopy];
    [self.collection reloadData];
}

- (void)performBatchUpdatesWithAction:(UICollectionUpdateAction)action indexPaths:(NSArray *)indexPaths animated:(BOOL)animated {
    if (!animated) {
        [UIView setAnimationsEnabled:NO];
    }
    [self.collection performBatchUpdates:^{
        switch (action) {
            case UICollectionUpdateActionInsert:
                [self.collection insertItemsAtIndexPaths:indexPaths];
                break;
            case UICollectionUpdateActionDelete:
                [self.collection deleteItemsAtIndexPaths:indexPaths];
            default:
                break;
        }
    } completion:^(BOOL finished) {
        if (!animated) {
            [UIView setAnimationsEnabled:YES];
        }
    }];
}

- (NSArray *)indexPathsWithIndexes:(NSIndexSet *)set {
    NSMutableArray *indexPaths = [NSMutableArray arrayWithCapacity:set.count];
    [set enumerateIndexesUsingBlock:^(NSUInteger idx, BOOL *stop) {
        NSIndexPath *indexPath = [NSIndexPath indexPathForItem:idx inSection:0];
        [indexPaths addObject:indexPath];
    }];
    return [indexPaths copy];
}

@end
