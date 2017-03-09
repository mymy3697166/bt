//
//  BTRecommendArticleCell.h
//  bt
//
//  Created by zjz on 17/1/18.
//  Copyright © 2017年 selfdoctor. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BTRecommendArticleCell : UITableViewCell <UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>
- (void)setData:(NSArray *)data;
@end
