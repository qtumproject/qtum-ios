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
    } else if ([tag.name isEqualToString:@"p"]) {
        cell = [self createParagrafTagItem:tag fromTable:tableView withIndexPath:indexPath];
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

-(UITableViewCell*)createParagrafTagItem:(QTUMHTMLTagItem*)tag
                                 fromTable:(UITableView*) tableView
                             withIndexPath:(NSIndexPath*) indexPath {
    
    NSMutableAttributedString* attrib = tag.attributedContent.mutableCopy;
    [attrib beginEditing];
    [attrib enumerateAttribute:NSFontAttributeName inRange:NSMakeRange(0, attrib.length) options:0 usingBlock:^(id value, NSRange range, BOOL *stop) {
        if (value) {
            UIFont *oldFont = (UIFont *)value;
            /*----- Remove old font attribute -----*/
            [attrib removeAttribute:NSFontAttributeName range:range];
            //replace your font with new.
            /*----- Add new font attribute -----*/
            UIFont* font = [UIFont fontWithName:@"simplonmono-regular" size:16];
            UIFont* boldFont = [UIFont fontWithName:@"simplonmono-medium" size:18];
            
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
            UIColor* color = customBlueColor();
            [attrib addAttribute:NSForegroundColorAttributeName value:color range:range];
        }
    }];
    
    [attrib endEditing];

    QTUMParagrafTagCell *cell = [tableView dequeueReusableCellWithIdentifier:QTUMParagrafTagCellReuseIdentifire];
    
    cell.textView.attributedText = attrib;
    cell.textView.linkTextAttributes = @{NSForegroundColorAttributeName : customRedColor(),
                                         NSUnderlineStyleAttributeName : @(NSUnderlineStyleNone),
                                         NSUnderlineColorAttributeName : [UIColor clearColor]
                                         };
    [cell.textView sizeToFit];
    return cell;
}

- (NSAttributedString *)attributedStringWithHTML:(NSString *)HTML {
    
    NSDictionary *options = @{ NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType };
    return [[NSAttributedString alloc] initWithData:[HTML dataUsingEncoding:NSUTF8StringEncoding] options:options documentAttributes:NULL error:NULL];
}

@end

