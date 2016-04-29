//
//  RukuViewController.m
//  Material
//
//  Created by Charlot on 16/3/15.
//  Copyright © 2016年 brilliantech. All rights reserved.
//

#import "RukuViewController.h"
#import "AFNetOperate.h"

#import "ScanStandard.h"
#import "UserPreference.h"

#import <AudioToolbox/AudioToolbox.h>

@interface RukuViewController ()
@property (weak, nonatomic) IBOutlet UITextField *warehouseTF;
@property (weak, nonatomic) IBOutlet UITextField *positionTF;
@property (weak, nonatomic) IBOutlet UITextField *containerTF;

@property (weak, nonatomic) IBOutlet UILabel *unfilledLocation;

@property (strong,nonatomic)ScanStandard *scanStandard;
@property (strong,nonatomic)UserPreference *userPreference;

//@property(nonatomic, strong) UIAlertView *alert;

@property (strong, nonatomic) UITextField *firstResponder;

@end

@implementation RukuViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [[Captuvo sharedCaptuvoDevice] addCaptuvoDelegate:self];
    self.warehouseTF.delegate=self;
    self.positionTF.delegate=self;
    self.containerTF.delegate=self;
    self.userPreference=[UserPreference sharedUserPreference];
    self.warehouseTF.clearButtonMode = UITextFieldViewModeAlways;
 
    self.scanStandard=[ScanStandard sharedScanStandard];

    [self clearAllTextFields];
    if(self.userPreference.location.default_whouse){
        self.warehouseTF.text=self.userPreference.location.default_whouse.nr;
    }
    if(self.warehouseTF.text.length>0){
        [self.positionTF becomeFirstResponder];
    }
    //[self.warehouseTF becomeFirstResponder];
    
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [[Captuvo sharedCaptuvoDevice] removeCaptuvoDelegate:self];
    [self.unfilledLocation setHidden:true];
    
    [self.firstResponder resignFirstResponder];
    self.firstResponder=nil;
    
}

-(void)decoderDataReceived:(NSString *)data
{
    self.firstResponder.text=[data copy];
    if(self.firstResponder.text.length>0){
        [self textFieldShouldReturn:self.firstResponder];
    }
    
}


-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if(textField==self.warehouseTF){
        [self.positionTF becomeFirstResponder];
        [self validate];
    }else if(textField==self.positionTF){
//        [self.unfilledLocation setHidden:false];
        [self capacity_lable];
//        [self.containerTF becomeFirstResponder];
    }else if(textField==self.containerTF){
        [self validate];
    }
    return YES;
}
-(void)capacity_lable{
//    NSString *cl=[self.scanStandard filterKey:self.positionTF.text];
    AFNetOperate *AFNet = [[AFNetOperate alloc] init];
    AFHTTPRequestOperationManager *manager = [AFNet generateManager:self.view];
    
    [manager POST:	[AFNet rtposition]
      parameters:@{@"warehouse":self.warehouseTF.text,@"position":self.positionTF.text}
         success:^(AFHTTPRequestOperation *operation, id responseObject) {
             [AFNet.activeView stopAnimating];
             
             if ([responseObject[@"result"] integerValue] == 1) {
                 UIAlertView *alert_lable=[[UIAlertView alloc] initWithTitle:@""
                                                               message:@"库位已满"
                                                              delegate:self
                                                     cancelButtonTitle:@"确定"
                                                     otherButtonTitles: nil];
                 [alert_lable show];
                 
                 self.unfilledLocation.text=[NSString stringWithFormat:@"%@",@"0"];
                 
                [self.unfilledLocation setHidden:false];
                 
                 self.positionTF.text=@"";
             }else{
//                 self.unfilledLocation=@"unfill";
                 self.unfilledLocation.text=[NSString stringWithFormat:@"%d",(6-[responseObject[@"unfill"] integerValue])];
                 
                 [self.unfilledLocation setHidden:false];
//                 [self textFieldShouldReturn:self.positionTF];
                 [self.containerTF becomeFirstResponder];
                 
             }
         } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
             [AFNet.activeView stopAnimating];
         }];
    
}
-(void)validate{
    NSString *nr=[self.scanStandard filterKey:self.containerTF.text];
    
    AFNetOperate *AFNet = [[AFNetOperate alloc] init];
    AFHTTPRequestOperationManager *manager = [AFNet generateManager:self.view];
    
    [manager POST:[AFNet enter_stock]
      parameters:@{@"warehouse":self.warehouseTF.text,@"position":self.positionTF.text,@"container":nr}
         success:^(AFHTTPRequestOperation *operation, id responseObject) {
             [AFNet.activeView stopAnimating];
             if ([responseObject[@"result"] integerValue] == 1) {
                 UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@""
                                                               message:@"入库成功"
                                                              delegate:self
                                                     cancelButtonTitle:@"确定"
                                                     otherButtonTitles:nil];
                 [alert show];
                 [self.unfilledLocation setHidden:true];
                 [NSTimer scheduledTimerWithTimeInterval:2.0f
                                                  target:self
                                                selector:@selector(removeAlert:)
                                                userInfo:[NSDictionary dictionaryWithObjectsAndKeys:alert,@"alert", nil]
                                                 repeats:NO];
                 
                 AudioServicesPlaySystemSound(1051);
                 //[self clearAllTextFields];
                 self.containerTF.text=@"";
                 [self.containerTF becomeFirstResponder];
             } else {
                 [AFNet alert:responseObject[@"content"]];
             }
         }
         failure:^(AFHTTPRequestOperation *operation, NSError *error) {
             [AFNet.activeView stopAnimating];
             [AFNet alert:[NSString
                           stringWithFormat:@"%@", [error localizedDescription]]];
         }];

}
- (IBAction)enterActon:(id)sender {
    [self validate];
}

-(void)clearAllTextFields{
    NSMutableArray *textFields=[[NSMutableArray alloc] init];
    for(id input in self.view.subviews){
        if([input isKindOfClass:[UITextField class]]){
            [textFields addObject:input];
        }
    }
    
    [self clearTextFields: textFields];
    
    
    [self.warehouseTF becomeFirstResponder];
}

-(void)clearTextFields:(NSArray *)textFields{
    for (int i=0; i<textFields.count; i++) {
        ((UITextField *)textFields[i]).text=@"";
    }
}

-(void)removeAlert:(NSTimer *)timer{
    UIAlertView *alert = [[timer userInfo]  objectForKey:@"alert"];
    [alert dismissWithClickedButtonIndex:0 animated:YES];
}

-(void)textFieldDidBeginEditing:(UITextField *)textField
{
        UIView* dummyView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 1, 1)];
        textField.inputView = dummyView;
        
        [self hideKeyboard];
     
    
    self.firstResponder=textField;
    
}


- (IBAction)touchScreen:(id)sender {
    [self hideKeyboard];
    if(self.firstResponder){
        [self.view endEditing:YES];
        self.firstResponder=nil;
    }else{
        [self.view endEditing:NO];
        [self.warehouseTF becomeFirstResponder];
    }
}

-(void)hideKeyboard{
    if(self.view.frame.origin.y!=0){
        NSTimeInterval animationDuration=0.30f;
        [UIView animateWithDuration:animationDuration
                         animations:^{
                             self.view.frame=CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height);
                         }];
    }
}

- (IBAction)enterStock:(id)sender {

}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
