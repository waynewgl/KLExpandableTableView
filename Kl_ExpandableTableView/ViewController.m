//
//  ViewController.m
//  Kl_ExpandableTableView
//
//  Created by Lin Guiwei on 12/6/16.
//  Copyright © 2016 kevinLIN. All rights reserved.
//

#import "ViewController.h"
#import "KlExpandTableView.h"
#import "KlTableItem.h"

@interface ViewController ()<KlExpandTableViewDelegate> {
    NSArray *arr_items;
    IBOutlet UIView *v_sub;
}

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    KLExpandTableView *tbv_songs = [[KLExpandTableView alloc] initDefaultSettingWithTableViewStyle:KLTableviewStyleDefault inSuperView:self.view withDelegate:self];
   
    NSMutableArray *mar_items = [[NSMutableArray alloc] initWithCapacity:5];
    
    //note: object KlTableItem can be as customised as you want, however, property 'isExpandable' is always necessary.
    for(int i=0; i<10; i++) {
        KlTableItem *item = [[KlTableItem alloc] init];
        
        NSMutableArray *mar_subItem = [[NSMutableArray alloc] initWithCapacity:5];
        for(int i=0; i<4; i++) {
            [mar_subItem addObject:[NSString stringWithFormat:@"%@_%d", @"cell", i]];
        }
        
        item.arr_subItems = mar_subItem;
        [mar_items addObject:item];
    }
    
    arr_items = mar_items;
    [tbv_songs reloadCurrentDataWithNewArray:arr_items];
}

#pragma mark  expandable table view datasource
- (UITableViewCell *)tableView:(KLExpandTableView *)tableView cellForSubRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if(cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    
    KlTableItem *item = [arr_items objectAtIndex:indexPath.section];
    if(item.isExpandable) {
        cell.textLabel.text = [NSString stringWithFormat:@"%@-%@", @"expandable ", item.arr_subItems[indexPath.row - 1]];
    }
    else {
        cell.textLabel.text = [NSString stringWithFormat:@"Item %ld", indexPath.section];
    }
    
    return  cell;
}

- (CGFloat)tableView:(KLExpandTableView *)tableView heightForSubRowAtIndexPath:(NSIndexPath *)indexPath {
    return 80;
}

- (NSInteger)tableView:(KLExpandTableView *)tableView numberOfSubRowsAtIndexPath:(NSInteger)section {
    KlTableItem *item = [arr_items objectAtIndex:section];
    if(item.isExpandable) {
        return [item.arr_subItems count] + 1;
    }
    else {
        return 1;
    }
}

- (NSInteger)numberOfSectionsInTableView:(KLExpandTableView *)tableView {
    return [arr_items count];
}

#pragma mark  expandable table view delegate
- (void)tableView:(KLExpandTableView *)tableView didSelectSubRowAtIndexPath:(NSIndexPath *)indexPath {
    KlTableItem *item = [arr_items objectAtIndex:indexPath.section];
    if(indexPath.row != 0) {//click collaspe cells
        NSLog(@"clicking item  %@ - %@",indexPath, item.arr_subItems[indexPath.row - 1]);
    }else {
        NSLog(@"clicking item  %@",indexPath);
    }
    
}

// Dispose of any resources that can be recreated.
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
