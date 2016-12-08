//
//  EvAutoExpandableTableVIew.h
//
//  Created by Guiwei LIN on 1/7/16.
//
//

#import <UIKit/UIKit.h>
@class KLExpandTableView;


typedef enum {
    KLTableviewStyleDefault,
    KLTableviewStyleGroup
}KlTableviewStyle;


@protocol KlExpandTableViewDelegate <NSObject>

@required
- (NSInteger)tableView:(KLExpandTableView *)tableView numberOfSubRowsAtIndexPath:(NSInteger)section;
- (UITableViewCell *)tableView:(KLExpandTableView *)tableView cellForSubRowAtIndexPath:(NSIndexPath *)indexPath;
- (CGFloat)tableView:(KLExpandTableView *)tableView heightForSubRowAtIndexPath:(NSIndexPath *)indexPath;
- (NSInteger)numberOfSectionsInTableView:(KLExpandTableView *)tableView;


@optional
- (void)tableView:(KLExpandTableView *)tableView didSelectSubRowAtIndexPath:(NSIndexPath *)indexPath;
- (void)selectItemAtIndex:(NSIndexPath *)indexPath;

@end

@interface KLExpandTableView : UITableView

@property (nonatomic,assign) id<KlExpandTableViewDelegate> expandDelegate;

- (void)reloadCurrentDataWithNewArray:(NSArray *)arr_data;
- (id)initDefaultSettingWithTableViewStyle:(KlTableviewStyle)style inSuperView:(UIView *)superView withDelegate:(id)delegate;


@end
