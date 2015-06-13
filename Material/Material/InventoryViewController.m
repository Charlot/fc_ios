//
//  InventoryViewController.m
//  Material
//
//  Created by exmooncake on 15-6-13.
//  Copyright (c) 2015年 brilliantech. All rights reserved.
//

#import "InventoryViewController.h"
#import "AFNetOperate.h"
#import "Inventory.h"

@interface InventoryViewController ()<UIPickerViewDataSource, UIPickerViewDelegate>
{
    NSMutableArray *_dataList;
    NSArray *_pickerData;
}
@property (strong, nonatomic) IBOutlet UIPickerView *processingPicker;

@end

@implementation InventoryViewController

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
    
    _pickerData = @[@"Item1", @"Item2", @"Item3"];
    [self getProcessingData];
	// Do any additional setup after loading the view.
    self.processingPicker.dataSource =self;
    self.processingPicker.delegate = self;
    
}


- (void)getProcessingData
{
    _dataList = [[NSMutableArray alloc] init];
    AFNetOperate *AFNet=[[AFNetOperate alloc] init];
    AFHTTPRequestOperationManager *manager=[AFNet generateManager:self.view];
    [manager GET:[AFNet inventory_processing]
       parameters:nil
          success:^(AFHTTPRequestOperation *operation, id responseObject) {
              [AFNet.activeView stopAnimating];
              if([responseObject[@"result"] integerValue]==1){
                  if([(NSArray *)responseObject[@"content"] count]>0){
                      NSArray *inventoryArray=responseObject[@"content"];
                      
                      for (int i=0; i<inventoryArray.count; i++) {
                          Inventory *inventory = [[Inventory alloc] initWithObject:inventoryArray[i]];
                          
                          [_dataList addObject: inventory];
                          
                      }
                      [self.processingPicker reloadAllComponents];
                      
                  }
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


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (int)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

// The number of rows of data
- (int)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
//   return _pickerData.count;
   return [_dataList count];
    
}

// The data to return for the row and component (column) that's being passed in
- (NSString*)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
//    return _pickerData[row];
    Inventory *inventory = [[Inventory alloc] init];
    inventory = _dataList[row];
    NSString *strFromInt = [NSString stringWithFormat:@"%d",[_dataList count]];
    NSLog(strFromInt);
    
    return inventory.name;
}


@end
