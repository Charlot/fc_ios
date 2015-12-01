//
//  MovementListFinishViewController.m
//  Material
//
//  Created by ryan on 11/25/15.
//  Copyright © 2015 brilliantech. All rights reserved.
//

#import "MovementListFinishViewController.h"
#import "MovementAPI.h"
#import "Movement.h"
#import "ShiftingPrintViewController.h"
#import "MovementDetailViewController.h"

@interface MovementListFinishViewController ()
@property(strong, nonatomic) IBOutlet UITableView *movementListFinishTable;
@property(nonatomic, strong) NSMutableArray *dataArray;
@end

@implementation MovementListFinishViewController

- (void)viewDidLoad {
  [super viewDidLoad];
  // Do any additional setup after loading the view.
  [self customUI];
  [self loadData];
}

- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
  // Dispose of any resources that can be recreated.
}

- (void)customUI {
  self.navigationItem.rightBarButtonItem =
      [[UIBarButtonItem alloc] initWithTitle:@"打印"
                                       style:UIBarButtonItemStylePlain
                                      target:self
                                      action:@selector(toPrint:)];
}

- (void)toPrint:(id)sender {
  //  [self dismissViewControllerAnimated:YES completion:nil];
  [self performSegueWithIdentifier:@"toPrintVC" sender:self];
}

- (void)loadData {

  self.movementListFinishTable.delegate = self;
  self.movementListFinishTable.dataSource = self;
  self.dataArray = [[NSMutableArray alloc] init];
  MovementAPI *api = [[MovementAPI alloc] init];
  //  self.dataArray =
  //      [api queryByMovementListID:self.movement_list_id ObjectDictionary:0];
  [api webGetMovementResources:self.movement_list_id
                      withView:self.view
                         block:^(NSMutableArray *dataArray, NSError *error) {
                           if (error == nil) {
                             for (int i = 0; i < [dataArray count]; i++) {
                               [self.dataArray addObject:dataArray[i]];
                             }
                             [self.movementListFinishTable reloadData];
                           }
                         }];
}

- (NSInteger)tableView:(UITableView *)tableView
 numberOfRowsInSection:(NSInteger)section {
  return [self.dataArray count];
}

#pragma mark UITableView Delegate

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  static NSString *TableCellReuseIdentifier =
      @"completeTableCellReuseIdentifier";
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
  qtyLabel.text = [NSString stringWithFormat:@"%@", movement.qty];
}

- (UIView *)tableView:(UITableView *)tableView
    viewForHeaderInSection:(NSInteger)section {
  UILabel *movementCountLabel = [[UILabel alloc]
      initWithFrame:CGRectMake(0, 0, self.view.frame.size.width / 2, 30)];
  movementCountLabel.textColor = [UIColor redColor];
  movementCountLabel.textAlignment = NSTextAlignmentLeft;
  movementCountLabel.text = [NSString
      stringWithFormat:@"已扫描%ld个零件", [self.dataArray count]];
  return movementCountLabel;
}

- (CGFloat)tableView:(UITableView *)tableView
    heightForHeaderInSection:(NSInteger)section {
  return 30;
}

- (void)tableView:(UITableView *)tableView
    didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
  [self performSegueWithIdentifier:@"toMovementVC" sender:self];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
  if ([segue.identifier isEqualToString:@"toMovementVC"]) {
    MovementDetailViewController *detail = segue.destinationViewController;
    detail.movement = self.dataArray[self.movementListFinishTable
                                         .indexPathForSelectedRow.row];
  }
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

@end
