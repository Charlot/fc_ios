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
#import <AudioToolbox/AudioToolbox.h>
#import "SelectedCargoItemInfoModel.h"
@interface ScanCargoItemViewController ()<UITextFieldDelegate,UITableViewDelegate,UITableViewDataSource,CaptuvoEventsProtocol>
@property (weak, nonatomic) IBOutlet UITextField *scanInputTextField;
@property (weak, nonatomic) IBOutlet UITableView *cargoItemTableView;

@property (nonatomic,strong) NSArray *itemInfoArray;
@end

@implementation ScanCargoItemViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initDelegate];
    [self.scanInputTextField becomeFirstResponder];
//    [self getCargoItemInfo];
    [self createData];

    

}

-(void)createData
{
    self.itemInfoArray = [[NSArray alloc] initWithObjects:@"0",@"1",@"2",@"3",@"4",@"5",@"6",@"7",@"8",@"9", nil];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [[Captuvo sharedCaptuvoDevice] addCaptuvoDelegate:self];
}
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [[Captuvo sharedCaptuvoDevice] removeCaptuvoDelegate:self];
}
-(void)initDelegate
{
    self.title = @"择货";
    
    self.cargoItemTableView.delegate = self;
    self.cargoItemTableView.dataSource = self;
    
    self.scanInputTextField.delegate = self;
    self.scanInputTextField.inputView = [[UIView alloc]initWithFrame:CGRectZero];
    
}

-(void)decoderDataReceived:(NSString *)data
{
    NSArray *subviews = [self.view subviews];
    for (id objInput in subviews) {
        if ([objInput isKindOfClass:[UITextField class]]) {
            UITextField *tmpTextFile = objInput;
            if ([objInput isFirstResponder]) {
                tmpTextFile.text = data;
                [self searchCargoByScan:tmpTextFile.text];
                break;
            }
        }
    }
}

#pragma mark -- find data
-(void)searchCargoByScan:(NSString *)packageNr
{
    SelectCargoListItemInfoTableViewCell *cell;
    NSIndexPath *indexPath;

    for (int i = 0; i < self.itemInfoArray.count; i++) {
        indexPath = [NSIndexPath indexPathForRow:i inSection:0];
        cell = [self.cargoItemTableView cellForRowAtIndexPath:indexPath];
        if ([cell.SelectItemInfoNameLabel.text isEqualToString:packageNr]) {
            if (cell.accessoryType == UITableViewCellAccessoryNone) {
                cell.accessoryType = UITableViewCellAccessoryCheckmark;
            }else{
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil
                                                                message:@"已选择"
                                                               delegate:self
                                                      cancelButtonTitle:@"确定"
                                                      otherButtonTitles:nil];
                [alert show];
            }
            break;
        }
    }
}
#pragma mark -- Http server
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
//    SelectedCargoItemInfoModel *itemInfoModel = [[SelectedCargoItemInfoModel alloc] initWithObject:self.itemInfoArray[indexPath.row]];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:reuseIdentifier owner:self options:nil] lastObject];
        
    }
//    cell.SelectItemInfoNameLabel.text = itemInfoModel.modelItemInfoPackage_id;
//    cell.SelectItemInfoPositionLabel.text = itemInfoModel.modelItemInfoPosition;
    cell.SelectItemInfoNameLabel.text = self.itemInfoArray[indexPath.row];
    
    cell.SelectItemInfoPositionLabel.text = @"hah";
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
