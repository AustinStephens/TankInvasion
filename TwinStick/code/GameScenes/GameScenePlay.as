package code.GameScenes {
	
	import flash.display.MovieClip;
	import code.*;
	import flash.geom.Point;
	import flash.events.MouseEvent;
	import flash.display.MorphShape;
	
	
	public class GameScenePlay extends GameScene {
		
		private var isMouseDown: Boolean = false;
		/** Camera, follows player. */
		public var cam: Camera;
		/** Player variable. */
		public var player: Player = new Player();
		
		/** Cooldown for the mini Gun. */
		private var delaySpawnBullet: Number = 0;
		/** Cooldown for the large Gun. */
		private var delayLargeBullet: Number = 0;
		/** Time between large Gun fires. */
		private const DELAY_MAX_LARGE: Number = 2;
		/** Time between mini Gun fires. */
		private const DELAY_MAX: Number = .2;
		/** How long the game waits after the player dies before going to GameSceneLose. */
		private var deathTimer: Number = 3;
		
		/** References to UI. */
		private var scoreText: ScoreText = new ScoreText();
		private var healthText: ScoreText = new ScoreText();
		private var healthBar: HealthBar = new HealthBar();
		
		/** Called right after the scene is first changed to. */
		override public function onEnter(): void 
		{
			scoreText.x = 200;
			scoreText.y = 50;
			healthBar.x = 900;
			healthBar.y = 50;
			healthText.x = 800
			healthText.y = 50;
			healthText.textField.text = "Health:";
			healthBar.scaleX = healthBar.scaleY = 2;
			
			cam = new Camera(player);
			addChildAt(cam, 0);
			cam.addChild(player);
			
			addChildAt(scoreText,1);
			addChildAt(healthText,1);
			addChildAt(healthBar,1);
			
			
			stage.addEventListener(MouseEvent.MOUSE_DOWN, onClick);
			stage.addEventListener(MouseEvent.MOUSE_UP, onClick);
			stage.addEventListener(MouseEvent.RIGHT_MOUSE_DOWN, onRightClick);
			stage.addEventListener(MouseEvent.CONTEXT_MENU, function(e:MouseEvent):void {}); // does nothing, stops right click from opening context menu
		}
		
		/** Resets all static variables */
		override public function onExit(): void
		{
			Player.pointsScalar = 1;
			Enemy.enemyDamageScalar = 1;
			Enemy.shootMax = 5;
			EnemyBullet.enemySpeedScalar = 1;
			Portal.maxTimer = 3;
			Room.totalPortals = 6;
			Room.startingPortals = 3;
		}
		
		/** Called every frame. Updates timers, updates the camera, shoots the miniGun, and updates UI. */
		override public function update(): GameScene
		{
			
			if(delaySpawnBullet > 0) delaySpawnBullet -= Game.deltaTime;
			
			if(delayLargeBullet > 0) delayLargeBullet -= Game.deltaTime;
				
			if(isMouseDown && delaySpawnBullet <= 0)
			{
				var bullet: SmallBullet = new SmallBullet(player);
				cam.shootGun(bullet);
				delaySpawnBullet = DELAY_MAX;
			}
			
			if(player.isDead) {
				if(deathTimer > 0) deathTimer -= Game.deltaTime;
				else return new GameSceneLose(cam. score);
			}
			
			cam.update();
			scoreText.textField.text = "Score: " + cam.score;
			healthBar.update(player.health / 300);
			
			
			return null;
		}
		
		/** Sets isMouseDown to whether or not it is down. */
		private function onClick(e: MouseEvent): void
		{
			isMouseDown = (e.type == MouseEvent.MOUSE_DOWN);
		}
		/** Shoots a largeBullet if the cooldown is reset. */
		private function onRightClick(e: MouseEvent): void
		{
			if(delayLargeBullet <= 0)
			{
				var bullet: LargeBullet = new LargeBullet(player);
				cam.shootGun(bullet);
				delayLargeBullet = DELAY_MAX_LARGE;
			}
		}
		/** Removes the event listeners before the scene exits, because it waits 3 seconds before going to the GameSceneLose. */
		public function removeListeners(): void
		{
			stage.removeEventListener(MouseEvent.MOUSE_DOWN, onClick);
			stage.removeEventListener(MouseEvent.MOUSE_UP, onClick);
			stage.removeEventListener(MouseEvent.RIGHT_MOUSE_DOWN, onRightClick);
			stage.removeEventListener(MouseEvent.CONTEXT_MENU, function(e:MouseEvent):void {}); // does nothing, stops right click from opening context menu
			isMouseDown = false;
		}
	}
	
}
