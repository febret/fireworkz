package fireworkz
{
	import flash.display.*;
	import flash.events.*;
	import flash.filters.*;
	import flash.text.*;
	import flash.media.*;
	import assets.*;

	/**********************************************************************************************
	 * @author Alessandro Febretti
	 */
	public class Game extends Sprite
	{
		/******************************************************************************************
		 * Generic Game constants
		 */
		public static const ACTIVATION_TIME: uint = 50;
		public static const FPS: uint = 25;
		public static const SCREEN_WIDTH: int = 760;
		public static const SCREEN_HEIGHT: int = 600;
		public static const STEP_TIME: int =  1500;
		
		/******************************************************************************************
		 * States
		 */
		public static const STATE_ACT1: int = 0;
		public static const STATE_ACT2: int = 1;
		public static const STATE_ACT3: int = 2;
		public static const STATE_ACT4: int = 3;
		public static const STATE_GAME_OVER: int = 7;
		public static const STATE_LEVEL_CLEAR: int = 8;
		 
		/******************************************************************************************
		 */
		static public function formatPoints(pts: String): String 
		{
			var result: String = "";
			for (var i: int = pts.length - 1; i >= 0; i--)
			{
				if ((pts.length - i) % 3 == 1 && (pts.length - i) != 1)
				{
					result = "," + result;
				}
				result = pts.charAt(i) + result;
			}
			return result;
		}
		
		/******************************************************************************************
		 */
		public function Game(mng: GameManager) 
		{
			myMng = mng;
			myMng.addChild(this);
			
			// Panorama bitmap
			switch(myMng.currentLevel)
			{
			case 0:
				myPanorama = new GameGfx.Panorama3();
				break;
			case 1:
				myPanorama = new GameGfx.Panorama1();
				break;
			case 2:
				myPanorama = new GameGfx.Panorama2();
				break;
			}
			addChild(myPanorama);
			myPanorama.y = 10;
			
			myShells = new Array();
			myShellsTBDestroyed = new Array();
			
			myOverlay = new Overlay(this);
			
			initText();
			
			enterState(STATE_ACT1);
			
			addEventListener(Event.ENTER_FRAME, onFrame);
			addEventListener(MouseEvent.MOUSE_UP, onMouseUp);
			addEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);
		}
		
		/******************************************************************************************
		 */
		public function enterState(state: int): void
		{
			var ovl: TextOverlay;
			switch(state)
			{
			case STATE_ACT1:
				ovl = new TextOverlay(this);
				ovl.text = "ACT 1: PROLOGUE";
				break;
			case STATE_ACT2:
				ovl = new TextOverlay(this);
				ovl.text = "ACT 2: UP A NOTCH";
				break;
			case STATE_ACT3:
				ovl = new TextOverlay(this);
				ovl.text = "ACT 3: MAIN COURSE";
				break;
			case STATE_ACT4:
				ovl = new TextOverlay(this);
				ovl.text = "ACT 3: GRAND FINALE";
				break;
			case STATE_GAME_OVER:
				ovl = new TextOverlay(this);
				ovl.text = "LEVEL FAILED...";
				break;
			case STATE_LEVEL_CLEAR:
				ovl = new TextOverlay(this);
				ovl.text = "LEVEL CLEAR!!";
				break;
			}
			myState = state;
		}
		
		/******************************************************************************************
		 */
		public function gameOver(success: Boolean): void
		{
			myMng.removeChild(this);
			if (success)
			{
				myMng.enterState(GameManager.STATE_SUCCESS);
			}
			else
			{
				myMng.enterState(GameManager.STATE_GAME_OVER);
			}
			
			removeEventListener(Event.ENTER_FRAME, onFrame);
			removeEventListener(MouseEvent.MOUSE_UP, onMouseUp);
			removeEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);
		}
		
		/******************************************************************************************
		 */
		public function get shells(): Array
		{
			return myShells;
		}
		
		/******************************************************************************************
		 */
		public function addPoints(pts: int): void
		{
			myMng.score.addValue(pts);
			myPointsText.text = formatPoints(myMng.score.value.toString());
		}
		
		/******************************************************************************************
		 */
		public function get requiredSuccessRate(): Number
		{
			return myRequiredSuccessRate;
		}
		
		/******************************************************************************************
		 */
		public function set requiredSuccessRate(value: Number): void
		{
			myRequiredSuccessRate = value;
		}
		
		/******************************************************************************************
		 */
		public function get triggerLevel(): int
		{
			if (myState == STATE_ACT1 || myState == STATE_ACT2) return 2;
			return 3;
		}
		
		/******************************************************************************************
		 */
		public function get mng(): GameManager
		{
			return myMng;
		}
		
		/******************************************************************************************
		 */
		private function initText(): void
		{
			// Initialize debug text.
			var fmt:TextFormat = new TextFormat();
			fmt.font = "DefaultFont";
            fmt.size = 18;
			fmt.color = 0xffffff;
			
			myPointsText = new TextField();
			myPointsText.defaultTextFormat = fmt;
			myPointsText.sharpness = 50;
			myPointsText.embedFonts = true;
			myPointsText.autoSize = TextFieldAutoSize.LEFT;
			myPointsText.antiAliasType = AntiAliasType.ADVANCED;
			addChild(myPointsText);
			
			mySuccessText = new TextField();
			mySuccessText.defaultTextFormat = fmt;
			mySuccessText.sharpness = 50;
			mySuccessText.x = 560;
			mySuccessText.embedFonts = true;
			mySuccessText.autoSize = TextFieldAutoSize.LEFT;
			mySuccessText.antiAliasType = AntiAliasType.ADVANCED;
			addChild(mySuccessText);
			
			myTimeText = new TextField();
			myTimeText.defaultTextFormat = fmt;
			myTimeText.sharpness = 50;
			myTimeText.x = 320;
			myTimeText.embedFonts = true;
			myTimeText.autoSize = TextFieldAutoSize.CENTER;
			myTimeText.antiAliasType = AntiAliasType.ADVANCED;
			addChild(myTimeText);
		}
		
		/******************************************************************************************
		 */
		private function updateStep(): void 
		{
			// Update step.
			if (myFrameCounter > STEP_TIME)
			{
				// Explode all still present shells.
				for (var j: int = 0; j < myShells.length; j++)
				{
					if (!myShells[j].destroyed)
					{
						myShells[j].explode();
						myShells[j].destroy();
					}
				}
				
				myFrameCounter = 0;
				if ((1 - Number(myFailedShells) / myTotShells) < myRequiredSuccessRate)
				{
					enterState(STATE_GAME_OVER);
				}
				else
				{
					switch(myState)
					{
					case STATE_ACT1:
						enterState(STATE_ACT2);
						break;
					case STATE_ACT2:
						enterState(STATE_ACT3);
						break;
					case STATE_ACT3:
						enterState(STATE_ACT4);
						break;
					case STATE_ACT4:
						enterState(STATE_LEVEL_CLEAR);
						break;
					}
					
					myTotShells = 0;
					myFailedShells = 0;
				}
			}
			
			if (myState <= STATE_ACT4)
			{
				if (myPanorama.x + myState * 690 > 16)
				{
					// Scroll panorama.
					myPanorama.x = (myPanorama.x * 18 - myState * 690) / 19;
				}
			}
		}
		
		/******************************************************************************************
		 */
		private function updateText(): void 
		{
			// Compute the success ratio.
			var sr: Number;
			if (myTotShells > 0)
			{
				sr = 1 - (Number(myFailedShells) / myTotShells);
			}
			else
			{
				sr = 1;
			}
			
			// Update success text.
			mySuccessText.text = "Success Level: " + int(sr * 100) + "%";
			if (sr < myRequiredSuccessRate)
			{
				mySuccessText.textColor = 0xff0000;
			}
			else if (sr < (myRequiredSuccessRate + 0.05))
			{
				mySuccessText.textColor = 0xffff00;
			}
			else
			{
				mySuccessText.textColor = 0x00ff00;
			}
			
			// Update time left text.
			var timeLeft: int = (STEP_TIME - myFrameCounter) / Game.FPS;
			myTimeText.htmlText = "Time Left: " + timeLeft + " seconds";
			
			if (myState >= STATE_ACT3)
			{
				myTimeText.htmlText = "<font color=\"#FF5555\">3X COMBO ONLY!</font> " + " Time Left: " + timeLeft + " seconds";
			}
		}

		/******************************************************************************************
		 */
		private function shootShells(): void 
		{
			// Set the number of shells and interval depending on act.
			var numShells: int = 2;
			var interval: int = 50;
			if (myState == STATE_ACT2) numShells = 3;
			else if (myState == STATE_ACT3) numShells = 4;
			else if (myState == STATE_ACT4) { numShells = 4; interval = 25; }
			
			if (myFrameCounter % 50 == 0)
			{
				var shell: Shell;
				if (numShells == 2)
				{
					shell = new Shell(this, 370, 600);
					myShells.push(shell);
					shell = new Shell(this, 450, 600);
					myShells.push(shell);
				}
				else if (numShells == 3)
				{
					shell = new Shell(this, 330, 600);
					myShells.push(shell);
					shell = new Shell(this, 410, 600);
					myShells.push(shell);
					shell = new Shell(this, 490, 600);
					myShells.push(shell);
				}
				else
				{
					shell = new Shell(this, 290, 600);
					myShells.push(shell);
					shell = new Shell(this, 370, 600);
					myShells.push(shell);
					shell = new Shell(this, 450, 600);
					myShells.push(shell);
					shell = new Shell(this, 530, 600);
					myShells.push(shell);
				}
				myTotShells += numShells;
			}
		}
		
		/******************************************************************************************
		 */
		private function onNormalFrame(): void 
		{
			updateStep();
			if (myFrameCounter > 50)
			{
				shootShells();
				
				// Destroy out-of-screen shells.
				myShellsTBDestroyed = new Array();
				for (var i: int = 0; i < myShells.length; i++)
				{
					var shell: Shell = myShells[i];
					if (shell.y <= 0)
					{
						shell.destroy();
						myShellsTBDestroyed.push(i);
						myFailedShells++;
					}
				}
				for (i = 0; i < myShellsTBDestroyed.length; i++)
				{
					myShells.splice(myShellsTBDestroyed[i], 1);
				}
				updateText();
			}
		}
		
		/******************************************************************************************
		 */
		private function onEndGameFrame(): void 
		{
			if(myFrameCounter > 60)
			{
				if (myState == STATE_GAME_OVER) gameOver(false);
				else gameOver(true);
			}
			myPanorama.alpha -= 1 / Game.FPS;
		}
		
		/******************************************************************************************
		 */
		private function onFrame(e: Event): void 
		{
			myFrameCounter++;
			
			switch(myState)
			{
			case STATE_ACT1:
				onNormalFrame();
				break;
			case STATE_ACT2:
				onNormalFrame();
				break;
			case STATE_ACT3:
				onNormalFrame();
				break;
			case STATE_ACT4:
				onNormalFrame();
				break;
			case STATE_GAME_OVER:
				onEndGameFrame();
				break;
			case STATE_LEVEL_CLEAR:
				onEndGameFrame();
				break;
			}
		}
		
		/**********************************************************************************************
		 */
		private function onMouseUp(e: MouseEvent): void 
		{
			myOverlay.enableMouseTrail = false;
		}
		
		/**********************************************************************************************
		 */
		private function onMouseDown(e: MouseEvent): void 
		{
			myOverlay.enableMouseTrail = true;
		}
		
		/******************************************************************************************
		 * Fields
		 */
		private var myMng: GameManager;
		private var myShells: Array;
		private var myShellsTBDestroyed: Array;
		private var myFrameCounter: int;
		// State
		private var myState: int;
		// Graphics.
		private var myPanorama: Bitmap;
		private var myDifficulty: int;
		//private var myTarget: int;
		private var myOverlay: Overlay;
		// Gameplay vars.
		//private var myStep: int;
		private var myShellActivation: int;
		private var myRequiredSuccessRate: Number;
		private var myTotShells: int;
		private var myFailedShells: int;
		// Shell chaining
		//private var myTargetShell: Shell;
		//private var myLastActivatedShell: Shell;
		// Text fields.
		private var myPointsText: TextField;
		private var mySuccessText: TextField;
		private var myTimeText: TextField;
	}
}