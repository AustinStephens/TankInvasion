package code {
	
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.utils.getTimer;
	import code.GameScenes.*;
	import code.Sounds.Music;
	import flash.media.SoundChannel;
	import flash.media.SoundTransform;
	
	
	public class Game extends MovieClip {
		
		/** Math constants. */
		public static const TO_DEG: Number = 180 / Math.PI;
		public static const TO_RAD: Number = 1 / TO_DEG;
		
		/** Change in time */
		public static var deltaTime: Number;
		/** Scale of delta time */
		public static var timeScale: Number = 1;
		/** Time stamp of previous frame */
		private var prevTime: int = 0;
		/** Scene curerently being displayed */
		private var scene: GameScene;
		
		public var sound: Music = new Music();
		
		public function Game() {
			stage.focus = stage;
			setScene(new GameSceneMenu());
			playSound();
			
			KeyboardState.setup(stage);
			addEventListener(Event.ENTER_FRAME, gameLoop);
		}
		
		private function gameLoop(e: Event): void
		{
			//delta time update
			getDeltaTime();
			
			// SCENE MANAGMENT / UPDATE SECTION
			if(scene != null)
			{
				var newScene: GameScene = scene.update();
				if(newScene != null)
					setScene(newScene);
			}
			
			KeyboardState.update();
		}
		
		/**
		 * Calculates delta time and stores it in our static delta time variable
		 */
		public function getDeltaTime(): void
		{
			var currentTime: int = getTimer();
			deltaTime = (currentTime - prevTime) / 1000.0 * timeScale;
			prevTime = currentTime;
		}
		
		/**
		 * Changes the scene, called when the update function for the scene returns a new scene.
		 * @param  newScene   The scene being changed to.
		 */
		private function setScene(newScene: GameScene): void
		{
			var newScore: Number; // score of the previous scene
			if(scene != null) 
			{
				removeChild(scene); // remove old scene
				scene.onExit();
			}
			
			scene = newScene;
			addChild(scene); // add new scene
			scene.onEnter();
			stage.focus = stage;
		}
		
		/** 
		  *Plays the sound and adds an event listener to loop it, just loops, doesn't change or restart when in a new scene or when you die.
		  *It's hard to find free and non royalty music.
		  */
		private function playSound():void
		{
			var channel:SoundChannel = sound.play(0, 1, new SoundTransform(.1));
			channel.addEventListener(Event.SOUND_COMPLETE, onComplete);
		}
		/** Called when the sound is complete to loop it */
		private function onComplete(event:Event):void
		{
			SoundChannel(event.target).removeEventListener(event.type, onComplete);
			playSound();
		}
	}
	
}
