//
//  BTDynamicTitleCell.m
//  bt
//
//  Created by zjz on 2017/3/9.
//  Copyright © 2017年 selfdoctor. All rights reserved.
//

#import "BTDynamicTitleCell.h"

@implementation BTDynamicTitleCell {
  __weak IBOutlet UILabel *labTitle;
}
- (void)awakeFromNib {
  [super awakeFromNib];
}

- (void)setData:(BTCourse *)course {
  NSString *title = [NSString stringWithFormat:@"有%@人也在执行（%@）", course.executionCount, course.name];
  labTitle.text = title;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
  [super setSelected:selected animated:animated];
}
@end
