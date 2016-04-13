//
//  DeliveryPickListViewController.m
//  Material
//
//  Created by Charlot on 16/4/13.
//  Copyright © 2016年 brilliantech. All rights reserved.
//

#import "DeliveryPickListViewController.h"

#import "AFNetOperate.h"
#import <AudioToolbox/AudioToolbox.h>
#import "PickList.h"
#import "PickListTableViewCell.h"


@interface DeliveryPickListViewController()<UITextFieldDelegate,UITableViewDelegate,UITableViewDataSource,CaptuvoEventsProtocol,UIAlertViewDelegate>

@property (weak, nonatomic) IBOutlet UITextField *pickListNr;
@property(strong,nonatomic)UITextField *firstResponder;
@property(strong,nonatomic)NSMutableArray *pickLists;
@property (strong,nonatomic)UIAlertView *alert;
@property (weak, nonatomic) IBOutlet UITableView *pickListTableView;

@end

@implementation DeliveryPickListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    UINib *nib=[UINib nibWithNibName:@"PickListTableViewCell" bundle:nil];
    
    self.pickListTableView.delegate=self;
    self.pickListTableView.dataSource=self;
    
    [self.pickListTableView registerNib:nib forCellReuseIdentifier:@"pickCell"];

}

-(void)viewDidAppear:(BOOL)animated{
    
    [super viewDidAppear:animated];
    self.pickListNr.delegate=self;
    [self.pickListNr becomeFirstResponder];
    self.pickLists=[[NSMutableArray alloc]init];
      self.alert=nil;
    
    [[Captuvo sharedCaptuvoDevice] addCaptuvoDelegate:self];
    
}

#pragma decoder delegate
-(void)decoderDataReceived:(NSString *)data{
    self.firstResponder.text=[data copy];
    [self textFieldShouldReturn:self.firstResponder];
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [[Captuvo sharedCaptuvoDevice] removeCaptuvoDelegate:self];
    [self.firstResponder resignFirstResponder];
    self.firstResponder=nil;
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if(textField.text.length>0){
        NSString *pickListNr=textField.text;
        
        AFNetOperate *AFNet=[[AFNetOperate alloc] init];
        AFHTTPRequestOperationManager *manager=[AFNet generateManager:self.view];

        [manager GET:[AFNet getPickById]
           parameters: @{@"id":pickListNr}
              success:^(AFHTTPRequestOperation *operation, id responseObject) {
                  
                  [AFNet.activeView stopAnimating];
                  
                  if([responseObject[@"result"] integerValue]==1){
                      PickList *pick=[[PickList alloc] initWithObject:responseObject[@"content"]];
                      if([self.pickLists indexOfObject:pick.ID]==NSNotFound){
                          [self.pickLists addObject:pick.ID];
                      }else{
                          if(self.alert){
                              [self.alert dismissWithClickedButtonIndex:0 animated:YES];
                              self.alert=nil;
                          }
                          self.alert= [[UIAlertView alloc]initWithTitle:@"错误"
                                                                message:@"不可重复扫描"
                                                               delegate:self
                                                      cancelButtonTitle:nil
                                                      otherButtonTitles:nil];
                          [NSTimer scheduledTimerWithTimeInterval:1.0f
                                                           target:self
                                                         selector:@selector(dissmissAlert:)
                                                         userInfo:nil
                                                          repeats:NO];
                          [self.alert show];

                      }
                      
                  }
                  else{
                      [AFNet alert:responseObject[@"content"]];
                      [self.pickListNr becomeFirstResponder];
                  }
                  
              }
              failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                  [AFNet.activeView stopAnimating];
                  [AFNet alert:[NSString stringWithFormat:@"%@",[error localizedDescription]]];
              }
         ];

    }
    return YES;
}

#pragma textField delegate
-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    UIView* dummyView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 1, 1)];
    textField.inputView = dummyView;
    self.firstResponder=textField;
}

-(void)dissmissAlert:(NSTimer *)timer
{
    if(self.alert){
        [self.alert dismissWithClickedButtonIndex:0 animated:YES];
        self.alert=nil;
    }
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
