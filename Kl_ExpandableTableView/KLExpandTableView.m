//
//  EvAutoExpandableTableVIew.m
//
//  Created by Guiwei LIN on 1/7/16.
//
//

#import "KLExpandTableView.h"
#import "KlTableItem.h"

#define CELL_HEIGHT 60
#define TABLEVIEW_VIEW_NAME @"tbv_main"
#define PROPERTY_EXPANDABLE @"isExpandable"

#define IOS_VERSION [[[UIDevice currentDevice] systemVersion] floatValue]

@interface KLExpandTableView()<UITableViewDataSource, UITableViewDelegate> {
    KlTableviewStyle        tableViewStyle;
    NSMutableDictionary     *mdic_bindView;
    NSIndexPath             *ip_selectedIndex;
    NSMutableArray          *rowToInsert;
    NSInteger               iSubrowsCount;
}

@property(nonatomic, strong)NSArray *arr_items;
@end

@implementation KLExpandTableView

- (id)initDefaultSettingWithTableViewStyle:(KlTableviewStyle)style inSuperView:(UIView *)superView withDelegate:(id)delegate {
    switch (style) {
        case KLTableviewStyleDefault: {
            self = [super initWithFrame:CGRectZero style:UITableViewStylePlain];
            break;
        }
        case KLTableviewStyleGroup: {
            self = [super initWithFrame:CGRectZero style:UITableViewStyleGrouped];
            break;
        }
        default: {
            self = [super initWithFrame:CGRectZero style:UITableViewStylePlain];
            break;
        }
    }
    
    if (self) {
        [self setTranslatesAutoresizingMaskIntoConstraints:NO];
        
        self.delegate = self;
        self.dataSource = self;
        
        self.expandDelegate = delegate;
        
        if(![[superView subviews] containsObject:self]) {//avoid multiple add
            [superView addSubview:self];
        }
    
        [self setUpContent];
    }
    
    return self;
}

- (void)setUpContent {//vfl + autolayout
    if(self.superview != nil) {
        mdic_bindView = [[NSMutableDictionary alloc] initWithCapacity:5];
        
        //**bind self view和superview
        [mdic_bindView setObject:self forKey:[NSString stringWithFormat:@"%@",TABLEVIEW_VIEW_NAME]]; //bind views based on key value
        
        if(IOS_VERSION <= 8.0) {
            [self.superview removeConstraints:[self.superview constraints]];
            [self.superview addConstraint:[NSLayoutConstraint constraintWithItem:self
                                                                       attribute:NSLayoutAttributeWidth
                                                                       relatedBy:NSLayoutRelationEqual
                                                                          toItem:self.superview
                                                                       attribute:NSLayoutAttributeWidth
                                                                      multiplier:1.0
                                                                        constant:0]];//width equal
            float defaultValue = 1.0;
            
            //[superview setTranslatesAutoresizingMaskIntoConstraints:NO];
            [self.superview addConstraint:[NSLayoutConstraint constraintWithItem:self
                                                                       attribute:NSLayoutAttributeHeight
                                                                       relatedBy:NSLayoutRelationEqual
                                                                          toItem:self.superview
                                                                       attribute:NSLayoutAttributeHeight
                                                                      multiplier:defaultValue
                                                                        constant:0]];//height equal
        }
        
        //horizontal
        NSString *format_view_h = [NSString stringWithFormat:@"H:|-0-[%@]-0-|",TABLEVIEW_VIEW_NAME];
        [self.superview addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:format_view_h
                                                                               options: 0
                                                                               metrics:nil
                                                                                 views:mdic_bindView]];
        //vertical
        NSString *format_view_v =
        [NSString stringWithFormat:@"V:|-(0)-[%@]|", TABLEVIEW_VIEW_NAME];
        [self.superview addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:format_view_v
                                                                               options:0
                                                                               metrics:nil
                                                                                 views:mdic_bindView]];
        
        rowToInsert = [[NSMutableArray alloc] initWithCapacity:5];
    }
}

#pragma mark - tableview delegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if([self.expandDelegate respondsToSelector:@selector(tableView:heightForSubRowAtIndexPath:)]) {
        return [self.expandDelegate tableView:self heightForSubRowAtIndexPath:indexPath];
    }
    else {
        return CELL_HEIGHT;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self didSelectOptionMoreInIndexPathAtRow:indexPath];
    if([self.expandDelegate respondsToSelector:@selector(selectItemAtIndex:)]) {
        [self.expandDelegate selectItemAtIndex:indexPath];
    }
}

