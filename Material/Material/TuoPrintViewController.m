//
//  TuoPrintViewController.m
//  Material
//
//  Created by wayne on 14-6-8.
//  Copyright (c) 2014年 brilliantech. All rights reserved.
//

#import "TuoPrintViewController.h"
#import "PrinterSetting.h"
#import "Xiang.h"
#import "XiangTableViewCell.h"
#import "AFNetOperate.h"

@interface TuoPrintViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UILabel *departmentLabel;
@property (weak, nonatomic) IBOutlet UILabel *agentLabel;
@property (weak, nonatomic) IBOutlet UITableView *xiangTable;
@property (strong,nonatomic) PrinterSetting *printerSetting;
- (IBAction)confirmPrint:(id)sender;

@end

@implementation TuoPrintViewController

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
    self.xiangTable.delegate=self;
    self.xiangTable.dataSource=self;
    // Do any additional setup after loading the view.
    UINib *nib=[UINib nibWithNibName:@"XiangTableViewCell" bundle:nil];
    [self.xiangTable registerNib:nib forCellReuseIdentifier:@"xiangCell"];
    self.printerSetting=[PrinterSetting sharedPrinterSetting];
}
-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
//    [[Captuvo sharedCaptuvoDevice] stopDecoderHardware];
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.departmentLabel.text=self.tuo.department;
    self.agentLabel.text=[NSString stringWithFormat:@"%@   %@",self.tuo.date,self.tuo.agent];
    self.departmentLabel.adjustsFontSizeToFitWidth=YES;
    self.agentLabel.adjustsFontSizeToFitWidth=YES;
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.tuo xiangAmount];
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    Xiang *xiang=[[self.tuo xiang] objectAtIndex:indexPath.row];
    XiangTableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:@"xiangCell" forIndexPath:indexPath];
    cell.partNumber.text=xiang.number;
    cell.key.text=xiang.key;
    cell.quantity.text=xiang.count;
    cell.position.text=xiang.position;
    cell.date.text=xiang.date;
    cell.stateLabel.text=xiang.state_display;
    if(xiang.state==0){
        [cell.stateLabel setTextColor:[UIColor redColor]];
    }
    else if(xiang.state==1 || xiang.state==2){
        [cell.stateLabel setTextColor:[UIColor blueColor]];
    }
    else if(xiang.state==3){
        [cell.stateLabel setTextColor:[UIColor colorWithRed:87.0/255.0 green:188.0/255.0 blue:96.0/255.0 alpha:1.0]];
    }
    else if(xiang.state==4){
        [cell.stateLabel setTextColor:[UIColor orangeColor]];
    }
    return cell;
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)confirmPrint:(id)sender {
    AFNetOperate *AFNet=[[AFNetOperate alloc] init];
    AFHTTPRequestOperationManager *manager=[AFNet generateManager:self.view];
   
    NSLog([[AFNet print_stock_tuo:self.tuo.ID printer_name:[self.printerSetting getPrinterModelWithAlternative:@"P001"] copies:[self.printerSetting getCopy:@"stock" type:@"tuo" alternative:@"P001"]] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]);
    
    
      [manager GET:[[AFNet print_stock_tuo:self.tuo.ID printer_name:[self.printerSetting getPrinterModelWithAlternative:@"P001"] copies:[self.printerSetting getCopy:@"stock" type:@"tuo" alternative:@"P001"]] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]
      parameters:nil
         success:^(AFHTTPRequestOperation *operation, id responseObject) {
             [AFNet.activeView stopAnimating];
             if([responseObject[@"Code"] integerValue]==1){
                 [self performSegueWithIdentifier:@"finishTuo" sender:self];
                  [AFNet alertSuccess:responseObject[@"Content"]];
             }
             else{
                 [AFNet alert:responseObject[@"Content"]];
             }
         }
         failure:^(AFHTTPRequestOperation *operation, NSError *error) {
             [AFNet.activeView stopAnimating];
             [AFNet alert:[NSString stringWithFormat:@"%@",[error localizedDescription]]];
         }
     ];
}
@end
