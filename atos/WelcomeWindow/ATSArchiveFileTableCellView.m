//
//  ATSArchiveFileTableCellView.m
//  atos
//
//  Created by eyeplum on 4/20/14.
//  Copyright (c) 2014 eyeplum. All rights reserved.
//

#import "ATSArchiveFileTableCellView.h"


@interface ATSArchiveFileTableCellView ()

@property (nonatomic, weak) IBOutlet NSImageView *iconView;
@property (nonatomic, weak) IBOutlet NSTextField *nameLabel;
@property (nonatomic, weak) IBOutlet NSTextField *dateLabel;

@end


@implementation ATSArchiveFileTableCellView

- (void)setFileWrapper:(ATSArchiveFileWrapper *)fileWrapper {
    _fileWrapper = fileWrapper;

    self.iconView.image = fileWrapper.fileIcon;
    self.nameLabel.stringValue = fileWrapper.appName;
    self.dateLabel.stringValue = [fileWrapper.creationDate description];
}

@end