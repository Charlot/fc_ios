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
                        CaptuvoEventsProtocol, UITextFieldDelegate,
                        UISearchBarDelegate>
@property(strong, nonatomic) NSString *inventory_list_id;
@end
