//
//  NewsDetailCellBuilder.m
//  qtum wallet
//
//  Created by Никита Федоренко on 19.10.17.
//  Copyright © 2017 QTUM. All rights reserved.
//

#import "NewsDetailCellBuilder.h"
#import "QTUMDefaultTagCell.h"
#import "QTUMImageTagCell.h"
#import "UIImageView+AFNetworking.h"
#import "ServiceLocator.h"

@implementation NewsDetailCellBuilder

-(UITableViewCell*)getCellWithTagItem:(QTUMHTMLTagItem*)tag fromTable:(UITableView*) tableView withIndexPath:(NSIndexPath*) indexPath {
    
    UITableViewCell* cell;
    if ([tag.name isEqualToString:@"figure"]) {
        cell = [self createFigureWithTagItem:tag fromTable:tableView withIndexPath:indexPath];
    }
    
    if (!cell) {
        QTUMDefaultTagCell *cell = [tableView dequeueReusableCellWithIdentifier:QTUMDefaultTagCellReuseIdentifire];
        cell.contentLabel.text = tag.content;
        return cell;
    } else {
        return cell;
    }
}

-(UITableViewCell*)createFigureWithTagItem:(QTUMHTMLTagItem*)tag
                                 fromTable:(UITableView*) tableView
                             withIndexPath:(NSIndexPath*) indexPath {
    
    NSArray<QTUMHTMLTagItem*>*childrens = tag.childrenTags;
    QTUMHTMLTagItem* imageTag;
    
    for (QTUMHTMLTagItem* childrenTag in childrens) {
        
        if ([childrenTag.name isEqualToString:@"img"]) {
            imageTag = childrenTag;
            break;
        }
    }
    
    if (imageTag) {
        
        QTUMImageTagCell *cell = [tableView dequeueReusableCellWithIdentifier:QTUMImageTagCellReuseIdentifire];
        
        
        NSString *urlString = imageTag.attributes[@"src"];
        
        __weak QTUMImageTagCell *weakCell = cell;
        
        cell.tagImageView.associatedObject = urlString;
        
        [SLocator.imageLoader getImageWithUrl:urlString withResultHandler:^(UIImage *image) {
            
            if ([weakCell.tagImageView.associatedObject isEqualToString:urlString] && image) {
                
                weakCell.tagImageView.contentMode = UIViewContentModeScaleAspectFit;
                weakCell.tagImageView.image = image;
            }
        }];
        
        return cell;
    }

    return nil;
}

@end

