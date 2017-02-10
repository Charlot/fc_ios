//
//  SelectedCargoTableViewController.m
//  Material
//
//  Created by wayne on 17/2/10.
//  Copyright © 2017年 brilliantech. All rights reserved.
//

#import "SelectedCargoTableViewController.h"
#import "AFNetOperate.h"
#import "SelectCargoListTableViewCell.h"
#import "SelectCargoListModel.h"
@interface SelectedCargoTableViewController ()
@property (nonatomic,strong) NSArray *cargoListArray;
@end

@implementation SelectedCargoTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"择货单";

    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self getCargoUndoneList];
}
#pragma  mark --http Server
- (void)getCargoUndoneList {
    AFNetOperate *AFNet = [[AFNetOperate alloc] init];
    AFHTTPRequestOperationManager *manager = [AFNet generateManager:self.view];
    [manager GET:[AFNet select_undone_list]
      parameters:nil
         success:^(AFHTTPRequestOperation *operation, id responseObject) {
             [AFNet.activeView stopAnimating];

             if ([responseObject count] > 0) {
                 NSArray *inventoryArray = responseObject;
                 self.cargoListArray = inventoryArray;
                 NSLog(@"%@",inventoryArray);
                 [self.tableView reloadData];
             } else {
                 [AFNet alert:@"空"];
             }
         }
         failure:^(AFHTTPRequestOperation *operation, NSError *error) {
             [AFNet.activeView stopAnimating];
             [AFNet alert:[NSString
                           stringWithFormat:@"%@", [error localizedDescription]]];
         }];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return self.cargoListArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *reuseIdentifier = @"SelectCargoListTableViewCell";
    SelectCargoListModel *listModel = [[SelectCargoListModel alloc] initWithObject:self.cargoListArray[indexPath.row]];
    
    SelectCargoListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier];
    
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:reuseIdentifier owner:self options:nil] lastObject];
        
    }
    cell.CargoListNameLabel.text = listModel.modelListName;
//    cell.WhouseIDLabel.text = listModel.modelListWhouse;
    cell.StateLabel.text = listModel.modelListState;
    cell.RemarkLabel.text = listModel.modelListRemark;
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self performSegueWithIdentifier:@"toItemView" sender:self];
}
//-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
//{
//    UIViewController *destinationController = [segue destinationViewController];
//
//}

@end
