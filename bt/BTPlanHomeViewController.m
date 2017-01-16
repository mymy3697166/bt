//
//  BTPlanHomeViewController.m
//  bt
//
//  Created by zjz on 2017/1/16.
//  Copyright © 2017年 selfdoctor. All rights reserved.
//

#import "BTPlanHomeViewController.h"
#import "BTLoginNavigationController.h"
#import "BTWeightCell.h"
#import "BTCurrentCourseCell.h"

@interface BTPlanHomeViewController () <UITableViewDataSource, UITableViewDelegate> {
  
}

@end

@implementation BTPlanHomeViewController

- (void)viewDidLoad {
  [super viewDidLoad];
  [Common asyncPost:URL_ACCESSTOKENLOGIN forms:nil completion:^(NSDictionary *data) {
    if (!data) return;
    if ([data[@"status"] isEqual:@0]) {
      User.token = data[@"data"][@"access_token"];
      NSLog(@"%@", [URL_AVATARPATH stringByAppendingString:User.avatar]);
      [Common cacheImage:[URL_AVATARPATH stringByAppendingString:User.avatar] completion:^(UIImage *image) {
        UIImageView *btn = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 36, 36)];
        btn.clipsToBounds = YES;
        btn.layer.cornerRadius = 18;
        btn.image = image;
        self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:btn];
      }];
    } else {
      BTLoginNavigationController *lnc = [self.storyboard instantiateViewControllerWithIdentifier:@"BTLoginNavigationController"];
      [self presentViewController:lnc animated:YES completion:nil];
    }
  }];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {return 1;}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {return 1;}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
  return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
  return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  if (indexPath.section == 0) {
    BTWeightCell *cell = [tableView dequeueReusableCellWithIdentifier:@"BTWeightCell" forIndexPath:indexPath];
    if (!cell) {
      
    }
    return cell;
  } else {
    BTCurrentCourseCell *cell = [tableView dequeueReusableCellWithIdentifier:@"BTCurrentCourseCell" forIndexPath:indexPath];
    return cell;
  }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
  [tableView deselectRowAtIndexPath:indexPath animated:NO];
}
@end
