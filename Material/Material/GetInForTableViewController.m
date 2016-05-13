//
//  GetInForTableViewController.m
//  Material
//
//  Created by wayne on 16/5/13.
//  Copyright © 2016年 brilliantech. All rights reserved.
//

#import "GetInForTableViewController.h"
#import "RuKuDetailTableViewController.h"
#import "TuoTableViewController.h"
#import "TuoStore.h"
#import "XiangStore.h"
#import "KeychainItemWrapper.h"
#import "Tuo.h"
#import "KeychainItemWrapper.h"
#import "AFNetOperate.h"
#import "XiangTableViewCell.h"
#import "Xiang.h"
#import "MJRefresh.h"
#import <AudioToolbox/AudioToolbox.h>
@interface GetInForTableViewController ()<UITextFieldDelegate,UITableViewDelegate,UITableViewDataSource,CaptuvoEventsProtocol,UIAlertViewDelegate>
@property(strong,nonatomic)NSString *listNumber;
- (IBAction)creatRuKuList:(id)sender;
@property (strong,nonatomic)UIAlertView *alert;
@property(strong,nonatomic)NSString *rukuList;
@property (strong,nonatomic)Xiang *xianglist;

@end

@implementation GetInForTableViewController



- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.tuo=[[Tuo alloc] init];
    self.userID=@"";
    KeychainItemWrapper *keyChain =
    [[KeychainItemWrapper alloc] initWithIdentifier:@"material"
                                        accessGroup:nil];
    if ([keyChain objectForKey:(__bridge id)kSecAttrAccount]) {
        self.userID = [NSString
                       stringWithFormat:@"%@",
                       [keyChain objectForKey:(__bridge id)kSecAttrAccount]];
    }
    
    UINib *nib=[UINib nibWithNibName:@"TuoTableViewCell" bundle:nil];
    [self.tableView registerNib:nib forCellReuseIdentifier:@"tuoCell"];
    
    
}
-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    //得到数据
    self.navigationItem.leftBarButtonItem.title=@"";
    [self customController];
    
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)customController {
    
    self.tableView.header =
    [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [self loadData];
    }];
    [self.tableView.header beginRefreshing];
}
#pragma mark - 筛选显示的状态
////////////////////////this
-(void)loadData
{
    AFNetOperate *AFNet = [[AFNetOperate alloc] init];
    AFHTTPRequestOperationManager *manager = [AFNet generateManager:self.view];

    [manager GET:[AFNet getMovementResources]
      parameters:@{
                   @"movement_list_id" : self.listID
                   }
         success:^(AFHTTPRequestOperation *operation, id responseObject) {
             [AFNet.activeView stopAnimating];
             if ([responseObject[@"result"] integerValue] == 1) {
                     [AFNet.activeView stopAnimating];
//                 [self.dataArray removeAllObjects];
                 NSMutableArray *xiangList=responseObject[@"content"];
                 for(int i=0;i<xiangList.count;i++){
                     Xiang *data=[[Xiang alloc] initWithObject:xiangList[i]];
                     [self.tuo.xiang addObject:data];
                 }
                 
                 
                 [self.tableView.header endRefreshing];
                 [self.tableView reloadData];
                 
             } else {
                 [AFNet alert:responseObject[@"content"]];
             }
         }
         failure:^(AFHTTPRequestOperation *operation, NSError *error) {
             [AFNet.activeView stopAnimating];
             [AFNet alert:[NSString
                           stringWithFormat:@"%@", [error localizedDescription]]];
         }];}

-(void)allState
{
}
#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
//    return self.tuo.xiang.count;
    return [self.tuo.xiang count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
     XiangTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"xiangCell" forIndexPath:indexPath];
    Xiang *xiang=[self.tuo.xiang objectAtIndex:indexPath.row];
    cell.partNumber.text=xiang.partNr;
    cell.key.text=xiang.packageId;
    cell.quantity.text=xiang.qty;
    cell.position.text=xiang.position;
    cell.date.text=xiang.fifo;
    cell.stateLabel.text=@"待入库";
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    [cell.stateLabel setTextColor:[UIColor redColor]];
    
    if(xiang.state==0){
        [cell.stateLabel setTextColor:[UIColor redColor]];
    }
    
    else if(xiang.state==1 || xiang.state==2){
        [cell.stateLabel setTextColor:[UIColor blueColor]];
    }
    else if(xiang.state==3){
        [cell.stateLabel setTextColor:[UIColor colorWithRed:87.0/255.0 green:188.0/255.0 blue:96.0/255.0 alpha:1.0]];
    }
    else if(xiang.state==4){
        [cell.stateLabel setTextColor:[UIColor orangeColor]];
    }

    //    cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
    return cell;
}

