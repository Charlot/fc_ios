//
//  XiangDetailViewController.m
//  Material
//
//  Created by wayne on 16/4/19.
//  Copyright © 2016年 brilliantech. All rights reserved.
//

#import "XiangDetailViewController.h"
#import "ScanStandard.h"
#import "UserPreference.h"
#import "AFNetOperate.h"
#import <AudioToolbox/AudioToolbox.h>
#import "XiangDetailTableViewCell.h"
#import "XiangDetail.h"

@interface XiangDetailViewController ()<UITextFieldDelegate,UITableViewDelegate,UITableViewDataSource,CaptuvoEventsProtocol,UIAlertViewDelegate>
@property (weak, nonatomic) IBOutlet UITextField *key;
@property (weak, nonatomic) IBOutlet UITextField *partNumber;
@property (weak, nonatomic) IBOutlet UITextField *fifo;
@property (weak, nonatomic) IBOutlet UITextField *quantity;
@property (weak, nonatomic) IBOutlet UITableView *xiangTable;
@property (strong,nonatomic)ScanStandard *scanStandard;
@property (strong,nonatomic)UserPreference *userPref;
@property (strong,nonatomic)UIAlertView *alert;
@property (strong, nonatomic) UITextField *firstResponder;

@property (strong,nonatomic) XiangDetailTableViewCell *tableviewCell;

@end

@implementation XiangDetailViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.key.delegate = self;
    self.partNumber.delegate=self;
    self.quantity.delegate=self;
    self.fifo.delegate=self;
    
//    UITableView *tableView =[[UITableView alloc] initWithFrame:self.view.frame style:UITableViewStyleGrouped];
//    tableView.dataSource=self;
//    tableView.delegate=self;
//    tableView.allowsSelection=NO;
//    [self.view addSubview:tableView];
    
    
    self.xiangTable.delegate=self;
    self.xiangTable.dataSource=self;
    
//    self.xiangTable.dataSource=self;
//    self.xiangTable.delegate=self;
//    self.xiangTable.dataSource=self;
//    if([self.type isEqualToString:@"xiang"]){
//        self.navigationItem.rightBarButtonItem=NULL;
//        self.tuo=[[Tuo alloc] init];
//    }
//    else if([self.type isEqualToString:@"addXiang"]){
//        self.navigationItem.rightBarButtonItem=NULL;
//    }
//    else if([self.type isEqualToString:@"tuo"]){
//        [self.navigationItem setHidesBackButton:YES];
//        self.navigationItem.title=self.tuo.department;
//    }
    UINib *nib=[UINib nibWithNibName:@"XiangDetailTableViewCell" bundle:nil];
    
//    [self.xiangTable registerNib:nib forCellReuseIdentifier:@"xiang_list_item"];
//

    [self.xiangTable registerNib:nib forCellReuseIdentifier:@"xiangCell"];
    
    [self.xiangTable reloadData];
    
    self.scanStandard=[ScanStandard sharedScanStandard];

    self.userPref=[UserPreference sharedUserPreference];
}



-(void)popout
{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [[Captuvo sharedCaptuvoDevice] addCaptuvoDelegate:self];
    [self.key becomeFirstResponder];
    [self.xiangTable reloadData];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [[Captuvo sharedCaptuvoDevice] removeCaptuvoDelegate:self];
    [self.firstResponder resignFirstResponder];
    self.firstResponder=nil;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

-(void)removeAlert:(NSTimer *)timer{
    UIAlertView *alert = [[timer userInfo]  objectForKey:@"alert"];
    [alert dismissWithClickedButtonIndex:0 animated:YES];
}

-(void)dissmissAlert:(NSTimer *)timer
{
    if(self.alert){
        [self.alert dismissWithClickedButtonIndex:0 animated:YES];
        self.alert=nil;
    }
}

-(void) alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(buttonIndex==1){
//        [self performSegueWithIdentifier:@"scanToPrint" sender:@{@"container":self.tuo}];
    }
}

