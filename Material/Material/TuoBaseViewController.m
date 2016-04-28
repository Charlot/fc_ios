//
//  TuoBaseViewController.m
//  Material
//
//  Created by wayne on 14-6-6.
//  Copyright (c) 2014年 brilliantech. All rights reserved.
//

#import "TuoBaseViewController.h"
#import "TuoScanViewController.h"
#import "Tuo.h"
#import "AFNetOperate.h"
#import "UserPreference.h"
#import "Yun.h"

@interface TuoBaseViewController ()<UITextFieldDelegate,UITableViewDelegate,UITableViewDataSource,CaptuvoEventsProtocol,UIAlertViewDelegate,UIPickerViewDataSource,
UIPickerViewDelegate>{
    NSMutableArray *_dataList;
    NSArray *_pickerData;
    NSString *_deliveryId;
}

- (IBAction)nextStep:(id)sender;
@property (weak, nonatomic) IBOutlet UITextField *department;
@property (weak, nonatomic) IBOutlet UITextField *agent;
@property (strong, nonatomic) UITextField *firstResponder;
@property (weak, nonatomic) IBOutlet UILabel *departmentLabel;
@property (strong,nonatomic)NSString *location_id;

@property (strong,nonatomic)UserPreference *userPreference;
@property (weak, nonatomic) IBOutlet UIPickerView *deliveryPicker;

@end

@implementation TuoBaseViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.//test comment
    self.department.delegate=self;
    self.agent.delegate=self;
    self.userPreference =[UserPreference sharedUserPreference];
    self.location_id=[self.userPreference location_id];
    self.department.text=[self.userPreference.location.defaultDestination nr];
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [[Captuvo sharedCaptuvoDevice] addCaptuvoDelegate:self];
    NSArray *documentDictionary=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *document=[documentDictionary firstObject];
    NSString *path=[document stringByAppendingPathComponent:@"user.info.archive"];
    NSString *number=[NSKeyedUnarchiver unarchiveObjectWithFile:path];
    self.agent.text=number;
    if([self.location_id isEqualToString:@"FG"]){
        self.department.hidden=YES;
        self.departmentLabel.hidden=YES;
    }
    else{
        [self.department becomeFirstResponder];
    }
    
      self.agent.enabled=NO;
    [self getDeliveryList];
    self.deliveryPicker.dataSource=self;
    self.deliveryPicker.delegate=self;
    
}

-(void)getDeliveryList{
    
    _dataList = [[NSMutableArray alloc] init];
    _deliveryId = @"";
    
    AFNetOperate *AFNet=[[AFNetOperate alloc] init];
    AFHTTPRequestOperationManager *manager=[AFNet generateManager:self.view];
    [AFNet.activeView stopAnimating];
    [manager GET:[AFNet yun_root]
      parameters:@{
                   @"state":@[@0,@1,@2,@3,@4],
                   @"type":@0
                   }
         success:^(AFHTTPRequestOperation *operation, id responseObject) {
             [AFNet.activeView stopAnimating];
             if([responseObject[@"result"] integerValue]==1){
                 NSArray *resultArray=responseObject[@"content"];
                 for(int i=0;i<[resultArray count];i++){
                     Yun *yun=[[Yun alloc] initWithObject:resultArray[i]];
                     if (i == 0) {
                                                     _deliveryId =yun.ID;
                                                      NSLog(@"the id is %@", _deliveryId);
                            }
                    [_dataList addObject:yun];
                 }
                  [self.deliveryPicker reloadAllComponents];
             }
             else{
                 [AFNet alert:responseObject[@"content"]];
             }
         }
         failure:^(AFHTTPRequestOperation *operation, NSError *error) {
             [AFNet.activeView stopAnimating];
             [AFNet alert:[NSString stringWithFormat:@"%@",[error localizedDescription]]];
         }
     ];
}


- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}

// The number of rows of data
- (NSInteger)pickerView:(UIPickerView *)pickerView
numberOfRowsInComponent:(NSInteger)component {
    //   return _pickerData.count;
    return [_dataList count];
}

