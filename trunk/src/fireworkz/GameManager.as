package fireworkz
{
	import assets.GameSfx;
	import flash.display.*;
	import flash.events.*;
	import flash.filters.*;
	import flash.text.*;
	import flash.net.*;
	import flash.media.*;
	import flash.utils.Timer;
	import mx.controls.Button;
	import mx.core.*;
	import mochi.as3.*;

	/**********************************************************************************************
	 * @author Alessandro Febretti
	 */
	public dynamic class GameManager extends UIComponent
	{
		/******************************************************************************************
		 * Constants.
		 */
		public var _mochiads_game_id:String = "cf30c7f61e417ca4";
	
		/******************************************************************************************
		 * Game states
		 */
		public static const STATE_MAIN_SCREEN: String = "main";
		public static const STATE_GUIDE: String  = "guide";
		public static const STATE_NEXT_LEVEL: String  = "nextLevel";
		public static const STATE_SUCCESS: String  = "success";
		public static const STATE_GAME: String  = "game";
		public static const STATE_GAME_OVER: String  = "gameOver";
		 
		/******************************************************************************************
		 */
		public function GameManager() 
		{
			currentLevel = 0;
		}
		
		/******************************************************************************************
		 */
		public function init(): void 
		{
			MochiServices.connect("cf30c7f61e417ca4", this);
			
			myMusicTimer = new Timer(180000);
			myMusicTimer.addEventListener(TimerEvent.TIMER, onMusicTimer);
			myMusicTimer.start();
			
			myScore = new MochiDigits();
			
			mySoundOn = false;
			
			enterState(GameManager.STATE_MAIN_SCREEN);
		}

		/******************************************************************************************
		 */
		public function get soundEnabled(): Boolean
		{
			return mySoundOn;
		}
		
		/******************************************************************************************
		 */
		public function set soundEnabled(value: Boolean): void
		{
			mySoundOn = value;
			if (!mySoundOn)
			{
				myMusicChannel.stop();
			}
			else
			{
				myMusicChannel = (new GameSfx.Music().play());
			}
		}
		
		/******************************************************************************************
		 */
		public function get currentLevel(): int
		{
			return myLevel;
		}
		
		/******************************************************************************************
		 */
		public function set currentLevel(value: int): void
		{
			myLevel = value;
		}
		
		/******************************************************************************************
		 */
		public function get requiredSuccessLevel(): Number
		{
			return myRequiredSuccessLevel;
		}
		
		/******************************************************************************************
		 */
		public function get score(): MochiDigits
		{
			return myScore;
		}
		
		/******************************************************************************************
		 */
		public function set requiredSuccessLevel(value: Number): void
		{
			myRequiredSuccessLevel = value;
		}
		
		/******************************************************************************************
		 * Manager the main state machine transitions.
		 */
		public function enterState(state: String): void 
		{
			if (state == STATE_MAIN_SCREEN)
			{
				var mainScreen: MainScreen = new MainScreen(this);
			}
			else if (state == STATE_GUIDE)
			{
				var guideScreen: GuideScreen = new GuideScreen(this);
			}
			else if (state == STATE_NEXT_LEVEL)
			{
				var nextLevelScreen: NextLevelScreen = new NextLevelScreen(this);
			}
			else if (state == STATE_SUCCESS)
			{
				var successScreen: SuccessScreen = new SuccessScreen(this);
			}
			else if (state == STATE_GAME_OVER)
			{
				var gameOverScreen: GameOverScreen = new GameOverScreen(this);
			}
			else if (state == STATE_GAME)
			{
				var game: Game = new Game(this);
				game.requiredSuccessRate = myRequiredSuccessLevel;
			}
			myState = state;
		}
		
		/******************************************************************************************
		 */
		private function onMusicTimer(e: TimerEvent): void
		{
			myMusicTimer.reset();
			myMusicTimer.start();
			if (mySoundOn)
			{
				myMusicChannel = new GameSfx.Music().play(0, 0);
			}
		}
		
		/******************************************************************************************
		 * Fields
		 */
		private var myState: String;
		private var myBackground: Shape;
		private var myMusicTimer: Timer;
		// Gameplay vars.
		private var myLevel: int;
		private var myRequiredSuccessLevel: Number;
		private var myScore: MochiDigits;
		// Sound stuff.
		private var myMusicChannel: SoundChannel;
		private var mySoundOn: Boolean;
	}
}