//
//  BTUpdateWeightViewController.m
//  bt
//
//  Created by zjz on 17/3/12.
//  Copyright © 2017年 selfdoctor. All rights reserved.
//

#import "BTUpdateWeightViewController.h"

@interface BTUpdateWeightViewController () {
  __weak IBOutlet UITextField *tfWeight;
  __weak IBOutlet UIButton *btnYes;
}
@end

@implementation BTUpdateWeightViewController

- (void)viewDidLoad {
  [super viewDidLoad];
  btnYes.layer.cornerRadius = 5;
  [tfWeight becomeFirstResponder];
  tfWeight.text = [User.weights.lastObject[@"weight"] stringValue];
}

- (IBAction)btnYesClick:(id)sender {
  [Common showLoading];
  [User updateWeight:[NSNumber numberWithFloat:[tfWeight.text floatValue]] withBlock:^(NSError *error) {
    [Common hideLoading];
    if (error) {
      [self showError:error];
      return;
    }
    [Notif postNotificationName:@"N_UPDATE_WEIGHT_SUCCESS" object:nil];
    [self.navigationController popViewControllerAnimated:YES];
  }];
}

- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
}
@end
