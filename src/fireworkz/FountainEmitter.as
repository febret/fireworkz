package fireworkz 
{
	import flash.display.*;
	import flash.events.*;
	import assets.*;
	
	/**********************************************************************************************
	 * @author Alessandro Febretti
	 */
	public class FountainEmitter extends Sprite
	{
		/******************************************************************************************
		 */
		public function FountainEmitter(game: Game, x: int, y: int) 
		{
			myGame = game;
			myGame.addChild(this);
			
			/*myBitmap = new ParticleGfx.WhiteSpark();
			myBitmap.blendMode = BlendMode.ADD;
			addChild(myBitmap);*/
			
			this.x = x;
			this.y = y;
			myVX = Math.random() * 100 - 50;
			myVY = - 60 - Math.random() * 30;
			
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
			
			//if (myFrameCounter % 2 == 0)
			{
				myGame.particleManager.createParticle(
					ParticleManager.MULTI_SPARKS,
					x + Math.random() * 4 - 2, y + Math.random() * 4 - 2, 1,
					0, 0, -0.4);
			}
				
			if (myFrameCounter > 100)
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