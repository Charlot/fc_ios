//
//  InventoryHistroyViewController.m
//  Material
//
//  Created by ryan on 11/23/15.
//  Copyright © 2015 brilliantech. All rights reserved.
//

#import "InventoryHistroyViewController.h"
#import "InventoryAPI.h"
#import "KeychainItemWrapper.h"
#import "InventoryList.h"
#import "Captuvo.h"
#import <AudioToolbox/AudioToolbox.h>
#import "InventoryPositionViewController.h"
#import "MJRefresh.h"

@interface InventoryHistroyViewController ()
- (IBAction)tapViewEvent:(id)sender;
@property(strong, nonatomic) NSMutableArray *dataArray;
@property(strong, nonatomic) IBOutlet UITableView *historyTable;
@property(strong, nonatomic) IBOutlet UITextField *positionTextField;
@property(strong, nonatomic) NSMutableArray *positionDataArray;
@property NSString *position;
@property(strong, nonatomic) IBOutlet UISearchBar *searchBar;
@property NSString *userName;
@end

@implementation InventoryHistroyViewController

- (void)viewDidLoad {
  [super viewDidLoad];
  self.searchBar.delegate = self;
  self.searchBar.showsCancelButton = YES;
  self.positionTextField.delegate = self;
  //  self.dataArray = [[NSMutableArray alloc] init];
  self.positionDataArray = [[NSMutableArray alloc] init];
  //  [self customUI];
  //  UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]
  //      initWithTarget:self
  //              action:@selector(dismissKeyboard)];
  //  [self.view addGestureRecognizer:tap];
  MJRefreshHeader *header = [MJRefreshHeader headerWithRefreshingBlock:^{
    [self loadData:@"0"];
  }];

  self.scrollView.header = header;
}

- (NSMutableArray *)dataArray {
  if (!_dataArray) {
    _dataArray = [[NSMutableArray alloc] init];
  }
  return _dataArray;
}

- (UIScrollView *)scrollView {
  return self.historyTable;
}

- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
  // Dispose of any resources that can be recreated.
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
  [self.searchBar resignFirstResponder];
  [self.historyTable.header beginRefreshing];
  [self loadData:@"0"];
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
  [self.searchBar resignFirstResponder];
  [self searchPosition:searchBar.text];
}

- (void)searchPosition:(NSString *)searchText {
  InventoryAPI *api = [[InventoryAPI alloc] init];
  [api getInventoryListByPosition:self.inventory_list_id
                     withPosition:searchText
                         withUser:self.userName
                         withView:self.view
                            block:^(NSMutableArray *dataArray, NSError *error) {
                              if (error == nil) {
                                if ([dataArray count] > 0) {
                                  [self.dataArray removeAllObjects];

                                  for (int i = 0; i < [dataArray count]; i++) {
                                    [self.dataArray addObject:dataArray[i]];
                                  }
                                  [self.historyTable reloadData];
                                }
                              }
                            }];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little
preparation before navigation
 */
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {

  if ([segue.identifier isEqualToString:@"toPositionItemVC"]) {
    InventoryPositionViewController *positionVC =
        [segue destinationViewController];
    //    [positionVC.positionData removeAllObjects];
    //    positionVC.positionData = self.positionDataArray;
    positionVC.position = self.position;
    positionVC.inventory_list_id = self.inventory_list_id;
    positionVC.userName = self.userName;
  }
}

- (void)decoderDataReceived:(NSString *)data {
  if ([self.positionTextField isFirstResponder]) {
    self.positionTextField.text = data;
    self.position = self.positionTextField.text;
    [self getPositionInfo:data];
  }
  if ([self.searchBar isFirstResponder]) {
    self.searchBar.text = data;
    [self searchPosition:data];
  }
}

- (void)getPositionInfo:(NSString *)position {
  self.position = position;

  InventoryAPI *api = [[InventoryAPI alloc] init];
  [api getInventoryListItem:self.inventory_list_id
               withPosition:position
                   withUser:self.userName
                   withPage:@"0"

                   withView:self.view
                      block:^(NSMutableArray *dataArray, NSError *error) {
                        if (error == nil) {
                          self.positionTextField.text = @"";
                          [self performSegueWithIdentifier:@"toPositionItemVC"
                                                    sender:self];
                        }
                      }];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
  [textField resignFirstResponder];
  self.position = textField.text;

  [self getPositionInfo:textField.text];
  //  [self performSegueWithIdentifier:@"toPositionItemVC" sender:self];
  return NO;
}

- (void)viewWillAppear:(BOOL)animated {
  [super viewWillAppear:animated];
  [[Captuvo sharedCaptuvoDevice] addCaptuvoDelegate:self];
  [self customUI];
}
- (void)viewWillDisappear:(BOOL)animated {
  [super viewWillDisappear:animated];
  [[Captuvo sharedCaptuvoDevice] removeCaptuvoDelegate:self];
}

- (void)customUI {
  [self.positionTextField becomeFirstResponder];
  [self loadUser];
  [self.scrollView.header beginRefreshing];
}

- (void)loadData:(NSString *)page {
  InventoryAPI *api = [[InventoryAPI alloc] init];

  [api getInventoryListPosition:self.inventory_list_id
                       withUser:self.userName
                       withPage:page

                       withView:self.view
                          block:^(NSMutableArray *requestTableArray,
                                  NSError *error) {
                            if (error == nil) {
                              if ([requestTableArray count] > 0) {
                                [self.dataArray removeAllObjects];
                                for (int i = 0; i < [requestTableArray count];
                                     i++) {
                                  [self.dataArray
                                      addObject:requestTableArray[i]];
                                }
                              }
                              [self.historyTable reloadData];
                              [self.historyTable.header endRefreshing];
                            }
                          }];
}

- (void)loadUser {
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

#pragma mark UITableView Delegate
- (NSInteger)tableView:(UITableView *)tableView
 numberOfRowsInSection:(NSInteger)section {
  return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  static NSString *TableCellReuseIdentifier =
      @"InventoryHistroyReuseIdentifier";
  UITableViewCell *cell =
      [tableView dequeueReusableCellWithIdentifier:TableCellReuseIdentifier
                                      forIndexPath:indexPath];
  [self configureCell:cell forIndexPath:indexPath];

  return cell;
}

- (void)configureCell:(UITableViewCell *)cell
         forIndexPath:(NSIndexPath *)indexPath {

  InventoryList *il = (InventoryList *)self.dataArray[indexPath.row];
  UILabel *IDLabel = [cell.contentView viewWithTag:100];
  UILabel *countLabel = [cell.contentView viewWithTag:200];

  IDLabel.text = il.position;
  countLabel.text = [NSString stringWithFormat:@"%@", il.count];
}

- (void)tableView:(UITableView *)tableView
    didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
  InventoryList *il = (InventoryList *)self.dataArray[indexPath.row];
  self.position = il.position;
  [self getPositionInfo:self.position];
  //  [self performSegueWithIdentifier:@"toPositionItemVC" sender:self];
}

- (void)dismissKeyboard {
  NSArray *subviews = [self.view subviews];
  for (id objInput in subviews) {
    if ([objInput isKindOfClass:[UITextField class]]) {
      UITextField *theTextField = objInput;
      if ([objInput isFirstResponder]) {
        [theTextField resignFirstResponder];
      }
    }
  }
}

- (IBAction)tapViewEvent:(id)sender {
  [self dismissKeyboard];
}
@end
