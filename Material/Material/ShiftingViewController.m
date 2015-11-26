//
//  ShiftingViewController.m
//  Material
//
//  Created by ryan on 11/18/15.
//  Copyright © 2015 brilliantech. All rights reserved.
//

#import "ShiftingViewController.h"
#import "AFNetOperate.h"
#import "KeychainItemWrapper.h"
#import "MovementList.h"
#import "YikuViewController.h"
#import "MJRefresh.h"
#import "MovementListFinishViewController.h"
#import "MovementDetailViewController.h"

@interface ShiftingViewController ()
@property NSString *userName;
@property(strong, nonatomic) IBOutlet UITableView *historyTableView;
@property(strong, nonatomic) NSMutableArray *dataArray;
@property NSString *movementListID;
@end

@implementation ShiftingViewController

- (void)viewDidLoad {
  [super viewDidLoad];
  // Do any additional setup after loading the view.
  [self customController];
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

- (void)viewWillAppear:(BOOL)animated {

  [super viewWillAppear:animated];

  //
  //  NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
  //  [formatter setDateFormat:@"yyyy-MM-dd'T'00:00:00ZZZZZ"];
  //  NSString *startDate = [formatter stringFromDate:[NSDate date]];
  //  [formatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ssZZZZZ"];
  //  NSString *endDate = [formatter stringFromDate:[NSDate date]];
}

- (void)loadData {
  AFNetOperate *AFNet = [[AFNetOperate alloc] init];
  [AFNet.activeView stopAnimating];
  AFHTTPRequestOperationManager *manager = [AFNet generateManager:self.view];
  [AFNet.activeView stopAnimating];
  [manager GET:[AFNet GetMovementList]
      parameters:@{
        @"user_id" : self.userName
      }
      success:^(AFHTTPRequestOperation *operation, id responseObject) {
        //        NSLog(@"the request GetMovementList is %@", responseObject);
        [AFNet.activeView stopAnimating];
        if ([responseObject[@"result"] integerValue] == 1) {

          NSArray *resultArray = responseObject[@"content"];
          for (int i = 0; i < resultArray.count; i++) {
            MovementList *ml =
                [[MovementList alloc] initWithObject:resultArray[i]];
            [self.dataArray addObject:ml];
          }
          [self.historyTableView.header endRefreshing];

          [self.historyTableView reloadData];

        } else {
          [AFNet alert:responseObject[@"content"]];
        }
      }
      failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [AFNet.activeView stopAnimating];
        [AFNet alert:[NSString
                         stringWithFormat:@"%@", [error localizedDescription]]];
      }];
}

- (void)customController {

  //    [backButton setBackgroundImage:backImage forState:UIControlStateNormal];
  //  [backButton setTitle:@"取消" forState:UIControlStateNormal];
  //  [backButton addTarget:self
  self.dataArray = [[NSMutableArray alloc] init];

  self.userName = @"";
  KeychainItemWrapper *keyChain =
      [[KeychainItemWrapper alloc] initWithIdentifier:@"material"
                                          accessGroup:nil];
  if ([keyChain objectForKey:(__bridge id)kSecAttrAccount]) {
    self.userName = [NSString
        stringWithFormat:@"%@",
                         [keyChain objectForKey:(__bridge id)kSecAttrAccount]];
  }
  self.historyTableView.header =
      [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [self loadData];
      }];
  [self.historyTableView.header beginRefreshing];
  self.navigationItem.hidesBackButton = TRUE;
  self.historyTableView.delegate = self;
  self.historyTableView.dataSource = self;
}

- (void)back:(UIBarButtonItem *)sender {
  // Perform your custom actions
  // ...
  // Go back to the previous ViewController
  [self.navigationController popViewControllerAnimated:YES];
}

- (NSInteger)tableView:(UITableView *)tableView
 numberOfRowsInSection:(NSInteger)section {
  return self.dataArray.count;
}

#pragma mark UITableView Delegate

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  static NSString *TableCellReuseIdentifier =
      @"historyTableCellReuseIdentifier";
  UITableViewCell *cell =
      [tableView dequeueReusableCellWithIdentifier:TableCellReuseIdentifier
                                      forIndexPath:indexPath];
  [self configureCell:cell forIndexPath:indexPath];

  return cell;
}

- (void)configureCell:(UITableViewCell *)cell
         forIndexPath:(NSIndexPath *)indexPath {

  MovementList *movementList = (MovementList *)self.dataArray[indexPath.row];
  UILabel *IDLabel = [cell.contentView viewWithTag:100];
  UILabel *countLabel = [cell.contentView viewWithTag:200];
  UILabel *stateLabel = [cell.contentView viewWithTag:300];

  IDLabel.text = movementList.ID;
  countLabel.text = [NSString stringWithFormat:@"%@", movementList.count];
  if ([movementList.state isEqualToString:@"成功"]) {
    stateLabel.text = @"移库成功";
  } else {
    stateLabel.text = @"移库失败";
  }
}

- (void)tableView:(UITableView *)tableView
    didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
  MovementList *movement_list =
      (MovementList *)[self.dataArray objectAtIndex:indexPath.row];
  self.movementListID = movement_list.ID;
  if ([movement_list.state isEqualToString:@"成功"]) {
    [self performSegueWithIdentifier:@"toCompleteMovementListVC" sender:self];
  } else {
    [self performSegueWithIdentifier:@"toMovementListForFailure" sender:self];
  }
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
  if ([segue.identifier isEqualToString:@"toYikuVC"]) {
    YikuViewController *yk = segue.destinationViewController;
    yk.movementListID = self.movementListID;
  }
  if ([segue.identifier isEqualToString:@"toCompleteMovementListVC"]) {
    MovementListFinishViewController *mlFinishVC =
        segue.destinationViewController;
    mlFinishVC.movement_list_id = self.movementListID;
  }
  if ([segue.identifier isEqualToString:@"toMovementListForFailure"]) {
    ShiftingDetailViewController *detailVC = segue.destinationViewController;
    detailVC.movement_list_id = self.movementListID;
  }
}

- (IBAction)createMovementList:(id)sender {
  [self createIDMovement];
}

/**
 *  获取移库清单号
 */
- (void)createIDMovement {

  AFNetOperate *AFNet = [[AFNetOperate alloc] init];
  AFHTTPRequestOperationManager *manager = [AFNet generateManager:self.view];
  [manager POST:[AFNet CreateMovementList]
      parameters:@{
        @"user_id" : self.userName,
        @"remarks" : @""
      }
      success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"the request %@", responseObject);
        [AFNet.activeView stopAnimating];
        if ([responseObject[@"result"] integerValue] == 1) {

          NSDictionary *dic = responseObject[@"content"];
          self.movementListID = [dic objectForKey:@"id"];
          NSLog(@"the movement id is %@", self.movementListID);
          [self performSegueWithIdentifier:@"toYikuVC" sender:self];
        } else {
          [AFNet alert:responseObject[@"content"]];
        }

      }
      failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [AFNet.activeView stopAnimating];
        NSLog(@"%@", error.description);
        [AFNet alert:[NSString
                         stringWithFormat:@"%@", [error localizedDescription]]];
      }];
}

@end
