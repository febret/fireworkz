package fireworkz 
{
	import flash.display.*;
	import flash.events.*;
	import flash.filters.*;
	import mochi.as3.*;
	import assets.*;
	
	/**********************************************************************************************
	 * @author Alessandro Febretti
	 */
	public dynamic class GameOverScreen extends Sprite
	{
		/******************************************************************************************
		 */
		public function GameOverScreen(mng: GameManager) 
		{
			myMng = mng;
			myMng.addChild(this);

			// Create backgrounds
			myBackground1 = new GameGfx.Panorama3();
			myBackground2 = new GameGfx.Panorama2();
			addChild(myBackground1);
			addChild(myBackground2);
			
			addEventListener(Event.ENTER_FRAME, onFrame);
			var background: Bitmap = new GameGfx.GameOverScreen();
			addChild(background);
			
			myContinueButton = new Sprite();
			myContinueButton.addChild(new GameGfx.ContinueButton());
			myContinueButton.addEventListener(MouseEvent.MOUSE_DOWN, onContinueButtonClick);
			
			myContinueButton.x = 760 - myContinueButton.width;
			myContinueButton.y = 600 - myContinueButton.height;
			myContinueButton.filters = [new DropShadowFilter(0, 0, 0, 1, 8, 8, 2)];
			
			addChild(myContinueButton);
			
			var o:Object = { n: [12, 1, 15, 11, 8, 2, 13, 3, 14, 6, 6, 14, 5, 10, 4, 13], f: function (i:Number,s:String):String { if (s.length == 16) return s; return this.f(i+1,s + this.n[i].toString(16));}};
			var boardID:String = o.f(0,"");
			MochiScores.showLeaderboard( { boardID: boardID, res: "740x640", hideDoneButton: true, score: myMng.score.value } );
		}
		
		/******************************************************************************************
		 */
		private function onFrame(e: Event): void 
		{
			myFrameCount++;
			myBackground1.x = -1400 + Math.cos(myFrameCount / 1000) * 700;
			myBackground2.x = -1400 + Math.sin(myFrameCount / 1000) * 700;
			myBackground2.alpha = Math.max(0, Math.cos(myFrameCount / 500) * 1.6);
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
			
			MochiScores.closeLeaderboard();
			
			myMng.currentLevel = 0;
			myMng.score.setValue(0);
			
			myMng.enterState(GameManager.STATE_NEXT_LEVEL);
		}
		
		/******************************************************************************************
		 */
		private var myContinueButton: Sprite;
		private var myMng: GameManager;
		private var myFrameCount: int;
		// Background bitmaps.
		private var myBackground1: Bitmap;
		private var myBackground2: Bitmap;
	}
}