
/*
	iphone, ipad 에서 회전을 지원하기 위한 함수 override

- (BOOL)shouldAutorotate {
	return YES;
}
	UIViewController
	- (NSUInteger)supportedInterfaceOrientations {	
		if([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPad) {
			return UIInterfaceOrientationMaskAll;	
		}
		else {
			return UIInterfaceOrientationMaskAllButUpsideDown;	
		}
	}


	인터페이스 방향이 성공적으로 변경되면 호출되는 콜
	willAnimationRotaionToInterfaceorientation:duration:백업
	wilRotationToInterfaceOrientation:duration: (에니메이션 없음)
*/