package fireworkz 
{
	import flash.filters.*;
	import flash.display.*;
	import flash.events.*;
	import flash.geom.*;
	import flash.media.*;
	import assets.*;
	
	/**********************************************************************************************
	 * @author Alessandro Febretti
	 */
	public class Shell extends Sprite
	{
		/******************************************************************************************
		 * Other constants.
		 */
		public static const TRAIL_LENGTH: int = 32;

		/******************************************************************************************
		 * Particle type constants.
		 */
		public static const TYPE_RED: uint = 1;
		public static const TYPE_BLUE: uint = 2;
		public static const TYPE_GREEN: uint = 3;
		public static const TYPE_WHITE: uint = 4;
		
		/******************************************************************************************
		 */
		public function Shell(game: Game, x1: int, y1: int) 
		{
			myGame = game;
			myGame.addChild(this);
			
			myPoints = new Array();
			
			// Randomly set the shell type.
			switch(int(Math.random() * 4))
			{
			case 0:
				filters = [new GlowFilter(0xff0000, 1, 8, 8, 2)];
				myType = TYPE_RED;
				break;
			case 1:
				filters = [new GlowFilter(0x00ff00, 1, 8, 8, 2)];
				myType = TYPE_GREEN;
				break;
			case 2:
				filters = [new GlowFilter(0x0000ff, 1, 8, 8, 2)];
				myType = TYPE_BLUE;
				break;
			case 3:
				filters = [new GlowFilter(0xffffff, 1, 8, 8, 2)];
				myType = TYPE_WHITE;
				break;
			}
				
			myY = y1;
			myX = x1;
			myVX = Math.random() * 60 - 30;
			myVY = - 800;

			if (myGame.mng.soundEnabled)
			{
				var pan: Number = (myX - 350) / 200;
				var snd: Sound = new GameSfx.Launch();
				snd.play(0, 0, new SoundTransform(0.5, pan));
			}
			
			myMoving = true;
			
			addEventListener(Event.ENTER_FRAME, onFrame);
		}
		
		/******************************************************************************************
		 */
		public function destroy(): void
		{
			if (!myDestroyed)
			{
				myGame.removeChild(this);
				removeEventListener(Event.ENTER_FRAME, onFrame);
				myDestroyed = true;
			}
		}
		
		/******************************************************************************************
		 */
		public function activate(prev: Shell, level: int): void
		{
			myLevel = level;
			myActivated = true;
			myActivationCounter = Math.random() * 12;
		}
		
		/******************************************************************************************
		 */
		public function explode(): void
		{
			if (myLevel > 5) myLevel = 5;
			
			// sound
			if (myGame.mng.soundEnabled)
			{
				var pan: Number = (myX - 350) / 200;
				if (pan > 1) pan = 1;
				if (pan < -1) pan = 1;
				var vol: Number = 0.5 + myLevel / 10;
				var snd: Sound = new GameSfx.Bang();
				snd.play(0, 0, new SoundTransform(vol, pan));
			}
			
			var numParticles: int = 8 + (myLevel * myLevel) / 2;
			var angleInt: Number = 2 * Math.PI / numParticles;
			var angle: Number = Math.random() * Math.PI;
			var vx: Number;
			var vy: Number;
			var speed: Number;
			var i: int;
			
			if (myType == TYPE_BLUE)
			{
				for (i = 0; i < numParticles; i++)
				{
					speed = 100 * myLevel + Math.random() * 120 * myLevel;
					vx = speed * Math.cos(angle);
					vy = speed * Math.sin(angle);
					if (i % 3 == 0)
					{
						new BlueParticle2(myGame, myX, myY, vx, vy);
					}
					else
					{
						new BlueParticle1(myGame, myX, myY, vx / 2, vy / 2);
					}
					angle += angleInt;
				}
				// Create the glow.
				new Glow(myGame, new ParticleGfx.BlueGlow, myX, myY, myLevel * 0.3, 20);
				new Glow(myGame, new ParticleGfx.BlueGlow, myX, myY, myLevel * 0.1, 10);
			}
			else if (myType == TYPE_GREEN)
			{
				speed = 100 * myLevel;
				for (i = 0; i < numParticles; i++)
				{
					vx = speed * Math.cos(angle);
					vy = speed * Math.sin(angle);
					if (i % 2 == 0)
					{
						new GreenParticle1(myGame, myX, myY, vx, vy);
					}
					else
					{
						new GreenParticle2(myGame, myX, myY, vx / 2, vy / 2);
					}
					angle += angleInt;
				}
				// Create the glow.
				new Glow(myGame, new ParticleGfx.GreenGlow, myX, myY, myLevel * 0.1, 15);
			}
			else if (myType == TYPE_RED)
			{
				speed = 100 * myLevel;
				for (i = 0; i < numParticles; i++)
				{
					vx = speed * Math.cos(angle);
					vy = speed * Math.sin(angle);
					if (i % 2 == 0)
					{
						new RedParticle1(myGame, myX, myY, vx, vy);
					}
					else
					{
						new RedParticle2(myGame, myX, myY, vx / 2, vy / 2);
					}
					angle += angleInt;
				}
				// Create the glow.
				new Glow(myGame, new ParticleGfx.RedGlow, myX, myY, myLevel * 0.1, 15);
			}
			else
			{
				for (i = 0; i < numParticles; i++)
				{
					speed = 100 + 20 * myLevel + Math.random() * 80 * myLevel;
					angle = Math.random() * 2 * Math.PI;
					vx = speed * Math.cos(angle);
					vy = speed * Math.sin(angle);
					new WhiteParticle2(myGame, myX, myY, vx, vy);
					angle += angleInt;
				}
				// Create the glow.
				new Glow(myGame, new ParticleGfx.WhiteGlow, myX, myY, myLevel * 0.1, 10);
				//new Glow(myGame, new ParticleGfx.WhiteGlow, myX, myY, myLevel * 0.1, 25);
			}
			destroy();
		}
		
		/******************************************************************************************
		 */
		public function get destroyed(): Boolean
		{
			return myDestroyed;
		}
		
		/******************************************************************************************
		 */
		public function get activated(): Boolean
		{
			if (myActivationCounter > 0) return true;
			return false;
		}
		
		/******************************************************************************************
		 */
		public function get type(): uint
		{
			return myType;
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
		public function get moving(): Boolean
		{
			return myMoving;
		}
		
		/******************************************************************************************
		 */
		public function set moving(value: Boolean): void
		{
			myMoving = value;
		}
		
		/******************************************************************************************
		 */
		private function onFrame(e: Event): void 
		{
			myFrameCounter++;

			myVY = (myVY * 8 - 50) / 9;
			
			if (!myActivated)
			{
				if (myMoving)
				{
					myX += myVX / Game.FPS;
					myY += myVY / Game.FPS;
				}
			}
			else
			{
				myActivationCounter++;
				if (myActivationCounter >= Game.ACTIVATION_TIME)
				{
					explode();
				}
			}

			// Add point t0 trail
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
				for (var i: int = 1; i < TRAIL_LENGTH; i++)
				{
					graphics.lineStyle(2, 0xffffff, i / TRAIL_LENGTH);
					graphics.lineTo(myPoints[i].x, myPoints[i].y);
				}
				graphics.lineStyle(0, 0xffffff, 0);
				graphics.beginFill(0xffffff, 1);
				graphics.drawCircle(myPoints[TRAIL_LENGTH - 1].x, myPoints[TRAIL_LENGTH - 1].y, 4)
				graphics.endFill();
			}
			
		}
		
		/******************************************************************************************
		 * Fields
		 */
		private var myGame: Game;
		private var myMoving: Boolean;
		private var myFrameCounter: int;
		private var myType: uint;
		private var myLevel: int;
		private var myDestroyed: Boolean;
		//private var myChainPrev: Shell;
		private var myActivated: Boolean;
		private var myActivationCounter: int;
		private var myVX: Number;
		private var myVY: Number;
		private var myX: Number;
		private var myY: Number;
		private var myPoints: Array;
	}
}