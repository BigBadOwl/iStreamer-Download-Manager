//
//  streamXmlParser.h
//  iplayerDumpTest
//
//  Created by Colin Bell on 02/12/2010.
//  Copyright 2010 GateWest. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface streamXmlParser : NSObject {
	NSXMLParser * xmlParser;
	NSMutableDictionary * result;
	NSString * currentElement;
	NSString *streamType;
	NSString *fileSize;
	NSMutableString * application, * authString, * identifier, * server;
}

- (NSString *) getFileSize;
- (NSMutableDictionary *) initStreamXMLParser:(NSString *) theUrl;
- (void)parseXMLFileAtURL:(NSString *)URL;

@end
