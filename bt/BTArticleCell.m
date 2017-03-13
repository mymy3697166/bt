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
  
  UIViewController *viewController;
}
- (void)setData:(NSDictionary *)data inController:(UIViewController *)controller {
  viewController = controller;
  [ivImage loadURL:[URL_IMAGEPATH stringByAppendingString:data[@"cover"]]];
  labName.text = data[@"title"];
}
@end
