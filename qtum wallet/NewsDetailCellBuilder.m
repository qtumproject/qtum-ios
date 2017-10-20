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

@implementation NewsDetailCellBuilder

-(UITableViewCell*)getCellWithTagItem:(QTUMHTMLTagItem*)tag fromTable:(UITableView*) tableView {
    
    if ([tag.name isEqualToString:@"figure"]) {
        
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
            
            NSURL *url = [NSURL URLWithString:imageTag.attributes[@"src"]];
            NSURLRequest *request = [NSURLRequest requestWithURL:url];
//            UIImage *placeholderImage = [UIImage imageNamed:@"your_placeholder"];
            
            __weak QTUMImageTagCell *weakCell = cell;
            
            [cell.tagImageView setImageWithURLRequest:request
                                  placeholderImage:nil
                                           success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
                                               
                                               weakCell.tagImageView.image = image;
                                               [weakCell setNeedsLayout];
                                               
                                           } failure:nil];
            return cell;
        } 
    }
    
    QTUMDefaultTagCell *cell = [tableView dequeueReusableCellWithIdentifier:QTUMDefaultTagCellReuseIdentifire];
    
    cell.contentLabel.text = tag.content;
    return cell;
}

@end