//unwind
//- (IBAction)unwindToTuoTable:(UIStoryboardSegue *)unwindSegue{
//    [self.tableView reloadData];
//    
//}
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        //        delete_movement_source
        // Delete the row from the data source
        int row=indexPath.row;
        Xiang *tuoRetain=[[[Xiang alloc] init] copyMe:[self.tuo.xiang objectAtIndex:row]];
        NSString *ID=[NSString stringWithFormat:@"%d", tuoRetain.moveSourceId];
        AFNetOperate *AFNet=[[AFNetOperate alloc] init];
        AFHTTPRequestOperationManager *manager=[AFNet generateManager:self.view];
        [manager DELETE:[AFNet delete_movement_source]
             parameters:@{
                          @"movement_source_id":ID
                          }
                success:^(AFHTTPRequestOperation *operation, id responseObject) {
                    [AFNet.activeView stopAnimating];
                    if([responseObject[@"result"] integerValue]==1){
                        self.alert= [[UIAlertView alloc]initWithTitle:@"成功"
                                                              message:@"删除成功！"
                                                             delegate:self
                                                    cancelButtonTitle:nil
                                                    otherButtonTitles:nil];
                        [NSTimer scheduledTimerWithTimeInterval:0.9f
                                                         target:self
                                                       selector:@selector(dissmissAlert:)
                                                       userInfo:nil
                                                        repeats:NO];
                        [self.tuo.xiang removeObjectAtIndex:indexPath.row];
                        [self.tableView reloadData];
                        [self.alert show];
                        
                    }
                    else{
                        [AFNet alert:responseObject[@"content"]];
                        [self.alert show];
                    }
                    
                }
                failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                    [AFNet.activeView stopAnimating];
                }
         ];
        
        
    }
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
//    int row = indexPath.row;
//    MovementList *rukuList = (MovementList *)self.dataArray [indexPath.row];
//    //    Xiang *Retain = [[[Xiang alloc]init] copyMe:[self.dataArray objectAtIndex:row]];
//    self.rukuList= [NSString stringWithFormat:@"%@",rukuList.ID];
//    [self performSegueWithIdentifier:@"rukuDetail" sender:@{@"rukuDetail":rukuList}];

}
-(BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    //    id vewctl=segue.destinationViewController;
//    if ([segue.identifier isEqualToString:@"rukuDetail"] ) {
//        id o=segue.destinationViewController;
//        RuKuDetailTableViewController *scan=segue.destinationViewController;
//        scan.listID=self.rukuList;
//        scan.userID=self.userID;
//    }else{
//        TuoScanViewController *scan=segue.destinationViewController;
//        scan.type=@"ruku";
//        scan.userID=self.userID;
//        scan.hideCheckButton=YES;
//    }

}

- (IBAction)creatRuKuList:(id)sender {
    AFNetOperate *AFNet=[[AFNetOperate alloc] init];
    AFHTTPRequestOperationManager *manager=[AFNet generateManager:self.view];
    [manager POST:[AFNet create_package_enter_stock]
       parameters:@{@"movement_list_id":self.listID,@"employee_id":self.userID}
     
          success:^(AFHTTPRequestOperation *operation, id responseObject) {
              [AFNet.activeView stopAnimating];
              if([responseObject[@"result"] integerValue]==1){
                  self.alert= [[UIAlertView alloc]initWithTitle:@"成功"
                                                        message:@"已完成全部入库"
                                                       delegate:self
                                              cancelButtonTitle:@"确定"
                                              otherButtonTitles:nil];
                  
                  AudioServicesPlaySystemSound(1012);
                  
                  [self.alert show];
                  [self.tableView reloadData];
              }else{
                  UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"警告"
                                                                message:@"失败，请检查是否有入库项"
                                                               delegate:self
                                                      cancelButtonTitle:@"不继续"
                                                      otherButtonTitles:nil];
                  [alert show];
                  
              }
          }
          failure:^(AFHTTPRequestOperation *operation, NSError *error) {
              [AFNet.activeView stopAnimating];
              UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"警告"
                                                            message:@"没有绑定任何箱，需要继续吗？"
                                                           delegate:self
                                                  cancelButtonTitle:@"不继续"
                                                  otherButtonTitles:@"继续操作", nil];
              [alert show];
          }];
    
}

@end
