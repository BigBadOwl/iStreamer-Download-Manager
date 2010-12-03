//
//  iplayerFetch.h
//  iplayerDumpTest
//
//  Created by Colin Bell on 03/12/2010.
//  Copyright 2010 GateWest. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PDColoredProgressView.h";

@interface iplayerFetch : NSObject {
	PDColoredProgressView * downloadProgress;
}

- (void)setDownloadProgressDelegate:(PDColoredProgressView *)theProgress;
- (void)beginDownload:(NSString *) thePid withDocumentsFolder:(NSString *) documentsDirectory andTempFolder:(NSString *) tempDirectory;
- (void)getFlashFile:(NSString *) thePid withFlvPathName:(NSString *)flvPath;
- (void)removeFlvWrapper:(NSString *)flvPath withMp4PathName:(NSString *)mp4Path;
@end
