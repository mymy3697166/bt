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

- (void)setWeight:(NSNumber *)weight {
  _weight = weight;
  labWeight.text = [weight stringValue];
}

- (void)setDiff:(NSNumber *)diff {
  _diff = diff;
  labDiff.text = [NSString stringWithFormat:@"已减轻%@kg", diff];
}

- (void)awakeFromNib {
  [super awakeFromNib];
}

- (IBAction)editClick:(UIButton *)sender {
  [Common info:@"asdf"];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
  [super setSelected:selected animated:animated];
}
@end
