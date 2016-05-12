//
//  TuoTableViewController.m
//  Material
//
//  Created by wayne on 14-6-5.
//  Copyright (c) 2014年 brilliantech. All rights reserved.
//
#import "RuKuTableTableViewController.h"
#import "RuKuDetailTableViewController.h"
#import "TuoTableViewController.h"
#import "TuoStore.h"
#import "XiangStore.h"
#import "Tuo.h"
#import "KeychainItemWrapper.h"
#import "TuoEditViewController.h"
#import "TuoScanViewController.h"
#import "AFNetOperate.h"
#import "XiangTableViewCell.h"
#import "Xiang.h"
#import "TuoTableViewCell.h"
#import "MJRefresh.h"
#import "MovementList.h"
#import <AudioToolbox/AudioToolbox.h>
@interface RuKuTableTableViewController ()
@property(strong,nonatomic)NSString *listNumber;
@property(nonatomic,strong)TuoStore *tuoStore;
@property (nonatomic , strong) XiangStore *xiangStore;
@property(strong, nonatomic) NSMutableArray *dataArray;
@property NSString *movementListID;
- (IBAction)creatRuKuList:(id)sender;

@property(strong,nonatomic)NSString *userID;
@property (strong,nonatomic)UIAlertView *alert;
@property(strong,nonatomic)NSString *rukuList;

@end

@implementation RuKuTableTableViewController



- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.tuo=[[Tuo alloc] init];
    self.dataArray = [[NSMutableArray alloc] init];
    self.userID=@"";
    KeychainItemWrapper *keyChain =
    [[KeychainItemWrapper alloc] initWithIdentifier:@"material"
                                        accessGroup:nil];
    if ([keyChain objectForKey:(__bridge id)kSecAttrAccount]) {
        self.userID = [NSString
                         stringWithFormat:@"%@",
                         [keyChain objectForKey:(__bridge id)kSecAttrAccount]];
    }
//    XiangStore *xiangStore=[[XiangStore alloc] init];
//    xiangStore.xiangArray=[[NSMutableArray alloc] init];
   
