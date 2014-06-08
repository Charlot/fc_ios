//
//  TuoScanViewController.m
//  Material
//
//  Created by wayne on 14-6-6.
//  Copyright (c) 2014年 brilliantech. All rights reserved.
//

#import "TuoScanViewController.h"
#import "XiangStore.h"
#import "TuoStore.h"
#import "HuoTableViewCell.h"
#import "Xiang.h"
#import "PrintViewController.h"
#import "Tuo.h"
#import "XiangEditViewController.h"

@interface TuoScanViewController ()<UITextFieldDelegate,UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITextField *key;
@property (weak, nonatomic) IBOutlet UITextField *partNumber;
@property (weak, nonatomic) IBOutlet UITextField *quatity;
@property (weak, nonatomic) IBOutlet UITableView *xiangTable;
@property (strong, nonatomic) XiangStore *xiangStore;
- (IBAction)finish:(id)sender;

@end

@implementation TuoScanViewController

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
    self.key.delegate=self;
    self.partNumber.delegate=self;
    self.quatity.delegate=self;
    self.xiangStore=[XiangStore sharedXiangStore];
    self.xiangTable.delegate=self;
    self.xiangTable.dataSource=self;
    if([self.type isEqualToString:@"xiang"]){
        self.navigationItem.rightBarButtonItem=NULL;
        self.tuo=[[Tuo alloc] init];
    }
    else if([self.type isEqualToString:@"addXiang"]){
        self.navigationItem.rightBarButtonItem=NULL;
    }
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.key becomeFirstResponder];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    UIView* dummyView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 1, 1)];
    textField.inputView = dummyView;
}

//-(BOOL)textFieldShouldReturn:(UITextField *)textField
-(void)textFieldDidEndEditing:(UITextField *)textField
{
    int tag=textField.tag;
    if(tag==23){
        NSString *key=self.key.text;
        NSString *partNumber=self.partNumber.text;
        NSString *quatity=self.quatity.text;
        //箱的绑定集中加一箱
        Xiang *newXiang=[self.xiangStore addXiang:key partNumber:partNumber quatity:quatity];
        //本地的拖加一个箱
        [self.tuo addXiang:newXiang];
        
        [self.xiangTable reloadData];
    }
    tag++;
    if(tag>23){
        tag=21;
    }
    UITextField *nextText=(UITextField *)[self.view viewWithTag:tag];
    [nextText becomeFirstResponder];
//    return YES;
}
//table delegate
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.tuo.xiang count];
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    HuoTableViewCell *cell=(HuoTableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"huoCell"];
    Xiang *xiang=[self.tuo.xiang objectAtIndex:indexPath.row];
    cell.leoniNumber.text=xiang.number;
    cell.kwyNumber.text=xiang.key;
    cell.extraInfo.text=[NSString stringWithFormat:@"Q%@ / %@",xiang.count,xiang.position];
    cell.leoniNumber.adjustsFontSizeToFitWidth=YES;
    cell.kwyNumber.adjustsFontSizeToFitWidth=YES;
    cell.extraInfo.adjustsFontSizeToFitWidth=YES;
    return cell;
}
-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [self.tuo.xiang removeObjectAtIndex:indexPath.row];
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }
}
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    if([self.type isEqualToString:@"xiang"]){
      return NO;
    }
    else{
        return YES;
    }
}
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if([segue.identifier isEqualToString:@"scanToPrint"]){
        PrintViewController *printViewController = segue.destinationViewController;
        printViewController.container=[sender objectForKey:@"container"];
    }
    else if([segue.identifier isEqualToString:@"fromTuo"]){
        int row=[[self.xiangTable indexPathForCell:sender] row];
        XiangEditViewController *xiangEdit=segue.destinationViewController;
        xiangEdit.xiang=[self.tuo.xiang objectAtIndex:row];
    }
}
- (IBAction)finish:(id)sender {
    [self performSegueWithIdentifier:@"scanToPrint" sender:@{@"container":self.tuo}];
}
@end
