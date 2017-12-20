package code {
	
	import flash.display.MovieClip;
	import flash.geom.Point;
	import flash.media.H264Level;
	import code.GameScenes.GameScenePlay;
	
	public class Player extends GameObject {
		
		/** Scales the points as the game gets harder */
		public static var pointsScalar: Number = 1;
		
		/** Speed of player. Pixels per Second. */
		private var speed: Number = 250;
		/** Velocity, based on user input. */
		public var input: Point = new Point();
		
		public function Player() {
			x = 500;
			y = 500;
			super(300);
		}
		
		/** Called every frame. Updates direction and velocity. */
		override public function update(): void
		{
			rotation = Math.atan2(parent.mouseY - y, parent.mouseX - x) * Game.TO_DEG;
			
			input = new Point(); // using as a vector
			
			if(KeyboardState.isKeyDown(KeyboardState.KEY_LEFT) || KeyboardState.isKeyDown(KeyboardState.KEY_A)) {
				input.x--;
			}
			if(KeyboardState.isKeyDown(KeyboardState.KEY_RIGHT) || KeyboardState.isKeyDown(KeyboardState.KEY_D)) {
				input.x++;
			}
			if(KeyboardState.isKeyDown(KeyboardState.KEY_UP) || KeyboardState.isKeyDown(KeyboardState.KEY_W)) {
				input.y--;
			}
			if(KeyboardState.isKeyDown(KeyboardState.KEY_DOWN) || KeyboardState.isKeyDown(KeyboardState.KEY_S)) {
				input.y++;
			}
			
			if(input.length > 1) input.normalize(1); // so going diagnol doesnt move faster than straight.d
			x += input.x * speed * Game.deltaTime; // add delta time
			y += input.y * speed * Game.deltaTime;
			
			super.update();
		}
		/** Overrides onCollision so it doesn't do anything when it collides with unimportant things. */
		override public function onCollision(otherObj: GameObject): void {}
		/** 
		 * Apllies the fix if the player is overlapping with another object.
		 * @param fix A point object, the distance needed to move.
		 */
		override public function applyFix(fix: Point): void
		{
			x -= fix.x;  
			y -= fix.y; 
		}
		/** Overrides loseHealth to lose health when it's hit. */
		override public function loseHealth(num: Number): void
		{
			health -= num;
			if(health <= 0)
			{
				isDead = true;
				GameScenePlay(parent.parent).removeListeners();
			}
			else if (health > 300)
				health = 300;
		}
	}
	
}
