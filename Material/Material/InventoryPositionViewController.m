//
//  InventoryPositionViewController.m
//  Material
//
//  Created by ryan on 11/23/15.
//  Copyright © 2015 brilliantech. All rights reserved.
//

#import "InventoryPositionViewController.h"
#import "InventoryListItem.h"
#import "InventoryConfirmViewController.h"
#import "InventoryAPI.h"
#import "Captuvo.h"
#import <AudioToolbox/AudioToolbox.h>
#import "MovementAPI.h"

@interface InventoryPositionViewController () <
    UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate,
    CaptuvoEventsProtocol>
@property(strong, nonatomic) IBOutlet UITextField *partIDTextField;
@property(strong, nonatomic) IBOutlet UITextField *fifoTextField;
@property(strong, nonatomic) IBOutlet UITextField *qtyTextField;

@property(strong, nonatomic) IBOutlet UITextField *packageTextField;
@property(strong, nonatomic) IBOutlet UITableView *positionTable;
@property(strong, nonatomic) InventoryAPI *api;
@end

@implementation InventoryPositionViewController

- (void)viewDidLoad {
  [super viewDidLoad];
  [self loadData];
}

- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
  // Dispose of any resources that can be recreated.
}

- (void)viewDidDisappear:(BOOL)animated {
  [super viewDidDisappear:YES];
  [self.positionData removeAllObjects];
}

- (void)viewWillAppear:(BOOL)animated {
  [super viewWillAppear:animated];
  [[Captuvo sharedCaptuvoDevice] addCaptuvoDelegate:self];
}
- (void)viewWillDisappear:(BOOL)animated {
  [super viewWillDisappear:animated];
  [[Captuvo sharedCaptuvoDevice] removeCaptuvoDelegate:self];
}

- (void)decoderDataReceived:(NSString *)data {
  NSArray *subviews = [self.view subviews];
  for (id objInput in subviews) {
    if ([objInput isKindOfClass:[UITextField class]]) {
      UITextField *tmpTextFile = objInput;
      if ([objInput isFirstResponder]) {
        tmpTextFile.text = data;
        if (tmpTextFile == self.packageTextField) {
          [self getPackageInfo:tmpTextFile.text];
        }
        break;
      }
    }
  }
}

- (void)createInventoryListItem {
  [self.api CreateInventoryListItem:@""
                       withPosition:self.position
                           withUser:@""
                            withQty:self.qtyTextField.text
                         withPartID:self.partIDTextField.text
                      withPackageID:self.packageTextField.text
                           withView:self.view
                              block:^(BOOL state, NSError *error) {
                                if (error == nil) {
                                  if (state) {
#warning reload data
                                  }
                                }
                              }];
}

- (void)getPackageInfo:(NSString *)package_id {
  MovementAPI *movementApi = [[MovementAPI alloc] init];
  [movementApi
      getPackageInfo:package_id
            withView:self.view
               block:^(NSMutableArray *dataArray, NSError *error) {
                 if (error == nil) {
                   NSDictionary *dictData = [dataArray mutableCopy];
                   self.partIDTextField.text = [NSString
                       stringWithFormat:@"%@",
                                        [dictData objectForKey:@"part_id"]];
                   self.fifoTextField.text = [NSString
                       stringWithFormat:@"%@", [dictData objectForKey:@"fifo"]];
                   self.qtyTextField.text = [NSString
                       stringWithFormat:@"%@", [dictData objectForKey:@"qty"]];
                 }
               }];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
  [textField resignFirstResponder];
  if (textField == self.packageTextField) {
    [self getPackageInfo:textField.text];
  }

  return NO;
}

- (void)loadData {
  self.api = [[InventoryAPI alloc] init];
  self.positionTable.delegate = self;
  self.positionTable.dataSource = self;
  [self.positionTable reloadData];
}

#pragma mark UITableView Delegate

- (NSInteger)tableView:(UITableView *)tableView
 numberOfRowsInSection:(NSInteger)section {
  return [self.positionData count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  static NSString *TableCellReuseIdentifier =
      @"InventoryListPositionReuseIdentifier";
  UITableViewCell *cell =
      [tableView dequeueReusableCellWithIdentifier:TableCellReuseIdentifier
                                      forIndexPath:indexPath];

  [self configureCell:cell forIndexPath:indexPath];

  return cell;
}

- (void)configureCell:(UITableViewCell *)cell
         forIndexPath:(NSIndexPath *)indexPath {

  InventoryListItem *inventory_list_item =
      (InventoryListItem *)self.positionData[indexPath.row];
  UILabel *partIDLabel = [cell.contentView viewWithTag:100];
  UILabel *FIFOLabel = [cell.contentView viewWithTag:200];
  UILabel *qtyLabel = [cell.contentView viewWithTag:300];

  partIDLabel.text = inventory_list_item.part_id;
  FIFOLabel.text = inventory_list_item.fifo;
  qtyLabel.text = inventory_list_item.qty;
}

- (UIView *)tableView:(UITableView *)tableView
    viewForHeaderInSection:(NSInteger)section {
  UILabel *CountLabel = [[UILabel alloc]
      initWithFrame:CGRectMake(0, 0, self.view.frame.size.width / 2, 30)];
  CountLabel.textColor = [UIColor redColor];
  CountLabel.textAlignment = NSTextAlignmentLeft;
  CountLabel.text =
      [NSString stringWithFormat:@"已盘点%ld件", [self.positionData count]];
  return CountLabel;
}

- (CGFloat)tableView:(UITableView *)tableView
    heightForHeaderInSection:(NSInteger)section {
  return 30;
}

- (BOOL)tableView:(UITableView *)tableView
    canEditRowAtIndexPath:(NSIndexPath *)indexPath {
  return YES;
}

- (void)tableView:(UITableView *)tableView
    commitEditingStyle:(UITableViewCellEditingStyle)editingStyle
     forRowAtIndexPath:(NSIndexPath *)indexPath {

  if (editingStyle == UITableViewCellEditingStyleDelete) {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@""
                                                    message:@"确认删除？"
                                                   delegate:self
                                          cancelButtonTitle:@"取消"
                                          otherButtonTitles:@"确定", nil];
    [alert show];
  }
}

- (void)alertView:(UIAlertView *)alertView
    clickedButtonAtIndex:(NSInteger)buttonIndex {
  if (buttonIndex == 1) {
    InventoryListItem *inventory_list_item =
        (InventoryListItem *)[self.positionData
            objectAtIndex:self.positionTable.indexPathForSelectedRow.row];
    [self.api DeleteInventoryListItem:inventory_list_item.ID
                             withView:self.view
                                block:^(BOOL state, NSError *error) {
                                  if (error == nil) {
                                    if (state) {
                                      [self.positionData
                                          removeObjectAtIndex:
                                              self.positionTable
                                                  .indexPathForSelectedRow.row];
                                      [UIView animateWithDuration:0.5
                                                       animations:^{
                                                         [self.positionTable
                                                                 reloadData];
                                                       }];
                                    }
                                  }
                                }];
  }
}

- (void)tableView:(UITableView *)tableView
    didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
  [self performSegueWithIdentifier:@"toPartDetail" sender:self];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little
preparation before navigation
 */
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
  if ([segue.identifier isEqualToString:@"toPartDetail"]) {
    InventoryConfirmViewController *inventoryDetailVC =
        [segue destinationViewController];
    InventoryListItem *il =
        (InventoryListItem *)
            self.positionData[self.positionTable.indexPathForSelectedRow.row];
    [il setPosition:self.position];
    inventoryDetailVC.inventory_list_item = il;
  }
}

@end
