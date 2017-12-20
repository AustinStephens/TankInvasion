package code.GameScenes {
	
	import flash.display.MovieClip;
	import code.ScoreText;
	import flash.events.MouseEvent;
	
	
	public class GameSceneLose extends GameScene {
		
		/** Boolean determining whether or not the player hit the play button. */
		private var playFlag: Boolean = false;
		
		/** Reference to the button. */
		public var playBtn;
		/** Refernce to the text field. */
		public var scoreText: ScoreText;
		
		public function GameSceneLose(s: Number) {
			scoreText.textField.text = "Score: " + s;
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
			if(playFlag) return new GameSceneMenu();
			return null;
		}
		
		private function playClick(e: MouseEvent): void
		{
			playFlag = true;
		}
	}
	
}
