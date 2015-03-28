//
//  main.m
//  RUBE2Class
//
//  Created by Piotr on 17.02.2014.
//  Copyright (c) 2014 Piotr Zagawa. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <sysexits.h>
#import "RUBEReader.h"

int main(int argc, const char * argv[])
{
    @autoreleasepool
    {
        //check arguments
        if (argc != 4)
        {
            NSLog(@"usage:\n");
            NSLog(@"rube2class sourceFile targetPath className\n\n");
            NSLog(@"example:\n");
            NSLog(@"rube2class ~/Documents/scene.json ~/Documents/ ScenePhysData\n\n");
            
            return EX_USAGE;
        }

        //parse arguments
        NSString *textSourceFile = [NSString stringWithCString:argv[1] encoding:NSUTF8StringEncoding];
        NSString *textTargetPath = [NSString stringWithCString:argv[2] encoding:NSUTF8StringEncoding];
        NSString *textClassName = [NSString stringWithCString:argv[3] encoding:NSUTF8StringEncoding];
        
        NSURL *sourceFile = [NSURL fileURLWithPath:textSourceFile];
        NSURL *targetPath = [NSURL fileURLWithPath:textTargetPath];
        NSString *className = textClassName;

        if (sourceFile == nil)
        {
            NSLog(@"no source file!\n");
            return EX_USAGE;
        }

        if (targetPath == nil)
        {
            NSLog(@"no target path!\n");
            return EX_USAGE;
        }

        if (className == nil)
        {
            NSLog(@"no class name!\n");
            return EX_USAGE;
        }

        //create target file names
        NSString *outputFile = targetPath.filePathURL.path;
        
        outputFile = [outputFile stringByAppendingPathComponent:className];
        
        NSURL *outputHeaderFile = [NSURL fileURLWithPath:[outputFile stringByAppendingPathExtension:@"h"]];
        NSURL *outputSourceFile = [NSURL fileURLWithPath:[outputFile stringByAppendingPathExtension:@"m"]];

        //read file
        RUBEReader *reader = [[RUBEReader alloc] initWithJsonObjectFileName:sourceFile];
        
        reader.targetName = className;
        
        //write targets
        NSError *error = nil;
        
        if ([reader.textHeaderFile writeToURL:outputHeaderFile atomically:YES encoding:NSUTF8StringEncoding error:&error] == NO)
        {
            NSLog(@"Error writing file: %@", outputHeaderFile);
            return EX_IOERR;
        }

        if ([reader.textSourceFile writeToURL:outputSourceFile atomically:YES encoding:NSUTF8StringEncoding error:&error] == NO)
        {
            NSLog(@"Error writing file: %@", outputSourceFile);
            return EX_IOERR;
        }

        //check status
        if (reader.exitCode == EX_OK)
        {
            NSLog(@"Finished!");
        }
        else
        {
            NSLog(@"Error: %@", reader.errorMessage);
        }
        
        return reader.exitCode;
    }
}

