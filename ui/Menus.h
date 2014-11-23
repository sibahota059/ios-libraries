

/*
UIMenuController 는 프로그램에 하나뿐이다.

UIMenuController *menu = [UIMenuController sharedMenuController];
//  action 이 없으면 메뉴가 보이지 않는다(반드시 있어야 함) 
UIMenuItem *deleteItme = [[UIMenuItem alloc] initWithTItle:@"Delete" action:@selctor(deleteLInke:)];
menu.menuItems = @[deleteItem];

[menu setTargetRect:CGrectMake(0, 0, 10, 10) intView:self];
[menu setMenuVisible:YES animated:YES];

[[UIMenUController sharedMenuController] setMenuVisible:NO animate:YES];


menuitem 이 보이는 view 는 반드시 first Responder 여야 한다.
becomeFirstResponder] 호출하자.
만약에 customView 라면

 아래 함수 재정의 하자.
-(BOOL)canbecomeFirstResponder {
	return YES;
}

*/