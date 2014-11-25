

/*

	//Easy in -out timing default
	UIView animateWithDuration:animations

	// 다른 에니메이션 옵션으로 하려면 아래의 함수를 사용.
	UIView animateWithDuration:delay:options:animations

	[UIView animcateWithDuration0.4 delay:0.0 options:UIViewAnimationOptionCurveEaseIn animations:^{}];

	e두개값 이상의 값으로 애니메이션 하려면 키프레임 에니메이션을 사용해야 함.

	UIView animateKeyFramesWithDuration:delay:options:animainos:completeion:

	animcations 코드 블럭 안에서 키 프레임을 추가한다.

	[UIView animateWithDuration:0.5 delay:0.0 options:0 animcations:^{
	
		UIView addKeyframeWithRelativeStartTime:0 relativeDuaration:0.8 animations:^ {
			messageLabel.center =self.view.center;
		}];

		[UIView addKeyframeWithRelateStartTime:0.8 relativeDuration:0.2 animations:^{
			int x =arc4ramdon();
			int y =arc4ramdon();
			messagelabel.center = CGPointMake(x, y);
		}];

	} completion:nil];

*/