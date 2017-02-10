//
//  CargoItemTableViewController.m
//  Material
//
//  Created by wayne on 17/2/10.
//  Copyright © 2017年 brilliantech. All rights reserved.
//

#import "CargoItemTableViewController.h"
#import "SelectCargoListItemTableViewCell.h"
#import "AFNetOperate.h"
#import "SelectCargoItemModel.h"
@interface CargoItemTableViewController ()
@property (nonatomic,strong)NSArray *cargoItemArray;
@end

@implementation CargoItemTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"择货项";
    [self getCargoItems];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



#pragma mark - Http server
- (void)getCargoItems {
    AFNetOperate *AFNet = [[AFNetOperate alloc] init];
    AFHTTPRequestOperationManager *manager = [AFNet generateManager:self.view];
    [manager GET:[AFNet select_pick_items]
      parameters:@{@"id":@"P1481595038675"}
         success:^(AFHTTPRequestOperation *operation, id responseObject) {
             [AFNet.activeView stopAnimating];
             
             if ([responseObject count] > 0) {
                 NSArray *inventoryArray = responseObject;
                 self.cargoItemArray = inventoryArray;
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
    
    return self.cargoItemArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *reuseIdentifier = @"SelectCargoListItemTableViewCell";
    SelectCargoItemModel *itemModel = [[SelectCargoItemModel alloc] initWithObject:self.cargoItemArray[indexPath.row]];
    SelectCargoListItemTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier];
    
    if (cell == nil) {
       cell = [[[NSBundle mainBundle] loadNibNamed:reuseIdentifier owner:self options:nil] lastObject];
        
    }
    cell.SelectItemNameLabel.text = itemModel.modelItemName;
    cell.SelectItemQuantityLabel.text = itemModel.modelItemQuantity;
    cell.SelectItemBoxQuantityLabel.text = itemModel.modelItemBoxQuantity;
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self performSegueWithIdentifier:@"toScanItemView" sender:self];
}

@end
