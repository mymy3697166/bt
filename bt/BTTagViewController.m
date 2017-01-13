//
//  BTTagViewController.m
//  bt
//
//  Created by zjz on 2017/1/13.
//  Copyright © 2017年 selfdoctor. All rights reserved.
//

#import "BTTagViewController.h"
#import "BTTagCell.h"

@interface BTTagViewController () <UITableViewDelegate, UITableViewDataSource> {
  __weak IBOutlet UITableView *tvTags;
  
  NSArray *dataSource;
}
@end

@implementation BTTagViewController

- (void)viewDidLoad {
  [super viewDidLoad];
  dataSource = @[];
  [Common asyncPost:URL_FETCHTAGS forms:nil completion:^(NSDictionary *data) {
    dataSource = data[@"data"];
    [tvTags reloadData];
  }];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
  return dataSource.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
  NSArray *tags = dataSource[section][@"tags"];
  return tags.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  BTTagCell *cell = [tableView cellForRowAtIndexPath:indexPath];
  if (!cell) {
    NSDictionary *item = dataSource[indexPath.section][@"tags"][indexPath.row];
    cell = [tableView dequeueReusableCellWithIdentifier:@"BTTagCell"];
    cell.icon = item[@"icon"];
    cell.name = item[@"name"];
    cell.isSelected = false;
  }
  return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
  [tableView deselectRowAtIndexPath:indexPath animated:YES];
}
@end
