//
//  BTListBottomCellTableViewCell.h
//  bt
//
//  Created by zjz on 2017/3/10.
//  Copyright © 2017年 selfdoctor. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BTListBottomCell : UITableViewCell
@property (nonatomic) CGFloat height;

- (void)setTitle:(NSString *)title block:(void(^)())block;
@end