#pragma decoder delegate
-(void)decoderDataReceived:(NSString *)data{
    self.firstResponder.text=[data copy];
    UITextField *targetTextField=self.firstResponder;
    if(targetTextField.tag==10 ){
        //date
        NSString *alertString=@"请扫描唯一码";
        BOOL isMatch  = [self.scanStandard checkKey:data];
        if(isMatch){
            [self textFieldShouldReturn:self.firstResponder];
        }
        else{
            UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@""
                                                          message:alertString
                                                         delegate:self
                                                cancelButtonTitle:@"确定"
                                                otherButtonTitles:nil];
            [alert show];
            [NSTimer scheduledTimerWithTimeInterval:2.0f
                                             target:self
                                           selector:@selector(removeAlert:)
                                           userInfo:[NSDictionary dictionaryWithObjectsAndKeys:alert,@"alert", nil]
                                            repeats:NO];
            AudioServicesPlaySystemSound(1051);
            targetTextField.text=@"";
            [targetTextField becomeFirstResponder];
        }
    }
    else if(targetTextField.tag==20){
        //part number
        NSString *alertString=@"请扫描零件号";
        BOOL isMatch  = [self.scanStandard checkPartNumber:data];
        if(isMatch){
            [self textFieldShouldReturn:self.firstResponder];
        }
        else{
            UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@""
                                                          message:alertString
                                                         delegate:self
                                                cancelButtonTitle:@"确定"
                                                otherButtonTitles:nil];
            [alert show];
            [NSTimer scheduledTimerWithTimeInterval:2.0f
                                             target:self
                                           selector:@selector(removeAlert:)
                                           userInfo:[NSDictionary dictionaryWithObjectsAndKeys:alert,@"alert", nil]
                                            repeats:NO];
            AudioServicesPlaySystemSound(1051);
            targetTextField.text=@"";
            [targetTextField becomeFirstResponder];
        }
    }
    else if(targetTextField.tag==30){
        //count
        NSString *alertString=@"请扫描FIFO";
        BOOL isMatch  = [self.scanStandard checkDate:data];
        if(isMatch){
            [self textFieldShouldReturn:self.firstResponder];
        }
        else{
            UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@""
                                                          message:alertString
                                                         delegate:self
                                                cancelButtonTitle:@"确定"
                                                otherButtonTitles:nil];
            [alert show];
            [NSTimer scheduledTimerWithTimeInterval:2.0f
                                             target:self
                                           selector:@selector(removeAlert:)
                                           userInfo:[NSDictionary dictionaryWithObjectsAndKeys:alert,@"alert", nil]
                                            repeats:NO];
            AudioServicesPlaySystemSound(1051);
            targetTextField.text=@"";
            [targetTextField becomeFirstResponder];
        }
        
    }
    else{
        //唯一码
        NSString *alertString=@"请扫描数量";
        BOOL isMatch  = [self.scanStandard checkQuantity:data];
        if(isMatch){
            [self textFieldShouldReturn:self.firstResponder];
            
        }
        else{
            UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@""
                                                          message:alertString
                                                         delegate:self
                                                cancelButtonTitle:@"确定"
                                                otherButtonTitles:nil];
            [alert show];
            [NSTimer scheduledTimerWithTimeInterval:2.0f
                                             target:self
                                           selector:@selector(removeAlert:)
                                           userInfo:[NSDictionary dictionaryWithObjectsAndKeys:alert,@"alert", nil]
                                            repeats:NO];
            AudioServicesPlaySystemSound(1051);
            targetTextField.text=@"";
            [targetTextField becomeFirstResponder];
        }
    }
}

#pragma textField delegate
-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    UIView* dummyView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 1, 1)];
    textField.inputView = dummyView;
    self.firstResponder=textField;
}