#pragma mark - tableview datasource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if([self.expandDelegate respondsToSelector:@selector(tableView:numberOfSubRowsAtIndexPath:)]) {
        return [self.expandDelegate tableView:self numberOfSubRowsAtIndexPath:section];
    }
    return 0;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if([self.expandDelegate respondsToSelector:@selector(numberOfSectionsInTableView:)]) {
        return [self.expandDelegate numberOfSectionsInTableView:self];
    }
    
    return  0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if([self.expandDelegate respondsToSelector:@selector(tableView:cellForSubRowAtIndexPath:)]) {
        return [self.expandDelegate tableView:self cellForSubRowAtIndexPath:indexPath];
    }
    else {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
        if(cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
        }
        cell.textLabel.text = [NSString stringWithFormat:@"Item %ld", indexPath.section];
        if(indexPath.row == 1) {
            cell.textLabel.text = @"expandable cell";
        }
        return  cell;
    }
}

#pragma mark - KLExpandTableView medthods
- (void)reloadCurrentDataWithNewArray:(NSArray *)arr_data {
    _arr_items = arr_data;
    [self reloadData];
}


//collapse all other cells except selected one
- (void)resetOtherExpandableCell {
    [_arr_items enumerateObjectsUsingBlock:^(id item, NSUInteger index, BOOL *stop) {
        if(index != ip_selectedIndex.section) {
            if ([item respondsToSelector:NSSelectorFromString(PROPERTY_EXPANDABLE)] && item != NULL) {
                [self removeCollapseCells:item atIndex:index];
            }
            else {
                return ;
            }
        }
    }];
}

//collapse all cells
- (void)resetDatacellStatusToUnexpandable {
    [self beginUpdates];
    [_arr_items enumerateObjectsUsingBlock:^(id item, NSUInteger index, BOOL *stop) {
        if ([item respondsToSelector:NSSelectorFromString(PROPERTY_EXPANDABLE)] && item != NULL) {
            [self removeCollapseCells:item atIndex:index];
        }
        else {
            return ;
        }
    }];
    [self endUpdates];
}

//collapse cells
- (void)removeCollapseCells:(id)item atIndex:(NSInteger)index{
    if([[item valueForKey:PROPERTY_EXPANDABLE] intValue] == 1) {
        NSMutableArray* rowToDelete = [[NSMutableArray alloc] init];
        for(int i = 1; i < [self.expandDelegate tableView:self numberOfSubRowsAtIndexPath:index]; i++) {
            NSIndexPath* indexPathToDelete= [NSIndexPath indexPathForRow:i inSection:index];
            [rowToDelete addObject:indexPathToDelete];
        }
        [self deleteRowsAtIndexPaths:rowToDelete withRowAnimation:UITableViewRowAnimationFade];
        
        [item setValue:@"0" forKey:PROPERTY_EXPANDABLE];//reset expandable to 0, thus return  row number of  1
    }
}

//expand the selected cell
- (void)didSelectOptionMoreInIndexPathAtRow:(NSIndexPath *)indexPath {
    [self beginUpdates];
    if(indexPath.row  == 0) {
        id item = [_arr_items objectAtIndex:indexPath.section];
        
        if ([item respondsToSelector:NSSelectorFromString(PROPERTY_EXPANDABLE)]) {
            if([[item valueForKey:PROPERTY_EXPANDABLE] intValue] == 1) {
                [item setValue:@"0" forKey:PROPERTY_EXPANDABLE];
            }
            else {
                [item setValue:@"1" forKey:PROPERTY_EXPANDABLE];
            }
        }
        else {
            return ;
        }
        
        if(![self.expandDelegate respondsToSelector:@selector(tableView:numberOfSubRowsAtIndexPath:)]) {
            return ;
        }
   
        ip_selectedIndex = indexPath;
        
        [rowToInsert removeAllObjects];
        
        if ([item respondsToSelector:NSSelectorFromString(PROPERTY_EXPANDABLE)]) {
            if([[item valueForKey:PROPERTY_EXPANDABLE] intValue] == 1) {
                //keep the added row number, need to remove the exact number of row afterwards.
                iSubrowsCount = [self.expandDelegate tableView:self numberOfSubRowsAtIndexPath:indexPath.section];

                for (NSUInteger i = 1; i < iSubrowsCount; i++) {
                    NSIndexPath* indexPathToInsert = [NSIndexPath indexPathForRow:i inSection:indexPath.section];
                    [rowToInsert addObject:indexPathToInsert];
                }
                [self insertRowsAtIndexPaths:rowToInsert withRowAnimation:UITableViewRowAnimationTop];
            }
            else {
                for (NSUInteger i = 1; i < iSubrowsCount; i++) { //remove exact number of rows insterted before
                    NSIndexPath* indexPathToInsert = [NSIndexPath indexPathForRow:i inSection:indexPath.section];
                    [rowToInsert addObject:indexPathToInsert];
                }

                [self deleteRowsAtIndexPaths:rowToInsert withRowAnimation:UITableViewRowAnimationTop];
            }
        }

        [self resetOtherExpandableCell];
    }
    [self endUpdates];
    if(indexPath.section == [_arr_items count] - 1){
        [self scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:indexPath.section] atScrollPosition:UITableViewScrollPositionTop animated:YES];
    }
}


@end
