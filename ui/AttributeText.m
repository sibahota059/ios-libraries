//
//  AttributeText.m
//
//  Created by breaklee on 2014. 10. 27..
//

#import "AttributeText.h"


NSString *const defaultTokenName = @"defaultTokenName";

@interface DynamicTextStorage : NSTextStorage {
    NSMutableAttributedString *backingStore;
    BOOL textNeedsUpdate;
}
@property (nonatomic, copy) NSDictionary *tokens;
@end

@implementation DynamicTextStorage

- (id)init {
    self = [super init];
    if (self) {
        backingStore = [[NSMutableAttributedString alloc] init];
    }
    return self;
}

- (NSString *)string {
    return [backingStore string];
}

- (NSDictionary *)attributesAtIndex:(NSUInteger)location effectiveRange:(NSRangePointer)range {
    return [backingStore attributesAtIndex:location effectiveRange:range];
}

- (void)replaceCharactersInRange:(NSRange)range withString:(NSString *)str {
    [self beginEditing];
    [backingStore replaceCharactersInRange:range withString:str];
    [self edited:NSTextStorageEditedCharacters|NSTextStorageEditedAttributes range:range changeInLength:str.length - range.length];
    textNeedsUpdate = YES;
    [self endEditing];
}

- (void)setAttributes:(NSDictionary *)attrs range:(NSRange)range {
    [self beginEditing];
    [backingStore setAttributes:attrs range:range];
    [self edited:NSTextStorageEditedAttributes range:range changeInLength:0];
    [self endEditing];
}

- (void)performReplacementsForCharacterChangeInRange:(NSRange)changedRange {
    NSRange extendedRange = NSUnionRange(changedRange, [[self string] lineRangeForRange:NSMakeRange(changedRange.location, 0)]);
    extendedRange = NSUnionRange(changedRange, [[self string] lineRangeForRange:NSMakeRange(NSMaxRange(changedRange), 0)]);
    
    [self applyTokenAttributesToRange:extendedRange];
}

-(void)processEditing {
    if(textNeedsUpdate) {
        textNeedsUpdate = NO;
        [self performReplacementsForCharacterChangeInRange:[self editedRange]];
    }
    
    [super processEditing];
}

- (void)applyTokenAttributesToRange:(NSRange)searchRange {
    NSDictionary *defaultAttributes = [self.tokens objectForKey:defaultTokenName];
    [[self string] enumerateSubstringsInRange:searchRange options:NSStringEnumerationByWords usingBlock:^(NSString *substring, NSRange substringRange, NSRange enclosingRange, BOOL *stop) {
        NSDictionary *attributesForToken = [self.tokens objectForKey:substring];
        if(!attributesForToken) {
            attributesForToken = defaultAttributes;
        }
        [self addAttributes:attributesForToken range:substringRange];
    }];
}

@end


@interface AttributeText() {
    DynamicTextStorage *_textStorage;
    CGRect _rect;
    NSTextContainer *_container;
}

@end

@implementation AttributeText

+ (UIFont*)systemUserFont {
    return [UIFont preferredFontForTextStyle:UIFontTextStyleBody];
}

+ (void)setDetector:(UITextView*)textView {
    //TODO
    /*
     UITextViewDelegate 설정해야 함.
     - (BOOL)textView:(UITextView *)textView shouldInteractWithURL:(NSURL *)URL inRange:(NSRange)characterRange;
     */
    [textView setDataDetectorTypes: UIDataDetectorTypePhoneNumber | UIDataDetectorTypeLink | UIDataDetectorTypeAddress | UIDataDetectorTypeCalendarEvent];
    //    [textView setText:@"Website: http://www.pearsoned.com\nPhone: (310) 597-3781\nAddress: 1 infinite loop cupertino ca 95014\nWhen: July 15th at 7pm PST"];
    textView.selectable = YES;
}

+ (void)setExclusionTextView:(UITextView*)view frame:(CGRect)rect {
    UIBezierPath *circle = [UIBezierPath bezierPathWithOvalInRect:rect];
    //    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(110, 110, 100, 102)];
    //    [imageView setImage: [UIImage imageNamed: @"DF.png"]];
    //    [imageView setContentMode:UIViewContentModeScaleToFill];
    //    [self.myTextView addSubview: imageView];
    view.textContainer.exclusionPaths = @[circle];
}


