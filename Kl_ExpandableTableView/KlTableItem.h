//
//  KlTableItem.h
//  Kl_ExpandableTableView
//
//  Created by Lin Guiwei on 12/6/16.
//  Copyright © 2016 kevinLIN. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface KlTableItem : NSObject

@property(nonatomic, assign) BOOL isExpandable;//required
@property(nonatomic, strong) NSArray *arr_subItems;//optional

@end
