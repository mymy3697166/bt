//
//  BTWeightCell.m
//  bt
//
//  Created by zjz on 17/1/16.
//  Copyright © 2017年 selfdoctor. All rights reserved.
//

#import "BTWeightCell.h"
#import "BTCommon.h"

@implementation BTWeightCell {
  __weak IBOutlet UILabel *labWeight;
  __weak IBOutlet UILabel *labDiff;
  
  UIViewController *viewController;
}

- (void)awakeFromNib {
  [super awakeFromNib];
}

- (void)setData:(NSDictionary *)data inController:(UIViewController *)controller {
  viewController = controller;
  labWeight.text = [NSString stringWithFormat:@"%.1f", [data[@"weight"] floatValue]];
  labDiff.text = [NSString stringWithFormat:@"已减轻%.1fkg", [data[@"difference"] floatValue]];
}

- (IBAction)editClick:(UIButton *)sender {
  [viewController performSegueWithIdentifier:@"planhome_updateweight" sender:nil];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
  [super setSelected:selected animated:animated];
}
@end
