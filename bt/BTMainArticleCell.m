//
//  BTMainArticleCell.m
//  bt
//
//  Created by zjz on 2017/3/15.
//  Copyright © 2017年 selfdoctor. All rights reserved.
//

#import "BTMainArticleCell.h"
#import "BTCommon.h"

@implementation BTMainArticleCell {
  __weak IBOutlet UIImageView *ivCover;
  __weak IBOutlet UILabel *labTitle;
  __weak IBOutlet UILabel *labSdesc;
  __weak IBOutlet UILabel *labAuthor;
  __weak IBOutlet UIButton *btnComment;
}

- (void)awakeFromNib {
  [super awakeFromNib];
}

- (void)setData:(NSDictionary *)data inController:(UIViewController *)controller {
  [ivCover loadURL:[URL_IMAGEPATH stringByAppendingPathComponent:data[@"cover"]]];
  labTitle.text = data[@"title"];
  labSdesc.text = data[@"sdesc"];
  labAuthor.text = [NSString stringWithFormat:@"%@ %@", data[@"author_name"], [[NSDate dateWithTimeIntervalSince1970:[data[@"created_at"] integerValue]] toStringWithFormat:@"MM-dd"]];
  [btnComment setTitle:[NSString stringWithFormat:@" %@", data[@"comment_count"]] forState:UIControlStateNormal];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
  [super setSelected:selected animated:animated];
}

@end