//    self.tableView.delegate=self;
//    self.tableView.dataSource=self;
    
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
    
    //    [backButton setBackgroundImage:backImage forState:UIControlStateNormal];
    //  [backButton setTitle:@"取消" forState:UIControlStateNormal];
    //  [backButton addTarget:self
    self.tableView.header =
    [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [self selfState];
    }];
    [self.tableView.header beginRefreshing];
}
#pragma mark - 筛选显示的状态
////////////////////////this
-(void)selfState
{
    TuoStore *tuoStore=[[TuoStore alloc] init];
    tuoStore.listArray=[[NSMutableArray alloc] init];
    AFNetOperate *AFNet = [[AFNetOperate alloc] init];
    AFHTTPRequestOperationManager *manager = [AFNet generateManager:self.view];
    [AFNet.activeView stopAnimating];
    [manager GET:[AFNet GetMovementList]
      parameters:@{
                   @"user_id" : self.userID
                   }
         success:^(AFHTTPRequestOperation *operation, id responseObject) {
             [AFNet.activeView stopAnimating];
             if ([responseObject[@"result"] integerValue] == 1) {
                 [self.dataArray removeAllObjects];

                 NSArray *resultArray = responseObject[@"content"];
             
                 for (int i = 0; i < resultArray.count; i++) {
                     MovementList *ml =[[MovementList alloc] initWithObject:resultArray[i]];
                     [self.dataArray addObject:ml];
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
   return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
   
    MovementList *movementList = (MovementList *)self.dataArray [indexPath.row];
    TuoTableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:@"tuoCell" forIndexPath:indexPath];
    cell.idLabel.text=movementList.ID;
    cell.departmentLabel.text=@"入库";
    cell.agentLabel.text=self.userID;
    cell.sumPackageLabel.text=@"nil";
    if (![movementList.state isEqualToString:@"成功"]) {
        cell.stateLabel.text = @"未入库";
    } else {
        cell.stateLabel.text = @"已入库";
    }
//    cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
    return cell;
}

//unwind
- (IBAction)unwindToTuoTable:(UIStoryboardSegue *)unwindSegue{
    [self.tableView reloadData];
    
}
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
//    if (editingStyle == UITableViewCellEditingStyleDelete) {
//        // Delete the row from the data source
//        
//        int row=indexPath.row;
//        Tuo *tuoRetain=[[[Tuo alloc] init] copyMe:[self.tuoStore.tuoList objectAtIndex:row]];
//        
//        
//        dispatch_queue_t deleteRow=dispatch_queue_create("com.delete.row.pptalent", NULL);
//        dispatch_async(deleteRow, ^{
//            NSString *ID=[tuoRetain ID];
//            AFNetOperate *AFNet=[[AFNetOperate alloc] init];
//            AFHTTPRequestOperationManager *manager=[AFNet generateManager:self.view];
//            dispatch_async(dispatch_get_main_queue(), ^{
//                [AFNet.activeView stopAnimating];
//            });
//            [manager DELETE:[AFNet DeleteMovementList]
//                 parameters:@{@"movement_list_id":ID}
//                    success:^(AFHTTPRequestOperation *operation, id responseObject) {
//                        if([responseObject[@"result"] integerValue]==1){
//                        }
//                        else{
//                            
//                            [AFNet alert:responseObject[@"content"]];
//                            [self viewWillAppear:YES];
//                        }
//                        
//                    }
//                    failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//                        
//                        [AFNet alert:[NSString stringWithFormat:@"%@",[error localizedDescription]]];
//                        [self viewWillAppear:YES];
//                    }
//             ];
//        });
//        
//        [self.tuoStore removeTuo:row];
//        [tableView cellForRowAtIndexPath:indexPath].alpha = 0.0;
//        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
//        
//        
//    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
//        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
//    }
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    int row = indexPath.row;
    MovementList *rukuList = (MovementList *)self.dataArray [indexPath.row];
//    Xiang *Retain = [[[Xiang alloc]init] copyMe:[self.dataArray objectAtIndex:row]];
    self.rukuList= [NSString stringWithFormat:@"%@",rukuList.ID];
    [self performSegueWithIdentifier:@"rukuDetail" sender:@{@"rukuDetail":rukuList}];

}
-(BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
        return NO;
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
//    id vewctl=segue.destinationViewController;
    if ([segue.identifier isEqualToString:@"rukuDetail"] ) {
        id o=segue.destinationViewController;
        RuKuDetailTableViewController *scan=segue.destinationViewController;
        scan.listID=self.rukuList;
        scan.userID=self.userID;
    }else{
    TuoScanViewController *scan=segue.destinationViewController;
    scan.type=@"ruku";
    scan.userID=self.userID;
    scan.hideCheckButton=YES;
    }
    //异步请求
    
//    AFNetOperate *AFNet=[[AFNetOperate alloc] init];
//    AFHTTPRequestOperationManager *manager=[AFNet generateManager:self.view];
//    [manager POST:[AFNet CreateMovementList]
//       parameters:@{@"user_id":self.userID}
//          success:^(AFHTTPRequestOperation *operation, id responseObject) {
//              [AFNet.activeView stopAnimating];
//              Xiang *xiang=[[Xiang alloc] initWithObject:responseObject[@"content"]];
//              [self.tuo addXiang:xiang];
//              
//              
//              scan.rukuList=xiang.listid;
//              
//              [self.tableView reloadData];
//              AudioServicesPlaySystemSound(1051);
//              
//          } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//              [AFNet.activeView stopAnimating];
//              
//          }
//     ];
    
//    if([segue.identifier isEqualToString:@"tuoEdit"]){
//        TuoEditViewController *tuoEdit=segue.destinationViewController;
//        tuoEdit.tuo=[sender objectForKey:@"tuo"];
//    }
}

- (IBAction)creatRuKuList:(id)sender {
   
}

@end
