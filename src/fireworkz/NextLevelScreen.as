package fireworkz 
{
	import flash.display.*;
	import flash.events.*;
	import flash.filters.*;
	import flash.text.*;
	import assets.*;
	
	/**********************************************************************************************
	 * @author Alessandro Febretti
	 */
	public class NextLevelScreen extends Sprite
	{
		/******************************************************************************************
		 */
		public function NextLevelScreen(mng: GameManager) 
		{
			myMng = mng;
			myMng.addChild(this);
			
			addEventListener(Event.ENTER_FRAME, onFrame);
			/*var background: Bitmap = new GameGfx.GameOverScreen();
			background.x = 10;
			background.y = 10;
			addChild(background);*/
			
			myContinueButton = new Sprite();
			myContinueButton.addChild(new GameGfx.ContinueButton());
			myContinueButton.addEventListener(MouseEvent.MOUSE_DOWN, onContinueButtonClick);
			
			myContinueButton.x = 760 - myContinueButton.width;
			myContinueButton.y = 12000;
			myContinueButton.filters = [new DropShadowFilter(0, 0, 0, 1, 8, 8, 2)];
			
			addChild(myContinueButton);
			
			initText();
			
			switch(myMng.currentLevel)
			{
			case 0:
				myLevelText.text = "Level 1/3: Madrid";
				mySuccessLevelText.text = "Required Success Level: 80%";
				break;
			case 1:
				myLevelText.text = "Level 2/3: Rio De Janeiro";
				mySuccessLevelText.text = "Required Success Level: 85%";
				break;
			case 2:
				myLevelText.text = "Level 3/3: Hong Kong";
				mySuccessLevelText.text = "Required Success Level: 90%";
				break;
			}
		}
		
		/******************************************************************************************
		 */
		public function initText(): void
		{
			// Initialize debug text.
			var fmt1:TextFormat = new TextFormat();
			fmt1.font = "DefaultFont";
            fmt1.size = 66;
			fmt1.color = 0xffffff;
			
			myTitleText = new TextField();
			myTitleText.defaultTextFormat = fmt1;
			myTitleText.sharpness = 50;
			myTitleText.embedFonts = true;
			myTitleText.x = 0;
			myTitleText.text = "NEXT LEVEL";
			myTitleText.width = 760;
			myTitleText.y = 600;
			myTitleText.autoSize = TextFieldAutoSize.CENTER;
			myTitleText.antiAliasType = AntiAliasType.ADVANCED;
			myTitleText.filters = [new GlowFilter(0x5555ff, 1, 16, 16)];
			addChild(myTitleText);
			
			// Initialize debug text.
			var fmt:TextFormat = new TextFormat();
			fmt.font = "DefaultFont";
            fmt.size = 36;
			fmt.color = 0xffffff;
			
			myLevelText = new TextField();
			myLevelText.defaultTextFormat = fmt;
			myLevelText.sharpness = 50;
			myLevelText.embedFonts = true;
			myLevelText.x = 0;
			myLevelText.width = 760;
			myLevelText.y = 1200;
			myLevelText.autoSize = TextFieldAutoSize.CENTER;
			myLevelText.antiAliasType = AntiAliasType.ADVANCED;
			myLevelText.filters = [new GlowFilter(0xffffff, 0.2, 4, 4)];
			addChild(myLevelText);
			
			mySuccessLevelText = new TextField();
			mySuccessLevelText.defaultTextFormat = fmt;
			mySuccessLevelText.sharpness = 50;
			mySuccessLevelText.embedFonts = true;
			mySuccessLevelText.x = 0;
			mySuccessLevelText.y = 6400;
			mySuccessLevelText.width = 760;
			mySuccessLevelText.filters = [new GlowFilter(0xffffff, 0.2, 4, 4)];
			mySuccessLevelText.autoSize = TextFieldAutoSize.CENTER;
			mySuccessLevelText.antiAliasType = AntiAliasType.ADVANCED;
			addChild(mySuccessLevelText);
		}
		
		/******************************************************************************************
		 */
		private function onFrame(e: Event): void 
		{
			myFrameCount++;
			
			var f: int = 5;
			
			myTitleText.y = (myTitleText.y * f + 10) / (f + 1);
			myLevelText.y = (myLevelText.y * f + 200) / (f + 1);
			mySuccessLevelText.y = (mySuccessLevelText.y * f + 300) / (f + 1);
			
			myContinueButton.y = (myContinueButton.y * f + 530) / (f + 1);
			
			myContinueButton.alpha = Math.abs(Math.sin(myFrameCount / 25));
		}
		
		/******************************************************************************************
		 */
		private function onContinueButtonClick(e: MouseEvent): void 
		{
			if (myMng.soundEnabled) new GameSfx.Click().play();
			
			myMng.removeChild(this);
			
			myContinueButton.removeEventListener(MouseEvent.MOUSE_DOWN, onContinueButtonClick);
			removeEventListener(Event.ENTER_FRAME, onFrame);
			
			trace("Current level: " + myMng.currentLevel);
			switch(myMng.currentLevel)
			{
			case 0:
				myMng.requiredSuccessLevel = 0.8;
				break;
			case 1:
				myMng.requiredSuccessLevel = 0.85;
				break;
			case 2:
				myMng.requiredSuccessLevel = 0.9;
				break;
			}
			myMng.enterState(GameManager.STATE_GAME);
		}
		
		/******************************************************************************************
		 */
		private var myContinueButton: Sprite;
		private var myMng: GameManager;
		private var myFrameCount: int;
		// Text fields.
		private var myLevelText: TextField;
		private var myTitleText: TextField;
		private var mySuccessLevelText: TextField;
	}
}