-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    __block long tag=textField.tag;
    if(tag==40){
        
        
        AFNetOperate *AFNet=[[AFNetOperate alloc] init];
        AFHTTPRequestOperationManager *manager=[AFNet generateManager:self.view];
        
        NSString *key=self.key.text?self.key.text:@"";
        NSString *partNumber=self.partNumber.text?self.partNumber.text:@"";
        NSString *quantity=self.quantity.text?self.quantity.text:@"";
        NSString *fifo=self.fifo.text?self.fifo.text:@"";
            //after regex partNumber
        NSString *partNumberPost=[self.scanStandard filterPartNumber:partNumber];
        //after regex quantity
        NSString *fifoPost=[self.scanStandard filterDate:fifo];
        NSString *quantityPost=[self.scanStandard filterQuantity:quantity];
        //after regex date
        if(key.length>0){
            
            NSDictionary *parameters=[NSDictionary dictionary];

            parameters=@{@"package":@{
                             @"id":key,
                             @"part_id_display":partNumber,
                             @"part_id":partNumberPost,
                             @"quantity":quantityPost,
                             @"quantity_display":quantity,
                             @"custom_fifo_time":fifoPost,
                             @"fifo_time_display":fifo
                             }
                         };
                
//            }
            [manager POST:[AFNet xiang_enter_stock]
               parameters: parameters
                  success:^(AFHTTPRequestOperation *operation, id responseObject) {
//                      //成功了
                      [AFNet.activeView stopAnimating];
                      
                      if([responseObject[@"result"] integerValue]==1){
                          
                          if([(NSDictionary *)responseObject[@"content"] count]>0){
                              NSString *idValue;
                              NSString *keyValue;
                              NSString *partNrValue;
                              NSString *quantityValue;
                   
//                              for(int i =0; i<[(NSDictionary *)responseObject[@"content"] count];i++){
                                  idValue=[(NSDictionary *)responseObject[@"content"] valueForKey:@"id"];
                                  keyValue=[(NSDictionary *)responseObject[@"content"] valueForKey:@"container_id"];
                                  partNrValue=[(NSDictionary *)responseObject[@"content"] valueForKey:@"part_id_display"];
                                  quantityValue=[(NSDictionary *)responseObject[@"content"] valueForKey:@"quantity"];
//                              }

                              _tableviewCell.key.text=keyValue;
                              _tableviewCell.partNr.text=partNrValue;
                              _tableviewCell.quantity.text=quantityValue;
                              
//                           XiangDetail *newXiangDetail=[[XiangDetail alloc] initWithObject:responseObject[@"content"]];
                              
//                          [self.xiangDetail addXiangDetail:newXiangDetail];
                 
                          AudioServicesPlaySystemSound(1012);
                          
                          @try {
                              NSString * result= idValue;
//
                              self.alert= [[UIAlertView alloc]initWithTitle:@"成功"
                                                                    message:result
                                                                   delegate:self
                                                          cancelButtonTitle:nil
                                                          otherButtonTitles:nil];
                              [NSTimer scheduledTimerWithTimeInterval:2.0f
                                                               target:self
                                                             selector:@selector(dissmissAlert:)
                                                             userInfo:nil
                                                              repeats:NO];

                          } @catch (NSException *exception) {
                             
                              NSString *message = @"扫描入库成功";
                              
                              self.alert= [[UIAlertView alloc]initWithTitle:@"成功"
                                                                    message:message
                                                                   delegate:self
                                                          cancelButtonTitle:nil
                                                          otherButtonTitles:nil];
                              [NSTimer scheduledTimerWithTimeInterval:2.0f
                                                               target:self
                                                             selector:@selector(dissmissAlert:)
                                                             userInfo:nil
                                                              repeats:NO];

                          }
//                          @finally {
//                              self.alert= [[UIAlertView alloc]initWithTitle:@"成功"
//                                                                    message:@"扫描入库成功"
//                                                                   delegate:self
//                                                          cancelButtonTitle:nil
//                                                          otherButtonTitles:nil];
//                              [NSTimer scheduledTimerWithTimeInterval:2.0f
//                                                               target:self
//                                                             selector:@selector(dissmissAlert:)
//                                                             userInfo:nil
//                                                              repeats:NO];
//                          }
                          
                          [self.xiangTable reloadData];
                          [self.alert show];
                          self.key.text=@"";
                          self.partNumber.text=@"";
                          self.quantity.text=@"";
                          self.fifo.text=@"";
                          [self.key becomeFirstResponder];
                          }else{
                              NSString *message = @"扫描入库失败，没有返回值";

                              self.alert= [[UIAlertView alloc]initWithTitle:@"失败"
                                                                    message:message
                                                                   delegate:self
                                                          cancelButtonTitle:nil
                                                          otherButtonTitles:nil];
                              [NSTimer scheduledTimerWithTimeInterval:2.0f
                                                               target:self
                                                             selector:@selector(dissmissAlert:)
                                                             userInfo:nil
                                                              repeats:NO];
                              [self.alert show];

                          }
                      }else{
                          NSString *message = @"扫描入库失败，网络错误";
                          
                          self.alert= [[UIAlertView alloc]initWithTitle:@"失败"
                                                                message:message
                                                               delegate:self
                                                      cancelButtonTitle:nil
                                                      otherButtonTitles:nil];
                          [NSTimer scheduledTimerWithTimeInterval:2.0f
                                                           target:self
                                                         selector:@selector(dissmissAlert:)
                                                         userInfo:nil
                                                          repeats:NO];
                          
                          [self.alert show];
                          
                          [AFNet alert:responseObject[@"content"]];
                          self.key.text=@"";
                          self.partNumber.text=@"";
                          self.quantity.text=@"";
                          self.fifo.text=@"";
                          [self.key becomeFirstResponder];
                      }
              }
                  failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                      [AFNet.activeView stopAnimating];
                      [AFNet alert:[NSString stringWithFormat:@"%@",[error localizedDescription]]];
                  }
             ];
        }else{
            self.alert= [[UIAlertView alloc]initWithTitle:@"失败"
                            message:@"检查扫描参数"
                            delegate:self
                             cancelButtonTitle:nil
                             otherButtonTitles:nil];
                             [NSTimer scheduledTimerWithTimeInterval:2.0f
                              target:self
                             selector:@selector(dissmissAlert:)
                              userInfo:nil
                              repeats:NO];
                            [self.alert show];

                }
    }
    else{
        tag+=10;
        UITextField *nextText=(UITextField *)[self.view viewWithTag:tag];
        [nextText becomeFirstResponder];
    }
    return YES;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
//    NSArray * array=self.xiangdetailist[section];
    return 2;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    XiangDetailTableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:@"xiangCell" forIndexPath:indexPath];

//       Xiang *xiang=[self.xiangdetailist objectAtIndex:indexPath.row];
   
    XiangDetail *xiangdetail=[self.xiangdetailist objectAtIndex:indexPath.row];
    

        cell.key.text=xiangdetail.key;
        cell.partNr.text=xiangdetail.partNr;
        cell.quantity.text=xiangdetail.quantity;
        cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
    
//
    
//    cell.stateLabel.text=xiang.state_display;
//    if(xiang.state==0){
//        [cell.stateLabel setTextColor:[UIColor redColor]];
//    }
//    else if(xiang.state==1 || xiang.state==2){
//        [cell.stateLabel setTextColor:[UIColor blueColor]];
//    }
//    else if(xiang.state==3){
//        [cell.stateLabel setTextColor:[UIColor colorWithRed:87.0/255.0 green:188.0/255.0 blue:96.0/255.0 alpha:1.0]];
//    }
//    else if(xiang.state==4){
//        [cell.stateLabel setTextColor:[UIColor orangeColor]];
//    }
    
        return cell;
}

@end
