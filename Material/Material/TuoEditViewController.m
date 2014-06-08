//
//  TuoEditViewController.m
//  Material
//
//  Created by wayne on 14-6-8.
//  Copyright (c) 2014年 brilliantech. All rights reserved.
//

#import "TuoEditViewController.h"
#import "HuoTableViewCell.h"
#import "XiangEditViewController.h"
#import "Xiang.h"
#import "TuoScanViewController.h"
#import "TuoPrintViewController.h"

@interface TuoEditViewController ()<UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITextField *department;
@property (weak, nonatomic) IBOutlet UITextField *agent;
@property (weak, nonatomic) IBOutlet UITableView *xiangTable;
@end

@implementation TuoEditViewController

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
    self.xiangTable.delegate=self;
    self.xiangTable.dataSource=self;
    self.department.delegate=self;
    self.agent.delegate=self;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.department.text=self.tuo.department;
    self.agent.text=self.tuo.agent;
    [self.xiangTable reloadData];
}
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if(textField.tag==21){
        self.tuo.department=self.department.text;
    }
    else if(textField.tag==22){
        self.tuo.agent=self.agent.text;
    }
    [textField resignFirstResponder];
    return YES;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.tuo xiangAmount];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    Xiang *xiang=[[self.tuo xiang] objectAtIndex:indexPath.row];
    HuoTableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:@"xiangCell"];
    cell.leoniNumber.text=xiang.number;
    cell.kwyNumber.text=xiang.key;
    cell.extraInfo.text=[NSString stringWithFormat:@"Q%@ / %@",xiang.count,xiang.position];
    cell.leoniNumber.adjustsFontSizeToFitWidth=YES;
    cell.kwyNumber.adjustsFontSizeToFitWidth=YES;
    cell.extraInfo.adjustsFontSizeToFitWidth=YES;
    return cell;
}
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [self.tuo.xiang removeObjectAtIndex:indexPath.row];
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if([segue.identifier isEqualToString:@"xiangEdit"]){
        XiangEditViewController *xiangEdit=segue.destinationViewController;
        Xiang *xiang=[[self.tuo xiang] objectAtIndex:[[self.xiangTable indexPathForCell:sender] row]];
        xiangEdit.xiang=xiang;
    }
    else if([segue.identifier isEqualToString:@"addXiang"]){
        TuoScanViewController *scanView=segue.destinationViewController;
        scanView.type=@"addXiang";
        scanView.tuo=self.tuo;
    }
    else if([segue.identifier isEqualToString:@"tuoPrint"]){
        TuoPrintViewController *tuoPrint=segue.destinationViewController;
        tuoPrint.tuo=self.tuo;
    }
}
@end
