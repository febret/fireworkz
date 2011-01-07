package fireworkz 
{
	import flash.display.*;
	import flash.events.*;
	import assets.*;
	
	/**********************************************************************************************
	 * @author Alessandro Febretti
	 */
	public class DelayEmitter extends Sprite
	{
		/******************************************************************************************
		 */
		public function DelayEmitter(game: Game, x: int, y: int) 
		{
			myFrameCounter = 0;
			
			myGame = game;
			myGame.addChild(this);
			
			/*myBitmap = new ParticleGfx.WhiteSpark();
			myBitmap.blendMode = BlendMode.ADD;
			addChild(myBitmap);*/
			
			this.x = x;
			this.y = y;
			myVX = Math.random() * 200 - 100;
			myVY = - Math.random() * 200;
			
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
			
			myVY += Game.G / 2;
			x += myVX / Game.FPS;
			y += myVY / Game.FPS;
			
			if(myFrameCounter > 20)
			{
				//for (var i: int = 0; i < 3; i++)
				//{
					myGame.particleManager.createParticle(
						ParticleManager.BLUE_SPARK,
						x + Math.random() * 4 - 2, y + Math.random() * 4 - 2, 1,
						0, 0, -2);
				//}
			}
			else
			{
				myGame.particleManager.createParticle(
					ParticleManager.RED_DOT,
					x + Math.random() * 4 - 2, y + Math.random() * 4 - 2, 1,
					0, 0, -8);
			}
				
			if (myFrameCounter > 40)
			{
				destroy();
			}
		}
		
		/******************************************************************************************
		 * Fields
		 */
		private var myGame: Game;
		private var myBitmap: Bitmap;
		private var myFrameCounter: int;
		
		private var myVX: Number;
		private var myVY: Number;
	}
}