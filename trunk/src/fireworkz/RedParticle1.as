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
	public class RedParticle1 extends Sprite
	{
		/******************************************************************************************
		 * Other constants.
		 */
		public static const TRAIL_LENGTH: int = 32;
		public static const MOVE_LENGTH: int = 25;
		public static const FADE_LENGTH: int = 5;
		public static const FRICTION: int = 6;

		/******************************************************************************************
		 */
		public function RedParticle1(game: Game, x: Number, y: Number, vx: Number, vy: Number) 
		{
			myGame = game;
			myGame.addChild(this);
			
			myPoints = new Array();
			
			filters = [new GlowFilter(0xff0000, 1, 8, 8, 2)];
			
			myY = y;
			myX = x;
			myVX = vx;
			myVY = vy;
			
			addEventListener(Event.ENTER_FRAME, onFrame);
		}
		
		/******************************************************************************************
		 */
		public function destroy(): void
		{
			myGame.removeChild(this);
			removeEventListener(Event.ENTER_FRAME, onFrame);
			myDestroyed = true;
		}
		
		/******************************************************************************************
		 */
		public override function get x(): Number
		{
			return myX;
		}
		
		/******************************************************************************************
		 */
		public override function get y(): Number
		{
			return myY;
		}
		
		/******************************************************************************************
		 */
		private function onFrame(e: Event): void 
		{
			myFrameCounter++;
			
			if (myFrameCounter > MOVE_LENGTH) 
			{
				alpha = 1 - (myFrameCounter - MOVE_LENGTH) / FADE_LENGTH;
			}
			if (myFrameCounter > MOVE_LENGTH + FADE_LENGTH)
			{
				destroy();
			}

			myVY = (myVY * FRICTION) / (FRICTION + 1);
			myVX = (myVX * FRICTION) / (FRICTION + 1);
			
			myX += myVX / Game.FPS;
			myY += myVY / Game.FPS;
			
			myPoints.push(new Point(x, y));
			while (myPoints.length < TRAIL_LENGTH)
			{
				myPoints.push(new Point(x, y));
			}
			while (myPoints.length > TRAIL_LENGTH)
			{
				myPoints.shift();
			}
			
			// Update trail.
			graphics.clear();
			if (myPoints.length >= TRAIL_LENGTH)
			{
				graphics.moveTo(myPoints[0].x, myPoints[0].y);
				for (var i: int = 1; i < TRAIL_LENGTH - 12; i++)
				{
					graphics.lineStyle(i / 6, 0xffffff, 1);
					graphics.lineTo(myPoints[i].x, myPoints[i].y);
				}
				graphics.lineStyle(0, 0xffffff, 0);
				graphics.beginFill(0xffffff, 1);
				graphics.drawCircle(myX, myY, 2)
				graphics.endFill();
			}
		}
		
		/******************************************************************************************
		 * Fields
		 */
		private var myGame: Game;
		private var myFrameCounter: int;
		private var myDestroyed: Boolean;
		private var myVX: Number;
		private var myVY: Number;
		private var myX: Number;
		private var myY: Number;
		private var myPoints: Array;
	}
}