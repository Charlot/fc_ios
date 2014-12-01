//
//  XiangSendViewController.m
//  Material
//
//  Created by wayne on 14-11-20.
//  Copyright (c) 2014年 brilliantech. All rights reserved.
//

#import "XiangSendViewController.h"
#import "SendAddressItem.h"
#import "SendAddress.h"
#import "DefaultAddressTableViewController.h"
#import "AFNetOperate.h"
@interface XiangSendViewController()
@property (weak, nonatomic) IBOutlet UILabel *keyLabel;
@property (weak, nonatomic) IBOutlet UILabel *partNumberLabel;
@property (weak, nonatomic) IBOutlet UILabel *quantityLabel;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UILabel *defaultAddressLabel;
@property (strong,nonatomic)SendAddressItem *myAddress;
- (IBAction)changeAddress:(id)sender;
- (IBAction)confirm:(id)sender;
- (IBAction)cancel:(id)sender;


@end
@implementation XiangSendViewController
-(void)viewDidLoad
{
    [super viewDidLoad];
    self.keyLabel.text=self.xiang.key;
    self.partNumberLabel.text=self.xiang.number;
    self.quantityLabel.text=self.xiang.count;
    self.dateLabel.text=self.xiang.date;
    self.keyLabel.adjustsFontSizeToFitWidth=YES;
    self.partNumberLabel.adjustsFontSizeToFitWidth=YES;
    self.quantityLabel.adjustsFontSizeToFitWidth=YES;
    self.dateLabel.adjustsFontSizeToFitWidth=YES;
    self.myAddress=[[SendAddress sharedSendAddress] defaultAddress];
    self.defaultAddressLabel.adjustsFontSizeToFitWidth=YES;
    
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    //self.defaultAddressLabel.text=self.myAddress.name;
}
- (IBAction)changeAddress:(id)sender {
    [self performSegueWithIdentifier:@"changeAddress" sender:self];
}

- (IBAction)confirm:(id)sender {
    AFNetOperate *AFNet=[[AFNetOperate alloc] init];
    AFHTTPRequestOperationManager *manager=[AFNet generateManager:self.view];
    [AFNet.activeView stopAnimating];
    [manager POST:[AFNet xiang_send]
       parameters:@{
                    @"id":self.xiang.ID,
                    @"destination_id":self.myAddress.id
                    }
          success:^(AFHTTPRequestOperation *operation, id responseObject) {
              [AFNet.activeView stopAnimating];
              if(self.xiangArray){
                  [self.xiangArray removeObjectAtIndex:self.xiangIndex];
              }
              [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:([self.navigationController.viewControllers count] -3)] animated:YES];

          }
          failure:^(AFHTTPRequestOperation *operation, NSError *error) {
              [AFNet.activeView stopAnimating];
              [AFNet alert:[NSString stringWithFormat:@"%@",[error localizedDescription]]];
          }
     ];
    
}

- (IBAction)cancel:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if([segue.identifier isEqualToString:@"changeAddress"]){
        DefaultAddressTableViewController *address=segue.destinationViewController;
        address.myAddress=self.myAddress;
    }
}
@end
