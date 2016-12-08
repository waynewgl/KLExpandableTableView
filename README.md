# KLExpandableTableView
expandable tableview -ios

1.  //customised tableview which provides expandable cells function  
   KLExpandTableView *tbv_songs = [[KLExpandTableView alloc] initDefaultSettingWithTableViewStyle:KLTableviewStyleDefault inSuperView:self.view withDelegate:self];
   
    NSMutableArray *mar_items = [[NSMutableArray alloc] initWithCapacity:5];
    
    //note: object KlTableItem can be as customised as you want, however, property 'isExpandable' is always necessary.
    for(int i=0; i<10; i++) {
        KlTableItem *item = [[KlTableItem alloc] init];
        [mar_items addObject:item];
    }
    
    arr_items = mar_items;
    [tbv_songs reloadCurrentDataWithNewArray:arr_items];
    
    
    
2.implement the following delegate datasource methods

//number of expandable rows
- (NSInteger)tableView:(KLExpandTableView *)tableView numberOfSubRowsAtIndexPath:(NSInteger)section;

//table cells
- (UITableViewCell *)tableView:(KLExpandTableView *)tableView cellForSubRowAtIndexPath:(NSIndexPath *)indexPath;

//height for rows
- (CGFloat)tableView:(KLExpandTableView *)tableView heightForSubRowAtIndexPath:(NSIndexPath *)indexPath;

//number of table view sections, i.e.  number of objects
- (NSInteger)numberOfSectionsInTableView:(KLExpandTableView *)tableView;

3. demo uses 'KlTableItem' as example obj, you can use your own object as replacement, however, 'isExpandable' is required to implement the collaspe feature.
