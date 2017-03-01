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
}

- (void)awakeFromNib {
  [super awakeFromNib];
}

- (void)setData:(NSDictionary *)data {
  labWeight.text = [data[@"weight"] stringValue];
  labDiff.text = [NSString stringWithFormat:@"已减轻%@kg", data[@"difference"]];
}

- (IBAction)editClick:(UIButton *)sender {
  [Common info:@"asdf"];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
  [super setSelected:selected animated:animated];
}
@end
