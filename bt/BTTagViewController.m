//
//  BTTagViewController.m
//  bt
//
//  Created by zjz on 2017/1/13.
//  Copyright © 2017年 selfdoctor. All rights reserved.
//

#import "BTTagViewController.h"
#import "BTTagCell.h"
#import "BTConfirmCourseViewController.h"

@interface BTTagViewController () <UITableViewDelegate, UITableViewDataSource> {
  __weak IBOutlet UITableView *tvTags;
  
  NSArray *dataSource;
}
@end

@implementation BTTagViewController
- (void)viewDidLoad {
  [super viewDidLoad];
  dataSource = @[];
  [Common asyncPost:URL_FETCHTAGS forms:nil completion:^(NSDictionary *data, NSError *error) {
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
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.icon = item[@"icon"];
    cell.name = item[@"name"];
    cell.isSelected = false;
  }
  return cell;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
  return dataSource[section][@"name"];
}

- (void)tableView:(UITableView *)tableView willDisplayHeaderView:(UIView *)view forSection:(NSInteger)section {
  UITableViewHeaderFooterView *header = (UITableViewHeaderFooterView *)view;
  header.textLabel.textColor = RGB(0, 178, 255);
  header.textLabel.font = [UIFont systemFontOfSize:15];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
  BTTagCell *cell = [tableView cellForRowAtIndexPath:indexPath];
  NSString *multiselect = dataSource[indexPath.section][@"multiselect"];
  if ([multiselect isEqualToString:@"1"]) {
    NSInteger count = ((NSArray *)dataSource[indexPath.section][@"tags"]).count;
    for (int i = 0; i < count; i++) {
      NSIndexPath *ip = [NSIndexPath indexPathForRow:i inSection:indexPath.section];
      BTTagCell *itemCell = [tableView cellForRowAtIndexPath:ip];
      itemCell.isSelected = NO;
    }
  }
  cell.isSelected = YES;
}

- (IBAction)nextClick:(UIBarButtonItem *)sender {
  for (int s = 0; s < dataSource.count; s++) {
    NSDictionary *sItem = dataSource[s];
    if ([sItem[@"required"] isEqualToString:@"0"]) {
      NSArray *tags = sItem[@"tags"];
      BOOL selected = NO;
      for (int r = 0; r < tags.count; r++) {
        BTTagCell *cell = [tvTags cellForRowAtIndexPath:[NSIndexPath indexPathForRow:r inSection:s]];
        if (cell.isSelected) selected = YES;
      }
      if (!selected) {
        [Common info:[NSString stringWithFormat:@"请对“%@”做出选择", sItem[@"name"]]];
        return;
      }
    }
  }
  [self performSegueWithIdentifier:@"tag_cc" sender:nil];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
  if ([segue.identifier isEqualToString:@"tag_cc"]) {
    BTConfirmCourseViewController *ccvc = segue.destinationViewController;
    NSMutableArray *selectedTags = [NSMutableArray array];
    [dataSource enumerateObjectsUsingBlock:^(id sItem, NSUInteger sIdx, BOOL *sStop) {
      NSArray *tags = sItem[@"tags"];
      [tags enumerateObjectsUsingBlock:^(id rItem, NSUInteger rIdx, BOOL *rStop) {
        BTTagCell *cell = [tvTags cellForRowAtIndexPath:[NSIndexPath indexPathForRow:rIdx inSection:sIdx]];
        if (cell.isSelected) [selectedTags addObject:rItem[@"id"]];
      }];
    }];
    ccvc.tags = selectedTags;
  }
}
@end
