//
//  ScanCargoItemViewController.m
//  Material
//
//  Created by wayne on 17/2/10.
//  Copyright © 2017年 brilliantech. All rights reserved.
//

#import "ScanCargoItemViewController.h"
#import "SelectCargoListItemInfoTableViewCell.h"
#import "AFNetOperate.h"
#import "SelectedCargoItemInfoModel.h"
@interface ScanCargoItemViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITextField *scanInputTextField;
@property (weak, nonatomic) IBOutlet UITableView *cargoItemTableView;

@property (nonatomic,strong) NSArray *itemInfoArray;
@end

@implementation ScanCargoItemViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"择货";
    self.cargoItemTableView.delegate = self;
    self.cargoItemTableView.dataSource = self;
    
    [self getCargoItemInfo];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Http server
- (void)getCargoItemInfo {
    AFNetOperate *AFNet = [[AFNetOperate alloc] init];
    AFHTTPRequestOperationManager *manager = [AFNet generateManager:self.view];
    [manager GET:[AFNet select_pick_info]
      parameters:@{@"id":@"PI1481595038768"}
         success:^(AFHTTPRequestOperation *operation, id responseObject) {
             [AFNet.activeView stopAnimating];
             
             if ([responseObject count] > 0) {
                 NSArray *inventoryArray = responseObject;
                 self.itemInfoArray = inventoryArray;
                 NSLog(@"%@",inventoryArray);
                 [self.cargoItemTableView reloadData];
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
    
    return self.itemInfoArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *reuseIdentifier = @"SelectCargoListItemInfoTableViewCell";
    SelectCargoListItemInfoTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier];
    SelectedCargoItemInfoModel *itemInfoModel = [[SelectedCargoItemInfoModel alloc] initWithObject:self.itemInfoArray[indexPath.row]];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:reuseIdentifier owner:self options:nil] lastObject];
        
    }
    cell.SelectItemInfoNameLabel.text = itemInfoModel.modelItemInfoPackage_id;
    cell.SelectItemInfoPositionLabel.text = itemInfoModel.modelItemInfoPosition;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    if (cell.accessoryType == UITableViewCellAccessoryNone) {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    }else{
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
}
@end