// The data to return for the row and component (column) that's being passed in
- (NSString *)pickerView:(UIPickerView *)pickerView
             titleForRow:(NSInteger)row
            forComponent:(NSInteger)component {
    //    return _pickerData[row];
    Yun *yun = [[Yun alloc] init];
    yun = _dataList[row];
    //    NSString *strFromInt = [NSString stringWithFormat:@"%d",[_dataList
    //    count]];
    //    NSLog(strFromInt);
    //
    return yun.container_id;
}

- (void)pickerView:(UIPickerView *)pickerView
      didSelectRow:(NSInteger)row
       inComponent:(NSInteger)component {
    Yun *yun = [[Yun alloc] init];
    yun = _dataList[row];
    
    _deliveryId= yun.ID;
}


-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.firstResponder resignFirstResponder];
    self.firstResponder=nil;
  
//    [[Captuvo sharedCaptuvoDevice] stopDecoderHardware];
    [[Captuvo sharedCaptuvoDevice] removeCaptuvoDelegate:self];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma decoder delegate
-(void)decoderDataReceived:(NSString *)data{
    self.firstResponder.text=data;
}
-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    UIView *dummyView=[[UIView alloc] initWithFrame:CGRectMake(0, 0, 1, 1)];
    textField.inputView=dummyView;
    self.firstResponder=textField;
}
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if([segue.identifier isEqualToString:@"tuoBaseToScan"]){
        
        TuoScanViewController *scanViewController=segue.destinationViewController;
        Tuo *tuo=[[Tuo alloc] init];
        if([self.location_id isEqualToString:@"FG"]){
            tuo.department=@"";
        }
        else{
           tuo.department=self.department.text;
        }
        
        tuo.parent_id=_deliveryId;
        
        tuo.agent=self.agent.text;
        NSDateFormatter *formatter=[[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"yyyy.MM.dd"];
        tuo.date=[formatter stringFromDate:[NSDate date]];
        tuo.ID=[sender objectForKey:@"ID"];
        scanViewController.tuo=tuo;
        //tuoStore中也要加入
        scanViewController.type=@"tuo";
    }
    
}

- (IBAction)nextStep:(id)sender {
    NSString *department=[NSString string];
    if([self.location_id isEqualToString:@"FG"]){
        department=@"";
    }
    else{
        department=self.department.text;
    }
    NSString *agent=self.agent.text;
    if(agent.length>0 && self.department.text.length>0 && _deliveryId.length>0){
        [self baseToScan:department agent:agent];
    }
    else{
        UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"错误"
                                                      message:@"请填写和选择信息"
                                                     delegate:self
                                            cancelButtonTitle:@"确定"
                                            otherButtonTitles:nil];
        [alert show];
    }
}
-(void)baseToScan:(NSString *)department agent:(NSString *)agent
{
    AFNetOperate *AFNet=[[AFNetOperate alloc] init];
    AFHTTPRequestOperationManager *manager=[AFNet generateManager:self.view];
    NSDictionary *parameters=[NSDictionary dictionary];
    if([self.location_id isEqualToString:@"FG"]){
        parameters=@{@"forklift":@{
                             @"stocker_id":agent
                             }};
    }
    else{
        parameters=@{@"forklift":@{
                             @"delivery_id":_deliveryId,
                             @"whouse_id":department,
                             @"stocker_id":agent
                             }};
    }
    [manager POST:[AFNet tuo_index]
       parameters:parameters
          success:^(AFHTTPRequestOperation *operation, id responseObject) {
              [AFNet.activeView stopAnimating];
              if([responseObject[@"result"] integerValue]==1){
                  if([(NSDictionary *)responseObject[@"content"] count]>0){
                      [self performSegueWithIdentifier:@"tuoBaseToScan" sender:@{@"ID":[responseObject[@"content"] objectForKey:@"id"]}];
                  }
              }
              else{
                  [AFNet alert:responseObject[@"content"]];
              }
              
          }
          failure:^(AFHTTPRequestOperation *operation, NSError *error) {
              [AFNet.activeView stopAnimating];
          }
     ];
}
@end
