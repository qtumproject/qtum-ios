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
#import "QTUMParagrafTagCell.h"

@implementation NewsDetailCellBuilder

-(UITableViewCell*)getCellWithTagItem:(QTUMHTMLTagItem*)tag fromTable:(UITableView*) tableView withIndexPath:(NSIndexPath*) indexPath {
    
    UITableViewCell* cell;
    if ([tag.name isEqualToString:@"figure"]) {
        cell = [self createFigureWithTagItem:tag fromTable:tableView withIndexPath:indexPath];
    } else if ([tag.name isEqualToString:@"p"] || [tag.name isEqualToString:@"h3"] || [tag.name isEqualToString:@"blockquote"]){
        cell = [self createParagrafTagItem:tag fromTable:tableView withIndexPath:indexPath];
    } if ([tag.name isEqualToString:@"img"]) {
        cell = [self createImageWithTagItem:tag fromTable:tableView withIndexPath:indexPath];
    }
    
    if ([tag.name isEqualToString:@"iframe"]) {
        cell = [self createIframeTagItem:tag fromTable:tableView withIndexPath:indexPath];
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

-(UITableViewCell*)createImageWithTagItem:(QTUMHTMLTagItem*)tag
                                 fromTable:(UITableView*) tableView
                             withIndexPath:(NSIndexPath*) indexPath {
    
    QTUMHTMLTagItem* imageTag = tag;
    
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

-(UITableViewCell*)createParagrafTagItem:(QTUMHTMLTagItem*)tag
                                 fromTable:(UITableView*) tableView
                             withIndexPath:(NSIndexPath*) indexPath {
    
    QTUMParagrafTagCell *cell = [tableView dequeueReusableCellWithIdentifier:QTUMParagrafTagCellReuseIdentifire];

    UIFont* font = [cell regularFont];
    UIFont* boldFont = [cell boldFont];
    UIColor* textColor = [cell textColor];

    NSMutableAttributedString* attrib = tag.attributedContent.mutableCopy;
    [attrib beginEditing];
    [attrib enumerateAttribute:NSFontAttributeName inRange:NSMakeRange(0, attrib.length) options:0 usingBlock:^(id value, NSRange range, BOOL *stop) {
        if (value) {
            UIFont *oldFont = (UIFont *)value;
            /*----- Remove old font attribute -----*/
            [attrib removeAttribute:NSFontAttributeName range:range];
            //replace your font with new.
            /*----- Add new font attribute -----*/


            if ([oldFont.fontName isEqualToString:@"TimesNewRomanPSMT"])
                [attrib addAttribute:NSFontAttributeName value:font range:range];
            else if([oldFont.fontName isEqualToString:@"TimesNewRomanPS-BoldMT"])
                [attrib addAttribute:NSFontAttributeName value:boldFont range:range];
            else if([oldFont.fontName isEqualToString:@"TimesNewRomanPS-ItalicMT"])
                [attrib addAttribute:NSFontAttributeName value:font range:range];
            else if([oldFont.fontName isEqualToString:@"TimesNewRomanPS-BoldItalicMT"])
                [attrib addAttribute:NSFontAttributeName value:boldFont range:range];
            else
                [attrib addAttribute:NSFontAttributeName value:font range:range];
        }
    }];

    [attrib enumerateAttribute:NSForegroundColorAttributeName inRange:NSMakeRange(0, attrib.length) options:0 usingBlock:^(id value, NSRange range, BOOL *stop) {
        if (value) {

            [attrib removeAttribute:NSForegroundColorAttributeName range:range];
            UIColor* color = textColor;
            [attrib addAttribute:NSForegroundColorAttributeName value:color range:range];
        }
    }];

    [attrib endEditing];

    cell.textView.linkTextAttributes = @{NSForegroundColorAttributeName : [cell linkColor],
                                         NSUnderlineStyleAttributeName : @(NSUnderlineStyleNone),
                                         NSUnderlineColorAttributeName : [UIColor clearColor]
                                         };

    cell.textView.attributedText = attrib;

    return cell;
}

-(UITableViewCell*)createIframeTagItem:(QTUMHTMLTagItem*)tag
                               fromTable:(UITableView*) tableView
                           withIndexPath:(NSIndexPath*) indexPath {
    
    QTUMParagrafTagCell *cell = [tableView dequeueReusableCellWithIdentifier:QTUMParagrafTagCellReuseIdentifire];
    
    UIFont* font = [cell regularFont];
    UIFont* boldFont = [cell boldFont];
    UIColor* textColor = [cell textColor];
    
    NSMutableAttributedString * attrib = [[NSMutableAttributedString alloc] initWithString:tag.content];
//    [attrib addAttribute: NSLinkAttributeName value:tag.content range: NSMakeRange(0, attrib.length)];
    
    [attrib beginEditing];
    
    [attrib enumerateAttribute:NSForegroundColorAttributeName inRange:NSMakeRange(0, attrib.length) options:0 usingBlock:^(id value, NSRange range, BOOL *stop) {
        if (value) {
            
            [attrib removeAttribute:NSForegroundColorAttributeName range:range];
            UIColor* color = textColor;
            [attrib addAttribute:NSForegroundColorAttributeName value:color range:range];
            [attrib addAttribute:NSFontAttributeName value:boldFont range:range];
        }
    }];
    
    [attrib endEditing];
    
    cell.textView.linkTextAttributes = @{NSForegroundColorAttributeName : [cell linkColor],
                                         NSUnderlineStyleAttributeName : @(NSUnderlineStyleNone),
                                         NSUnderlineColorAttributeName : [UIColor clearColor],
                                         NSFontAttributeName : boldFont
                                         };
    cell.textView.dataDetectorTypes = UIDataDetectorTypeLink;
    cell.textView.attributedText = attrib;
    
    return cell;
}

@end

