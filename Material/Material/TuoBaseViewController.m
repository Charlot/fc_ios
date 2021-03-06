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
@interface TuoBaseViewController ()<UITextFieldDelegate,CaptuvoEventsProtocol>
- (IBAction)nextStep:(id)sender;
@property (weak, nonatomic) IBOutlet UITextField *department;
@property (weak, nonatomic) IBOutlet UITextField *agent;
@property (strong, nonatomic) UITextField *firstResponder;
@property (weak, nonatomic) IBOutlet UILabel *departmentLabel;
@property (strong,nonatomic)NSString *location_id;
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
    self.location_id=[[UserPreference sharedUserPreference] location_id];
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
    if(agent.length>0){
        [self baseToScan:department agent:agent];
    }
    else{
        UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"错误"
                                                      message:@"信息填写不完整"
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
