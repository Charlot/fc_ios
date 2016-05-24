//
//  DeliveryOrderViewController.m
//  Material
//
//  Created by Charlot on 16/4/13.
//  Copyright © 2016年 brilliantech. All rights reserved.
//

#import "DeliveryOrderViewController.h"

#import "AFNetOperate.h"
#import <AudioToolbox/AudioToolbox.h>
#import "Order.h"
#import "Inventory.h"
#import "Yun.h"
#import "YunChooseTuoViewController.h"
#import "YunInfoViewController.h"

@interface DeliveryOrderViewController()<UITextFieldDelegate,UITableViewDelegate,UITableViewDataSource,CaptuvoEventsProtocol,UIAlertViewDelegate,UIPickerViewDataSource,
UIPickerViewDelegate>{
    NSMutableArray *_dataList;
    NSArray *_pickerData;
    NSString *_orderId;
}
 
@property(strong,nonatomic)UITextField *firstResponder;

@property (strong,nonatomic)UIAlertView *alert;
@property (weak, nonatomic) IBOutlet UIPickerView *ordersPick;


//- (IBAction)pressNavigation:(id)sender;

@end

@implementation DeliveryOrderViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    if(!self.yun){
        self.yun=[[Yun alloc] init];
        self.yun.orderId=self.orderId;
    }
 
    
    
}

-(void)viewDidAppear:(BOOL)animated{
    
    [super viewDidAppear:animated];
//    self.orderId.delegate=self;
//    [self.orderId becomeFirstResponder];
//    
//    self.alert=nil;
    [self getOrderList];
    self.ordersPick.delegate=self;
    self.ordersPick.dataSource=self;
    _orderId=nil;
    [[Captuvo sharedCaptuvoDevice] addCaptuvoDelegate:self];
    
}


- (void)getOrderList {
    _dataList = [[NSMutableArray alloc] init];
    _orderId = @"";
    
    AFNetOperate *AFNet = [[AFNetOperate alloc] init];
    AFHTTPRequestOperationManager *manager = [AFNet generateManager:self.view];
    [manager GET:[AFNet getRecentOrders]
      parameters:nil
         success:^(AFHTTPRequestOperation *operation, id responseObject) {
             [AFNet.activeView stopAnimating];
             
             if ([responseObject[@"result"] integerValue] == 1) {
                 if ([(NSArray *)responseObject[@"content"] count] > 0) {
                     NSArray *orderArray = responseObject[@"content"];
                     
                     for (int i = 0; i < orderArray.count; i++) {
                         Order *order =
                         [[Order alloc] initWithObject:orderArray[i]];
                         if (i == 0) {
                             _orderId =order.ID;
                             NSLog(@"the id is %@", _orderId);
                         }
                         [_dataList addObject:order];
                     }
                     
                     //[self.processingPicker reloadAllComponents];
                 }
                 [self.ordersPick reloadAllComponents];
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
    Order *order = [[Order alloc] init];
    order = _dataList[row];
    //    NSString *strFromInt = [NSString stringWithFormat:@"%d",[_dataList
    //    count]];
    //    NSLog(strFromInt);
    //
    return order.ID;
}

- (void)pickerView:(UIPickerView *)pickerView
      didSelectRow:(NSInteger)row
       inComponent:(NSInteger)component {
    Order *order = [[Order alloc] init];
    order = _dataList[row];

    _orderId = order.ID;
}

- (IBAction)toSelectForkLift:(id)sender {
    if(_orderId){
     [self performSegueWithIdentifier:@"selectForkliftAfterOrder" sender:@{@"orderId":_orderId}];
        
    }
}

//- (IBAction)pressNavigation:(id)sender{
//    [self  performSegueWithIdentifier:@"selectForkliftAfterOrder" sender:self];
//}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if ([segue.identifier isEqualToString:@"selectForkliftAfterOrder"]) {
        //        InventoryConfirmViewController
        //        *ic=segue.destinationViewController;
        //        ic.inventroy_id= _inventoryId;
//        YunChooseTuoViewController *tuo = segue.destinationViewController;
//        tuo.orderId=[sender objectForKey:@"orderId"];
        YunInfoViewController *yunInfo = segue.destinationViewController;
        yunInfo.orderId=[sender objectForKey:@"orderId"];
        yunInfo.yun=self.yun;
    }
}



#pragma decoder delegate
-(void)decoderDataReceived:(NSString *)data{
    self.firstResponder.text=[data copy];
   // [self textFieldShouldReturn:self.firstResponder];
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
                     Order *pick=[[Order alloc] initWithObject:responseObject[@"content"]];
//                     if([self.pickLists indexOfObject:pick.ID]==NSNotFound){
//                         [self.pickLists addObject:pick.ID];
//                     }else{
//                         if(self.alert){
//                             [self.alert dismissWithClickedButtonIndex:0 animated:YES];
//                             self.alert=nil;
//                         }
//                         self.alert= [[UIAlertView alloc]initWithTitle:@"错误"
//                                                               message:@"不可重复扫描"
//                                                              delegate:self
//                                                     cancelButtonTitle:nil
//                                                     otherButtonTitles:nil];
//                         [NSTimer scheduledTimerWithTimeInterval:1.0f
//                                                          target:self
//                                                        selector:@selector(dissmissAlert:)
//                                                        userInfo:nil
//                                                         repeats:NO];
//                         [self.alert show];
//                         
//                     }
                     
                 }
                 else{
                     [AFNet alert:responseObject[@"content"]];
                    // [self.pickListNr becomeFirstResponder];
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
