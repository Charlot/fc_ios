//
//  RequireHistoryViewController.m
//  Material
//
//  Created by wayne on 14-7-22.
//  Copyright (c) 2014年 brilliantech. All rights reserved.
//

#import "RequireHistoryViewController.h"
#import "AFNetOperate.h"
#import "RequireBill.h"
#import "RequireHistoryListTableViewController.h"

@interface RequireHistoryViewController ()<UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITextField *dateTextField;
@property (strong,nonatomic)NSDate *postDate;
- (IBAction)query:(id)sender;
- (IBAction)touchScreen:(id)sender;
@end

@implementation RequireHistoryViewController

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
    // Do any additional setup after loading the view.
    self.dateTextField.delegate=self;
    UIDatePicker *datePicker=[[UIDatePicker alloc] init];
    [datePicker setDate:[NSDate date]];
    [datePicker addTarget:self
                   action:@selector(updateDateTextField:)
         forControlEvents:UIControlEventValueChanged];
    datePicker.datePickerMode=UIDatePickerModeDate;
    [self.dateTextField setInputView:datePicker];
    self.postDate=[[NSDate alloc] init];
}
-(void)updateDateTextField:(id)sender
{
    UIDatePicker *datePicker=(UIDatePicker *)self.dateTextField.inputView;
    NSDateFormatter *formatter=[[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    self.dateTextField.text=[NSString stringWithFormat:@"%@",[formatter stringFromDate:datePicker.date]];
    self.postDate=datePicker.date;
    
}
-(void)textFieldDidBeginEditing:(UITextField *)textField{
    if(self.dateTextField.text.length==0){
        NSDateFormatter *formater=[[NSDateFormatter alloc] init];
        [formater setDateFormat:@"yyyy-MM-dd"];
        textField.text=[formater stringFromDate:[NSDate date]];
        [formater setDateFormat:@"yyyy-MM-dd'T'00:00:00ZZZZZ"];
        self.postDate=[NSDate date];
    }
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if([segue.identifier isEqualToString:@"queryRequire"]){
        RequireHistoryListTableViewController *historyList=segue.destinationViewController;
        historyList.billArray=[sender objectForKey:@"billArray"];
    }
}


- (IBAction)query:(id)sender {
    NSString *dateText=self.dateTextField.text;
    if(dateText.length>0){
        NSDateComponents *components=[[NSDateComponents alloc] init];
        [components setDay:1];
        NSCalendar *calendar=[[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
        NSDate *endDate=[calendar dateByAddingComponents:components toDate:self.postDate options:0];
        NSDateFormatter *formatter=[[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"yyyy-MM-dd'T'00:00:00ZZZZZ"];
        NSString *begin=[formatter stringFromDate:self.postDate];
        NSString *end=[formatter stringFromDate:endDate];
        
        AFNetOperate *AFNet=[[AFNetOperate alloc] init];
        [AFNet.activeView stopAnimating];
        AFHTTPRequestOperationManager *manager=[AFNet generateManager:self.view];
        [AFNet.activeView stopAnimating];
        [manager GET:[AFNet order_history]
          parameters:@{@"start":begin,@"end":end}
             success:^(AFHTTPRequestOperation *operation, id responseObject) {
                 [AFNet.activeView stopAnimating];
                 if([responseObject[@"result"] integerValue]==1){
                     NSMutableArray *billList=[[NSMutableArray alloc] init];
                     NSArray *resultArray=responseObject[@"content"][@"orders"];
                     for(int i=0;i<resultArray.count;i++){
                         NSDictionary *dic=resultArray[i];
                         RequireBill *bill=[[RequireBill alloc] initWithObject:dic];
                         [billList addObject:bill];
                     }
                    [self.dateTextField resignFirstResponder];
                    [self performSegueWithIdentifier:@"queryRequire" sender:@{@"billArray": [billList copy]}];
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
        
//        [self.dateTextField resignFirstResponder];
//        [self performSegueWithIdentifier:@"queryRequire" sender:self];
    }
    else{
        UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@""
                                                      message:@"请选择日期"
                                                     delegate:self
                                            cancelButtonTitle:@"确定"
                                            otherButtonTitles:nil];
        [alert show];
    }
    
}

- (IBAction)touchScreen:(id)sender {
    [self.dateTextField resignFirstResponder];
}
@end
