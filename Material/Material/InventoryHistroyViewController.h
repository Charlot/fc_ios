//
//  InventoryHistroyViewController.h
//  Material
//
//  Created by ryan on 11/23/15.
//  Copyright © 2015 brilliantech. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Inventory.h"

@interface InventoryHistroyViewController
    : UIViewController <UITableViewDelegate, UITableViewDataSource,
                        CaptuvoEventsProtocol, UITextFieldDelegate>
@property(strong, nonatomic) NSString *inventroy_id;
@end
