package fireworkz 
{
	import flash.display.*;
	import flash.events.*;
	import flash.filters.*;
	import assets.*;
	
	/**********************************************************************************************
	 * @author Alessandro Febretti
	 */
	public class GuideScreen extends Sprite
	{
		/******************************************************************************************
		 */
		public function GuideScreen(mng: GameManager) 
		{
			myMng = mng;
			myMng.addChild(this);
			
			addEventListener(Event.ENTER_FRAME, onFrame);
			var background: Bitmap = new GameGfx.GuideScreen();
			//background.x = 10;
			background.y = 20;
			addChild(background);
			
			myStartButton = new Sprite();
			myStartButton.addChild(new GameGfx.StartGameButton());
			myStartButton.filters = [new DropShadowFilter(0, 0, 0, 1, 8, 8, 2)];
			myStartButton.addEventListener(MouseEvent.MOUSE_DOWN, onStartButtonClick);
			
			myStartButton.x = 760 - myStartButton.width;
			myStartButton.y = 600 - myStartButton.height;
			
			addChild(myStartButton);
		}
		
		/******************************************************************************************
		 */
		private function onFrame(e: Event): void 
		{
			myFrameCount++;
			myStartButton.alpha = Math.abs(Math.sin(myFrameCount / 25));
		}
		
		/******************************************************************************************
		 */
		private function onStartButtonClick(e: MouseEvent): void 
		{
			myMng.removeChild(this);
			
			myStartButton.removeEventListener(MouseEvent.MOUSE_DOWN, onStartButtonClick);
			removeEventListener(Event.ENTER_FRAME, onFrame);
			
			myMng.enterState(GameManager.STATE_NEXT_LEVEL);
		}
		
		/******************************************************************************************
		 */
		private var myStartButton: Sprite;
		private var myMng: GameManager;
		private var myFrameCount: int;
	}
}