//
//  AFNetOperate.h
//  Material
//
//  Created by wayne on 14-6-10.
//  Copyright (c) 2014年 brilliantech. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AFNetOperate : NSObject
@property(strong, nonatomic) UIActivityIndicatorView *activeView;
// method
- (AFHTTPRequestOperationManager *)generateManager:(UIView *)view;
- (void)alert:(id)content;
- (void)alertSuccess:(NSString *)string;
- (void)setKeyArchive:(NSString *)path
             keyArray:(NSArray *)keyArray
          objectArray:(NSArray *)objectArray;
- (id)getKeyArchive:(NSString *)path key:(NSString *)key;
// get URL
- (NSString *)part_validate;
- (NSString *)part_quantity_validate;

- (NSString *)xiang_index;
- (NSString *)xiang_root;
- (NSString *)xiang_edit:(NSString *)id;
- (NSString *)xiang_validate;
- (NSString *)xiang_check;
- (NSString *)xiang_uncheck;
- (NSString *)xiang_confirm_receive;
- (NSString *)xiang_received;
- (NSString *)xiang_send;
- (NSString *)xiang_receive;
- (NSString *)xiang_reject;

- (NSString *)tuo_index;
- (NSString *)tuo_root;
- (NSString *)tuo_edit:(NSString *)id;
- (NSString *)tuo_single;
- (NSString *)tuo_bundle_add;
- (NSString *)tuo_key_for_bundle;
- (NSString *)tuo_remove_xiang;
- (NSString *)tuo_confirm_receive;
- (NSString *)tuo_received;
- (NSString *)tuo_packages;
- (NSString *)tuo_send;
- (NSString *)tuo_receive;

- (NSString *)yun_index;
- (NSString *)yun_root;
- (NSString *)yun_edit:(NSString *)id;
- (NSString *)yun_single;
- (NSString *)yun_add_tuo_by_scan;
- (NSString *)yun_remove_tuo;
- (NSString *)yun_add_tuo;
- (NSString *)yun_send;
- (NSString *)yun_receive;
- (NSString *)yun_received;
- (NSString *)yun_confirm_receive;
- (NSString *)yun_folklifts;

- (NSString *)storages_move_store;

- (NSString *)log_in;
- (NSString *)log_out;
// PRINT
- (NSString *)print_stock_xiang:(NSString *)ID
                   printer_name:(NSString *)printer
                         copies:(NSString *)copies;
- (NSString *)print_stock_tuo:(NSString *)ID
                 printer_name:(NSString *)printer
                       copies:(NSString *)copies;
- (NSString *)print_stock_yun:(NSString *)ID
                 printer_name:(NSString *)printer
                       copies:(NSString *)copies;

- (NSString *)print_shop_xiang_receive:(NSString *)ID
                          printer_name:(NSString *)printer
                                copies:(NSString *)copies;
- (NSString *)print_shop_xiang_unreceive:(NSString *)ID
                            printer_name:(NSString *)printer
                                  copies:(NSString *)copies;
- (NSString *)print_shop_tuo_receive:(NSString *)ID
                        printer_name:(NSString *)printer
                              copies:(NSString *)copies;
- (NSString *)print_shop_tuo_unreceive:(NSString *)ID
                          printer_name:(NSString *)printer
                                copies:(NSString *)copies;
- (NSString *)print_shop_yun_receive:(NSString *)ID
                        printer_name:(NSString *)printer
                              copies:(NSString *)copies;
- (NSString *)print_shop_yun_unreceive:(NSString *)ID
                          printer_name:(NSString *)printer
                                copies:(NSString *)copies;

- (NSString *)print_transfer_note:(NSString *)ID
                     printer_name:(NSString *)printer
                           copies:(NSString *)copies;

- (NSString *)print_model_list;
- (NSString *)get_current_print_model;
- (void)set_tuo_copy:(NSString *)copy;
- (void)set_yun_copy:(NSString *)copy;
- (void)set_yun_uncheck_copy:(NSString *)copy;
- (void)set_transfer_note_copy:(NSString *)copy;
- (NSString *)get_tuo_copy;
- (NSString *)get_yun_copy;
- (NSString *)get_yun_uncheck_copy;
- (NSString *)get_transfer_note_copy;

- (NSString *)scan_validate;

- (NSString *)version;

- (NSString *)order_root;
- (NSString *)order_history;
- (NSString *)order_check_part;

- (NSString *)order_item_root;
- (NSString *)order_item_verify;

- (NSString *)baseURLWithoutPort;

- (NSString *)order_led_reset;
- (NSString *)order_led_position_state;
- (NSString *)order_led_state_list;

- (NSString *)send_address;

- (NSString *)movables;

- (NSString *)locations_warehosues;
- (NSString *)inventory_processing;
- (NSString *)check_stock;
- (NSString *)inventory_list_item;
- (NSString *)move;

- (NSString *)get_positions;

/**
 *  盘点， 移库改造
 *
 /




/**
 *  创建移库清单id
 *
 *  @return <#return value description#>
 */
- (NSString *)CreateMovementList;

- (NSString *)GetMovementList;

/**
 *  验证移库参数
 *
 *  @return <#return value description#>
 */
- (NSString *)ValidateMovement;
/**
 *  保存移库
 *
 *  @return <#return value description#>
 */
- (NSString *)SaveMovement;
/**
 *  查看移库单
 *
 *  @return <#return value description#>
 */
- (NSString *)GetMovement;
/**
 *  查看移库记录
 *
 *  @return <#return value description#>
 */
- (NSString *)GetMovementDetail;

/**
 *  删除移库
 *
 *  @return <#return value description#>
 */
- (NSString *)DeleteMovementList;

/**
 *  给某个盘点单生成一个盘点项
 *
 *  @return <#return value description#>
 */
- (NSString *)CreateInventoryListItem;

/**
 *  返回的是一个盘点单锁盘点的库位LIST
 *
 *  @return <#return value description#>
 */
- (NSString *)InventoryListPosition;

/**
 *  返回一个盘点单里已经盘点的记录详细
 *
 *  @return <#return value description#>
 */
- (NSString *)InventoryListConditionItem;

/**
 *  更新一个盘点项的内容

 *
 *  @return <#return value description#>
 */
- (NSString *)UpdateInventoryListItems;
/**
 *  删除一个盘点项
 *
 *  @return <#return value description#>
 */
- (NSString *)DeleteInventoryListItems;

/**
 *  获取一个唯一码的详细信息
 *
 *  @return <#return value description#>
 */
- (NSString *)GetPackageInfo;

/**
 *  移库单打印
 *
 *  @param ID      <#ID description#>
 *  @param printer <#printer description#>
 *  @param copies  <#copies description#>
 *
 *  @return <#return value description#>
 */
- (NSString *)print_movenment_list_receive:(NSString *)ID
                              printer_name:(NSString *)printer
                                    copies:(NSString *)copies;

- (NSString *)getMovementResources;

@end