- (id)initWithFrame:(CGRect)frame {
    self = [super init];
    if(self) {
        _rect = frame;
        _textStorage = [[DynamicTextStorage alloc] init];
        NSLayoutManager *layoutManager = [[NSLayoutManager alloc] init];
        
        _container = [[NSTextContainer alloc] initWithSize:CGSizeMake(frame.size.width, CGFLOAT_MAX)];
        _container.widthTracksTextView = YES;
        [layoutManager addTextContainer:_container];
        [_textStorage addLayoutManager:layoutManager];
        
        //breaklee my name is jaemoon contact, phone
        _textStorage.tokens = @{ @"breaklee" : @{ NSForegroundColorAttributeName : [UIColor redColor] },
                                @"lamb" : @{ NSForegroundColorAttributeName : [UIColor blueColor] },
                                @"everywhere" : @{ NSUnderlineStyleAttributeName : @1 },
                                @"jaemoon" : @{ NSBackgroundColorAttributeName : [UIColor yellowColor] },
                                @"fleece" : @{ NSFontAttributeName : [UIFont fontWithName:@"Chalkduster" size:14.0f] },
                                @"contact" : @{ NSStrikethroughStyleAttributeName : @1 },
                                @"white" : @{ NSStrokeWidthAttributeName : @5 },
                                @"was" : @{ NSFontAttributeName : [UIFont fontWithName:@"Palatino-Bold" size:10.0f], NSForegroundColorAttributeName : [UIColor purpleColor], NSUnderlineStyleAttributeName : @1},
                                defaultTokenName : @{ NSForegroundColorAttributeName : [UIColor blackColor],
                                                      NSFontAttributeName: [UIFont systemFontOfSize:14.0f],
                                                      NSUnderlineStyleAttributeName : @0,
                                                      NSBackgroundColorAttributeName : [UIColor whiteColor],
                                                      NSStrikethroughStyleAttributeName : @0,
                                                      NSStrokeWidthAttributeName : @0}};
    }
    return self;
}

- (UITextView*)viewWithString:(NSString*)string {
    
    UITextView *view = [[UITextView alloc] initWithFrame:_rect textContainer:_container];
    view.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    view.scrollEnabled = YES;
    view.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
    
//    NSString *maryText = @"Mary had a little lamb\nwhose fleece was white as snow.\nAnd everywhere that Mary went,\nthe lamb was sure to go.\nIt followed her to school one day\nwhich was against the rule.\nIt made the children laugh and play,\nto see a lamb at school.";
    
    [view setText:string];
//     [NSString stringWithFormat:@"%@\n\n%@\n\n%@", maryText, maryText, maryText]];
    return view;
}

@end

@interface CustomTextView : UITextView

@end

@implementation CustomTextView

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    
    return self;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    UITouch *touch = [touches anyObject];
    CGPoint touchPoint = [touch locationInView:self];
    
    //points are falling 10 pixels below where they should be, this adjust the point to where it needs to be.
    touchPoint.y -= 10;
    
    NSInteger characterIndex = [self.layoutManager characterIndexForPoint:touchPoint inTextContainer:self.textContainer fractionOfDistanceBetweenInsertionPoints:0];
    
    if(characterIndex != 0) {
        //calculate the start and stop of the word
        NSRange start = [self.text rangeOfCharacterFromSet:[NSCharacterSet whitespaceAndNewlineCharacterSet] options:NSBackwardsSearch range:NSMakeRange(0, characterIndex)];
        NSRange stop = [self.text rangeOfCharacterFromSet:[NSCharacterSet whitespaceAndNewlineCharacterSet] options:NSCaseInsensitiveSearch range:NSMakeRange(characterIndex, self.text.length-characterIndex)];
        
        int length =  stop.location - start.location;
        
        NSString *fullWord = [self.text substringWithRange:NSMakeRange(start.location, length)];
        
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Selected Word" message:fullWord delegate:nil cancelButtonTitle:@"Dismiss" otherButtonTitles: nil];
        [alert show];
    }
    [super touchesBegan: touches withEvent: event];
}



@end
