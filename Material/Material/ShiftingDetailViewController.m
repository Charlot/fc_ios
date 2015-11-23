//
//  ShiftingDetailViewController.m
//  Material
//
//  Created by ryan on 11/19/15.
//  Copyright © 2015 brilliantech. All rights reserved.
//

#import "ShiftingDetailViewController.h"
#import "MovementList.h"
#import "Movement.h"
#import "MovementAPI.h"
#import "MovementDetailViewController.h"

@interface ShiftingDetailViewController ()
@property(strong, nonatomic) NSMutableArray *dataArray;
@property(strong, nonatomic) IBOutlet UITableView *detailTableView;
@end

@implementation ShiftingDetailViewController

- (void)viewDidLoad {
  [super viewDidLoad];
  [self loadData];
}

- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
  // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little
preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (void)loadData {
  self.detailTableView.delegate = self;
  self.detailTableView.dataSource = self;
  self.dataArray = [[NSMutableArray alloc] init];
  MovementAPI *api = [[MovementAPI alloc] init];
  self.dataArray = [api queryByMovementListID:self.movement_list_id];
  [self.detailTableView reloadData];
}

- (NSInteger)tableView:(UITableView *)tableView
 numberOfRowsInSection:(NSInteger)section {
  return [self.dataArray count];
}

#pragma mark UITableView Delegate

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  static NSString *TableCellReuseIdentifier = @"detailTableCellReuseIdentifier";
  UITableViewCell *cell =
      [tableView dequeueReusableCellWithIdentifier:TableCellReuseIdentifier
                                      forIndexPath:indexPath];

  [self configureCell:cell forIndexPath:indexPath];

  return cell;
}

- (void)configureCell:(UITableViewCell *)cell
         forIndexPath:(NSIndexPath *)indexPath {

  Movement *movement = (Movement *)self.dataArray[indexPath.row];
  UILabel *toWhLabel = [cell.contentView viewWithTag:100];
  UILabel *toPositionLabel = [cell.contentView viewWithTag:200];
  UILabel *partNrLabel = [cell.contentView viewWithTag:300];
  UILabel *qtyLabel = [cell.contentView viewWithTag:400];

  toWhLabel.text = movement.toWh;
  toPositionLabel.text = movement.toPosition;
  partNrLabel.text = movement.partNr;
  qtyLabel.text = movement.qty;
}

- (UIView *)tableView:(UITableView *)tableView
    viewForHeaderInSection:(NSInteger)section {
  UILabel *movementCountLabel = [[UILabel alloc]
      initWithFrame:CGRectMake(0, 0, self.view.frame.size.width / 2, 30)];
  movementCountLabel.textColor = [UIColor redColor];
  movementCountLabel.textAlignment = NSTextAlignmentLeft;
  movementCountLabel.text = [NSString
      stringWithFormat:@"已扫描%d个零件", [self.dataArray count]];
  return movementCountLabel;
}

- (CGFloat)tableView:(UITableView *)tableView
    heightForHeaderInSection:(NSInteger)section {
  return 30;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
  if ([segue.identifier isEqualToString:@"toMovementDetailVC"]) {
    MovementDetailViewController *movementdetail =
        segue.destinationViewController;
    movementdetail.movement =
        (Movement *)
            self.dataArray[self.detailTableView.indexPathForSelectedRow.row];
  }
}

@end
