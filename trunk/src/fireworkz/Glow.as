package fireworkz 
{
	import flash.filters.*;
	import flash.display.*;
	import flash.events.*;
	import flash.geom.*;
	import assets.*;
	
	/**********************************************************************************************
	 * @author Alessandro Febretti
	 */
	public class Glow extends Sprite
	{
		/******************************************************************************************
		 */
		public function Glow(game: Game, bmp: Bitmap, x: Number, y: Number, size: Number, time: int) 
		{
			myGame = game;
			myGame.addChild(this);
			
			addChild(bmp);
			blendMode = BlendMode.ADD;
			
			myX = x;
			myY = y;
			
			alpha = 0;
			
			mySize = size;
			
			myTotalTime = time;
			
			addEventListener(Event.ENTER_FRAME, onFrame);
		}
		
		/******************************************************************************************
		 */
		public function destroy(): void
		{
			myGame.removeChild(this);
			removeEventListener(Event.ENTER_FRAME, onFrame);
		}
		
		/******************************************************************************************
		 */
		private function onFrame(e: Event): void 
		{
			myFrameCounter++;
			
			alpha = 1.5 - (myFrameCounter / myTotalTime) * 1.5;
			
			mySize += 0.2;
			scaleX = mySize;
			scaleY = mySize;
			x = myX - 32 * mySize;
			y = myY - 32 * mySize;
			
			if (myFrameCounter == myTotalTime)
			{
				destroy();
			}
		}
		
		/******************************************************************************************
		 * Fields
		 */
		private var myGame: Game;
		private var myFrameCounter: int;
		private var myTotalTime: int;
		private var mySize: Number;
		private var myX: Number;
		private var myY: Number;
	}
}