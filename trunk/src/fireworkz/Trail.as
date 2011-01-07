package fireworkz 
{
	import flash.events.*;
	import flash.display.*;
	import flash.filters.*;
	import flash.geom.*;
	
	/**********************************************************************************************
	 * @author Alessandro Febretti
	 */
	public class Trail extends Sprite
	{
		public static const MAX_POINTS: int = 12;
		
		/******************************************************************************************
		 */
		public function Trail(game: Game) 
		{
			myGame = game;
			myGame.addChild(this);
			addEventListener(Event.ENTER_FRAME, onFrame);
			
			myPoints = new Array();
			
			filters = [new GlowFilter(0x0000ff, 1, 8, 8, 2)];
		}
		
		/******************************************************************************************
		 */
		public function destroy() : void
		{
			myGame.removeChild(this);
			removeEventListener(Event.ENTER_FRAME, onFrame);
		}
		
		/******************************************************************************************
		 */
		public function addPoint(x: int, y: int): void 
		{
			myPoints.push(new Point(x, y));
			while (myPoints.length < MAX_POINTS)
			{
				myPoints.push(new Point(x, y));
			}
			while (myPoints.length > MAX_POINTS)
			{
				myPoints.shift();
			}
		}
		
		/******************************************************************************************
		 */
		private function onFrame(e: Event): void 
		{
			myFrameCounter++;
			graphics.clear();
			if (myPoints.length == MAX_POINTS)
			{
				graphics.moveTo(myPoints[0].x, myPoints[0].y);
				for (var i: int = 1; i < MAX_POINTS; i++)
				{
					graphics.lineStyle(Number(i) / 2, 0xffffff, 1);
					graphics.lineTo(myPoints[i].x, myPoints[i].y);
				}
				graphics.lineStyle(0, 0xffffff, 0);
				graphics.beginFill(0xffffff, 1);
				graphics.drawCircle(myPoints[MAX_POINTS - 1].x, myPoints[MAX_POINTS - 1].y, 4)
				graphics.endFill();
			}
		}
		
		/******************************************************************************************
		 * Fields
		 */
		private var myGame: Game;
		private var myFrameCounter: int;
		private var myPoints: Array;
	}
}