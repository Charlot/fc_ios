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
#import "KeychainItemWrapper.h"
#import "ShiftingPrintViewController.h"
#import "CreateMovementListItemViewController.h"

@interface ShiftingDetailViewController ()
@property(strong, nonatomic) NSMutableArray *dataArray;
@property(strong, nonatomic) IBOutlet UITableView *detailTableView;
@property(nonatomic, strong) MovementAPI *api;
@property NSString *userName;
@end

@implementation ShiftingDetailViewController

- (void)viewDidLoad {
  [super viewDidLoad];
  //  UIEdgeInsets adjustForTabbarInsets = UIEdgeInsetsMake(
  //      0, 0, CGRectGetHeight(self.tabBarController.tabBar.frame) + 200, 0);
  //  self.detailTableView.contentInset = adjustForTabbarInsets;
  //  self.detailTableView.scrollIndicatorInsets = adjustForTabbarInsets;

  [self loadData];
  [self customUI];
}

//- (void)viewDidLayoutSubviews {
//  [super viewDidLayoutSubviews];
//
//  CGFloat bottomOffset = self.bottomLayoutGuide.length;
//
//  self.detailTableView.contentInset =
//      UIEdgeInsetsMake(0, 0, bottomOffset + 100, 0);
//  self.detailTableView.scrollIndicatorInsets =
//      UIEdgeInsetsMake(0, 0, bottomOffset + 100, 0);
//}

- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
  // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated {
  [super viewWillAppear:animated];
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
  [self getUser];
  //  self.detailTableView.delegate = self;
  //  self.detailTableView.dataSource = self;
  self.detailTableView.allowsMultipleSelectionDuringEditing = NO;
  self.dataArray = [[NSMutableArray alloc] init];
  self.api = [[MovementAPI alloc] init];
  //  /**
  //   *  如果是修改传过来的， 那么先获取web，然后更新本地
  //   */
  //  if ([self.fromState isEqualToString:@"web"]) {
  [self.api
      webGetMovementResources:self.movement_list_id
                     withView:self.view
                        block:^(NSMutableArray *reqeustData, NSError *error) {
                          if (error == nil) {
                            if ([reqeustData count] > 0) {
                                
                                
                                
                              /**
                               *  删除本地纪录
                               */
                              [self.api localDeleteMovementListItemByID:
                                            self.movement_list_id];
                              /**
                               *  获取web数据
                               */
                              for (int i = 0; i < [reqeustData count]; i++) {
                                Movement *movement = [[Movement alloc] init];
                                movement = (Movement *)reqeustData[i];
                                movement.user = self.userName;
                                movement.movement_list_id =
                                    self.movement_list_id;
                                [self.api createMovement:movement];
                              }
                                
                                
                              /**
                               *  查询本地数据
                               */
                              self.dataArray = [self.api
                                  queryByMovementListID:self.movement_list_id
                                       ObjectDictionary:0];
                                
                                
                                
                              [self.detailTableView reloadData];
                            }else
                            {
                                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:self.movement_list_id message:@"该移库单没有数据" delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil];
                                [alert show];
                            }
                          }
                        }];
  //  } else {
  //    self.dataArray = [self.api queryByMovementListID:self.movement_list_id
  //                                    ObjectDictionary:0];
  //    [self.detailTableView reloadData];
  //  }
}

- (void)customUI {

  self.navigationItem.leftBarButtonItem =
      [[UIBarButtonItem alloc] initWithTitle:@"继续移库"
                                       style:UIBarButtonItemStylePlain
                                      target:self
                                      action:@selector(done:)];
}

- (void)done:(id)sender {
  //  [self dismissViewControllerAnimated:YES completion:nil];
  if ([self.fromState isEqualToString:@"local"]) {
    [self.delegate backToYikuVC:self MovementListID:self.movement_list_id];

  } else {
    [self performSegueWithIdentifier:@"toCreateMovementListItemVC" sender:self];
  }
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
      stringWithFormat:@"已扫描%ld个零件", [self.dataArray count]];
  return movementCountLabel;
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
    Movement *movement =
        (Movement *)[self.dataArray objectAtIndex:indexPath.row];
    /**
     *  删除web端数据
     *
     *  @param state <#state description#>
     *  @param error <#error description#>
     *
     *  @return <#return value description#>
     */

    [self.api webDeleteMovementSource:movement.SourceID
                             withView:self.view
                                block:^(BOOL state, NSError *error) {
                                  if (error == nil) {
                                    if (state) {
                                      /**
                                       *  同步删除本地
                                       */
                                      [self.api deleteAction:movement.ID];
                                      [self.dataArray
                                          removeObjectAtIndex:indexPath.row];

                                      [UIView animateWithDuration:0.5
                                                       animations:^{
                                                         [self.detailTableView
                                                                 reloadData];
                                                       }];
                                    }
                                  }
                                }];
  }
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
  if ([segue.identifier isEqualToString:@"toMovementDetailVC"]) {
    MovementDetailViewController *movementdetail =
        segue.destinationViewController;
    movementdetail.movement =
        (Movement *)
            self.dataArray[self.detailTableView.indexPathForSelectedRow.row];
  }
  if ([segue.identifier isEqualToString:@"toPrintVC"]) {
    ShiftingPrintViewController *printVC = segue.destinationViewController;
    printVC.movement_list_id = self.movement_list_id;
  }
  if ([segue.identifier isEqualToString:@"toCreateMovementListItemVC"]) {
    CreateMovementListItemViewController *createVC =
        segue.destinationViewController;
    createVC.movementListID = self.movement_list_id;
    createVC.userName = self.userName;
    createVC.delegate = self;
  }
}

- (void)getUser {
  self.userName = @"";
  KeychainItemWrapper *keyChain =
      [[KeychainItemWrapper alloc] initWithIdentifier:@"material"
                                          accessGroup:nil];
  if ([keyChain objectForKey:(__bridge id)kSecAttrAccount]) {
    self.userName = [NSString
        stringWithFormat:@"%@",
                         [keyChain objectForKey:(__bridge id)kSecAttrAccount]];
  }
}

- (IBAction)MovementAction:(id)sender {
  /**
   *  判断移库零件大大于0
   */
  if ([self.dataArray count] > 0) {
    [self.api
        movementAction:self.movement_list_id
              employee:self.userName
               optview:self.view
                 block:^(NSString *content, NSError *error) {
                   if (error == nil) {
                     if ([content isEqualToString:@"1"]) {
                       [self performSegueWithIdentifier:@"toPrintVC"
                                                 sender:self];

                     } else {
                       [self performSegueWithIdentifier:@"toCompleteHistoryVC"
                                                 sender:self];
                       //                     [self.delegate
                       //                     failureToMain:self];
                     }
                   }
                 }];

  }
  /**
   *  小于0做删除单处理
   */
  else {
    [self.api
        deleteMovementList:self.movement_list_id
                  withView:self.view
                     block:^(NSString *contentString, NSError *error) {

                       [self performSegueWithIdentifier:@"toCompleteHistoryVC"
                                                 sender:self];

                     }];
  }
}

- (void)backToShiftingDetail:
            (CreateMovementListItemViewController *)viewController
              MovementListID:(NSString *)mlid {
  self.movement_list_id = mlid;
  [self loadData];
}
@end
