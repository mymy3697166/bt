//
//  BTRecommendArticleCell.m
//  bt
//
//  Created by zjz on 17/1/18.
//  Copyright © 2017年 selfdoctor. All rights reserved.
//

#import "BTRecommendArticleCell.h"
#import "BTArticleCell.h"

@implementation BTRecommendArticleCell {
  __weak IBOutlet UICollectionView *cvArticles;
  NSArray *dataSource;
  UIViewController *viewController;
}

- (void)awakeFromNib {
  [super awakeFromNib];
  UINib *articleNib = [UINib nibWithNibName:@"BTArticleCell" bundle:nil];
  [cvArticles registerNib:articleNib forCellWithReuseIdentifier:@"BTArticleCell"];
}

- (void)setData:(NSArray *)data inController:(UIViewController *)controller {
  viewController = controller;
  dataSource = data;
  [cvArticles reloadData];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
  [super setSelected:selected animated:animated];
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
  return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
  return dataSource.count;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
  return CGSizeMake(240, 152);
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
  BTArticleCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"BTArticleCell" forIndexPath:indexPath];
  [cell setData:dataSource[indexPath.row] inController:viewController];
  return cell;
}
@end
