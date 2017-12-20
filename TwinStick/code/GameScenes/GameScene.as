package code.GameScenes {
	import flash.display.MovieClip;
	
	public class GameScene  extends MovieClip  {
		
		public function GameScene() {
			// constructor code
		}
		/**
		 * Called every frame. Checks if we need to change scenes.
		 * @return GameScene Returns null as a default.
		 */
		public function update(): GameScene
		{
			return null;
		}
		/** Called right after the scene is first changed to. */
		public function onEnter(): void {}
		/** Called right before the scene is changed. */
		public function onExit(): void {}

	}
	
}
