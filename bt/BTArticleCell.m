//
//  BTArticleCell.m
//  bt
//
//  Created by zjz on 17/1/19.
//  Copyright © 2017年 selfdoctor. All rights reserved.
//

#import "BTArticleCell.h"
#import "BTCommon.h"

@implementation BTArticleCell {
  __weak IBOutlet UIImageView *ivImage;
  __weak IBOutlet UILabel *labName;
}
- (void)setData:(NSDictionary *)data {
  [ivImage loadURL:[URL_IMAGEPATH stringByAppendingString:data[@"cover"]]];
  labName.text = data[@"title"];
}
@end
