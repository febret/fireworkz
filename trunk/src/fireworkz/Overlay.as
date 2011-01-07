package fireworkz 
{
	import flash.filters.*;
	import flash.display.*;
	import flash.events.*;
	import flash.geom.*;
	import assets.*;
	import flash.media.SoundTransform;
	
	/**********************************************************************************************
	 * @author Alessandro Febretti
	 */
	public class Overlay extends Sprite
	{
		/******************************************************************************************
		 * Other constants.
		 */
		public static const TRAIL_LENGTH: int = 32;

		/******************************************************************************************
		 */
		public function Overlay(game: Game) 
		{
			myGame = game;
			myGame.addChild(this);
			
			mySelectedShells = new Array();
			myPoints = new Array();
			
			//width = Game.SCREEN_WIDTH;
			//height = Game.SCREEN_HEIGHT;
			
			//filters = [new GlowFilter(0xffff00, 1, 8, 8, 2)];
			
			addEventListener(Event.ENTER_FRAME, onFrame);
		}
		
		/******************************************************************************************
		 */
		public function get enableMouseTrail(): Boolean
		{
			return myEnableMouseTrail;
		}
		
		/******************************************************************************************
		 */
		public function set enableMouseTrail(value: Boolean): void
		{
			myEnableMouseTrail = value;
			if (!myEnableMouseTrail) 
			{
				// Mouse trail disabled
				graphics.clear();
				for (var i: int = 0; i < mySelectedShells.length; i++)
				{
					if (mySelectedShells.length >= myGame.triggerLevel)
					{
						mySelectedShells[i].activate(null, mySelectedShells.length - 1);
					}
					else
					{
						mySelectedShells[i].moving = true;
					}
				}
				myGame.addPoints(int(Math.pow(mySelectedShells.length, 1.5)) * 50);
				
				// Play crowd sounds.
				if (myGame.mng.soundEnabled)
				{
					if (mySelectedShells.length - 1 >= 4)
					{
						var vol: Number = 0.5 + (mySelectedShells.length - 4) / 4
						if (mySelectedShells.length < 7)
						{
							new GameSfx.NextLevelApplause().play(0, 0, new SoundTransform(vol));
							
						}
						else
						{
							new GameSfx.Cheers().play(0, 0, new SoundTransform(vol));
						}
					}
				}
			}
			else
			{
				myPoints = new Array();
			}
			mySelectedShells = new Array();
		}
		
		/******************************************************************************************
		 */
		private function onFrame(e: Event): void 
		{
			myFrameCounter++;
			
			if (myEnableMouseTrail)
			{
				myPoints.push(new Point(mouseX, mouseY));
				while (myPoints.length < TRAIL_LENGTH)
				{
					myPoints.push(new Point(mouseX, mouseY));
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
						graphics.lineStyle(i / 8, 0xffffff, 1);
						graphics.lineTo(myPoints[i].x, myPoints[i].y);
					}
				}
				
				// Select shells
				var selectedShell: Shell;
				var dist: Number = 10000;
				for (i = 0; i < myGame.shells.length; i++)
				{
					var shell: Shell = myGame.shells[i];
					var ok: Boolean = true;
					if (!shell.activated && !shell.destroyed)
					{
						for (var j: int = 0; j < mySelectedShells.length; j++)
						{
							if (shell == mySelectedShells[j]) 
							{
								ok = false;
								break;
							}
						}
						if (ok)
						{
							var dx: int = mouseX - shell.x;
							var dy: int = mouseY - shell.y;
							var d: Number = Math.sqrt(dx * dx + dy * dy);
							if (d < 32 && d < dist)
							{
								// Mouse was over the shell activation area. See if we can put this shell on the
								// selected list.
								if (mySelectedShells.length == 0)
								{
									selectedShell = shell;
									dist = d;
								}
								else
								{
									var prevShell: Shell = mySelectedShells[mySelectedShells.length - 1];
									if (prevShell.type == shell.type)
										{
											selectedShell = shell;
											dist = d;
										}
								}
							}
						}
					}
				}
				if (selectedShell != null)
				{
					mySelectedShells.push(selectedShell);
					selectedShell.moving = false;
				}
				
				// Redraw selection circles.
				for (var k: int = 0; k < mySelectedShells.length; k++)
				{
					shell = mySelectedShells[k];
					if (mySelectedShells.length >= myGame.triggerLevel)
					{
						graphics.lineStyle(4, 0x00ff00);
						graphics.drawCircle(shell.x, shell.y, 16);
					}
					else
					{
						graphics.lineStyle(1, 0xffffff);
						graphics.drawCircle(shell.x, shell.y, 10);
					}
				}
			}
		}
		
		/******************************************************************************************
		 * Fields
		 */
		private var myGame: Game;
		private var myFrameCounter: int;
		private var myEnableMouseTrail: Boolean;
		private var myPoints: Array;
		private var mySelectedShells: Array;
	}
}