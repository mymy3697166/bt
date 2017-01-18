//
//  BTRecommendArticleCell.m
//  bt
//
//  Created by zjz on 17/1/18.
//  Copyright © 2017年 selfdoctor. All rights reserved.
//

#import "BTRecommendArticleCell.h"

@implementation BTRecommendArticleCell

- (void)awakeFromNib {
  [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
  [super setSelected:selected animated:animated];
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
  return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
  return 1;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
  return [[UICollectionViewCell alloc] init];
}
@end
