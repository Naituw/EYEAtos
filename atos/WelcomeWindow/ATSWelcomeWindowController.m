//
//  ATSWelcomeWindowController.m
//  atos
//
//  Created by eyeplum on 4/20/14.
//  Copyright (c) 2014 eyeplum. All rights reserved.
//

#import "ATSWelcomeWindowController.h"
#import "ATSArchiveFileWrapper.h"
#import "ATSArchiveFileTableCellView.h"


static NSString * const kXCArchiveFilePath = @"/Library/Developer/Xcode/Archives";
static NSString * const kCellID = @"com.eyeplum.archiveCell";


@interface ATSWelcomeWindowController () <NSTableViewDataSource, NSTableViewDelegate>

@property (nonatomic, weak) IBOutlet NSTableView *tableView;
@property (nonatomic, weak) IBOutlet NSTextField *versionLabel;
@property (nonatomic, strong) NSArray *archiveFileWrappers;

@end


@implementation ATSWelcomeWindowController

#pragma mark - Initialier

- (id)init {
    if (self = [super initWithWindowNibName:[self className]]) {
        _archiveFileWrappers = [NSMutableArray array];
    }

    return self;
}


#pragma mark - Window Lifecycle

- (void)windowDidLoad {
    [super windowDidLoad];
    [self setupVersionLabel];
    [self setupTableView];
    [self scanArchiveFolder];
}


- (void)setupVersionLabel {
    NSDictionary *info = [[NSBundle mainBundle] infoDictionary];
    NSString *version = [NSString stringWithFormat:@"Version %@ (%@)",
                    info[@"CFBundleShortVersionString"],
                    info[(NSString *) kCFBundleVersionKey]];
    [self.versionLabel setStringValue:version];
}


- (void)setupTableView {
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
}


- (void)scanArchiveFolder {
    NSArray *prefetchKeys = @[NSURLIsPackageKey, NSURLCreationDateKey, NSURLEffectiveIconKey];
    NSDirectoryEnumerationOptions options = NSDirectoryEnumerationSkipsPackageDescendants | NSDirectoryEnumerationSkipsHiddenFiles;
    NSDirectoryEnumerator *directoryEnumerator = [[NSFileManager defaultManager] enumeratorAtURL:[self archiveURL]
                                                                      includingPropertiesForKeys:prefetchKeys
                                                                                         options:options
                                                                                    errorHandler:NULL];

    NSMutableArray *wrappers = [NSMutableArray array];
    for (NSURL *fileURL in directoryEnumerator) {
        NSNumber *isPackage;
        [fileURL getResourceValue:&isPackage forKey:NSURLIsPackageKey error:NULL];
        if ([isPackage boolValue]) {
            ATSArchiveFileWrapper *wrapper = [ATSArchiveFileWrapper fileWrapperWithURL:fileURL];
            if (wrapper) {
                [wrappers addObject:wrapper];
            }
        }
    }
    self.archiveFileWrappers = wrappers;

    [self.tableView reloadData];
}


- (NSURL *)archiveURL {
    NSURL *homeDir = [NSURL fileURLWithPath:NSHomeDirectory() isDirectory:YES];
    NSURL *archiveURL = [homeDir URLByAppendingPathComponent:kXCArchiveFilePath isDirectory:YES];
    return archiveURL;
}


#pragma mark - NSTableView Delegate & Data Source

- (NSInteger)numberOfRowsInTableView:(NSTableView *)tableView {
    return self.archiveFileWrappers.count;
}


- (NSView *)tableView:(NSTableView *)tableView viewForTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row {
    ATSArchiveFileTableCellView *cellView = [tableView makeViewWithIdentifier:kCellID owner:self];
    cellView.fileWrapper = self.archiveFileWrappers[(NSUInteger) row];
    return cellView;
}

@end