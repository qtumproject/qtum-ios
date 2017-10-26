//
//  NewsCellBuilder.h
//  qtum wallet
//
//  Created by Vladimir Lebedevich on 19.10.17.
//  Copyright © 2017 QTUM. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "QTUMHTMLTagItem.h"

@interface NewsDetailCellBuilder : NSObject

-(UITableViewCell*)getCellWithTagItem:(QTUMHTMLTagItem*)tag fromTable:(UITableView*) tableView withIndexPath:(NSIndexPath*) indexPath;
@end
