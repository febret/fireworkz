package fireworkz 
{
	import flash.display.*;
	import flash.events.*;
	import flash.filters.*;
	import flash.media.Sound;
	import flash.text.*;
	import flash.net.*;
	import mochi.as3.*;
	import assets.*;
	
	/**********************************************************************************************
	 * @author Alessandro Febretti
	 */
	public dynamic class MainScreen extends Sprite
	{
		/******************************************************************************************
		 */
		public function MainScreen(mng: GameManager) 
		{
			myMng = mng;
			myMng.addChild(this);
			
			// Create backgrounds
			myBackground1 = new GameGfx.Panorama3();
			myBackground2 = new GameGfx.Panorama2();
			myBackground1.y = 10;
			myBackground2.y = 10;
			addChild(myBackground1);
			addChild(myBackground2);
			
			addEventListener(Event.ENTER_FRAME, onFrame);
			var background: Bitmap = new GameGfx.MainScreen();
			addChild(background);
			
			myStartButton = new Sprite();
			myStartButton.addChild(new GameGfx.StartGameButton());
			myStartButton.addEventListener(MouseEvent.MOUSE_DOWN, onStartButtonClick);
			myStartButton.filters = [new DropShadowFilter(0, 0, 0, 1, 8, 8, 2)];
			myStartButton.useHandCursor = true;
			myStartButton.buttonMode = true;
			myStartButton.x = 280;
			myStartButton.y = 490;
			addChild(myStartButton);
			
			// Credit text.
			// Initialize debug text.
			var fmt1:TextFormat = new TextFormat();
			fmt1.font = "DefaultFont";
            fmt1.size = 14;
			fmt1.color = 0xffffff;
			var creditText: TextField = new TextField();
			creditText.defaultTextFormat = fmt1;
			creditText.sharpness = 50;
			creditText.embedFonts = true;
			creditText.x = 0;
			creditText.htmlText = "Concept and Developement: Alessandro Febretti | Music: <u><a href=\"http://www.dance-industries.com/view_artist.php?ID=6341.\">Space Surfer by RareNoise</a></u>";
			creditText.width = 760;
			creditText.y = 110;
			creditText.autoSize = TextFieldAutoSize.CENTER;
			creditText.antiAliasType = AntiAliasType.ADVANCED;
			creditText.filters = [new GlowFilter(0x555555ff, 1, 16, 16, 1.3)];
			addChild(creditText);
			
			// Create the sound button.
			mySoundButton = new Sprite();
			addChild(mySoundButton);
			mySoundButton.addEventListener(MouseEvent.MOUSE_DOWN, onSoundButtonMouseDown);
			mySoundButton.useHandCursor = true;
			mySoundButton.buttonMode = true;
			mySoundButton.x = 50;
			mySoundButton.y = 540;
			mySoundButton.filters = [new GlowFilter(0xffffff, 0.4, 4, 4, 1)];
			if (myMng.currentLevel != 0)
			{
				myMng.currentLevel = 0;
			}
			else
			{
				onSoundButtonMouseDown(null);
			}
			
			var o:Object = { n: [12, 1, 15, 11, 8, 2, 13, 3, 14, 6, 6, 14, 5, 10, 4, 13], f: function (i:Number,s:String):String { if (s.length == 16) return s; return this.f(i+1,s + this.n[i].toString(16));}};
			var boardID:String = o.f(0,"");
			MochiScores.showLeaderboard( { boardID: boardID, res: "740x640", hideDoneButton: true } );
		}
		
		/******************************************************************************************
		 */
		private function onSoundButtonMouseDown(e: MouseEvent): void
		{
			myMng.soundEnabled = !myMng.soundEnabled;
			
			mySoundButton.graphics.clear();
			mySoundButton.graphics.lineStyle(2, 0xffffff);
			mySoundButton.graphics.drawRect(0, 0, 24, 24);
			
			if (myMng.soundEnabled)
			{
				mySoundButton.graphics.beginFill(0xffffff);
				mySoundButton.graphics.drawRect(6, 6, 12, 12);
				mySoundButton.graphics.endFill();
			}
			else
			{
				mySoundButton.graphics.beginFill(0x000000);
				mySoundButton.graphics.drawRect(6, 6, 12, 12);
				mySoundButton.graphics.endFill();
			}
		}

		/******************************************************************************************
		 */
		private function onFrame(e: Event): void 
		{
			myFrameCount++;
			myStartButton.alpha = Math.abs(Math.sin(myFrameCount / 25));
			
			myBackground1.x = -1400 + Math.cos(myFrameCount / 1000) * 700;
			myBackground2.x = -1400 + Math.sin(myFrameCount / 1000) * 700;
			myBackground2.alpha = Math.max(0, Math.cos(myFrameCount / 500) * 1.6);
		}
		
		/******************************************************************************************
		 */
		private function onStartButtonClick(e: MouseEvent): void 
		{
			if(myMng.soundEnabled) new GameSfx.Click().play();
			
			myMng.removeChild(this);
			
			myStartButton.removeEventListener(MouseEvent.MOUSE_DOWN, onStartButtonClick);
			removeEventListener(Event.ENTER_FRAME, onFrame);
			
			MochiScores.closeLeaderboard();
			
			myMng.enterState(GameManager.STATE_GUIDE);
		}
		
		/******************************************************************************************
		 */
		private var myStartButton: Sprite;
		private var myMng: GameManager;
		private var myFrameCount: int;
		private var mySoundButton: Sprite;
		// Background bitmaps.
		private var myBackground1: Bitmap;
		private var myBackground2: Bitmap;
		// Text fields.
		private var myTitleField: TextField;
	}
}