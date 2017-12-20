package code.GameScenes{
	
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	
	
	public class GameSceneMenu extends GameScene {
		
		/** Boolean determining whether or not the player hit the play button. */
		private var playFlag: Boolean = false;
		
		/** Tank on the screen, used as a button to play the game */
		public var playBtn;
		
		public function GameSceneMenu() {
			// constructor code
		}
		
		/** Adds event listeners. */
		override public function onEnter(): void
		{
			playBtn.addEventListener(MouseEvent.CLICK, playClick);

		}
		/** Removes event listeners. */
		override public function onExit(): void
		{
			playBtn.removeEventListener(MouseEvent.CLICK, playClick);
		}
		/** Checks if the button has been clicked yet. */
		override public function update(): GameScene
		{
			if(playFlag) return new GameScenePlay();
			return null;
		}
		
		private function playClick(e: MouseEvent): void
		{
			playFlag = true;
		}
	}
	
}
