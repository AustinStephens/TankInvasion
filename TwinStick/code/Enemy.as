package code {
	
	import flash.display.MovieClip;
	import flash.geom.Point;
	import com.adobe.tvsdk.mediacore.timeline.Placement;
	import code.Sounds.Boom;
	
	
	public class Enemy extends GameObject {
		
		/** Damage scale, increases as game progresses. */
		public static var enemyDamageScalar: Number = 1;
		
		/** Target they are shooting at. */
		private var target: Player;
		/** Speed. Pixels per Second. */
		private var speed: Number = 50;
		/** How long the enemy has left before it changes direction. */
		private var moveTimer: Number = 0;
		/** Time between each shot. */
		public static var shootMax: Number = 5;
		/** Time left before next shot. */
		private var shootTimer: Number = shootMax;
		/** Velocity. Should be in GameObject, most will use this. */
		private var velocity: Point = new Point();
		/** Reference to it's healthbar. */
		public var healthBar: HealthBar;
		
		public function Enemy(player: Player) {
			target = player;
			randomDirection();
			super(100, 28, 28);
		}
		/** Updates position, timers, and the healthbar. */
		override public function update(): void
		{
			super.update();
			moveTimer -= Game.deltaTime;
			if(moveTimer <= 0)
				randomDirection();
			
			if(shootTimer > 0) shootTimer -= Game.deltaTime;
			else {
				Camera(parent).shootGun(new EnemyBullet(target, this));
				shootTimer = shootMax;
			}
			
			x += velocity.x * Game.deltaTime;
			y += velocity.y * Game.deltaTime;
			
			healthBar.update(health/100);
			
		}
		
		/** Shouldn't do anything when it collides with something, if it's important, the other object will do something. */
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
		/** Overrides loseHealth so it loses health when hit. */
		override public function loseHealth(num: Number): void
		{
			health -= num;
			if(health <= 0)
			{
				var boom: Boom = new Boom();
				boom.play();
				var amount: int = int(Math.random() * 10 + 10);
				for(var i: int = 0; i < amount; ++i)
				{
					Camera(parent).spawnParticle(new ParticleEnemy(x,y));
				}
				
				Camera(parent).score += int(50 * Player.pointsScalar);
				isDead = true;
			}
		}
		/** Moves at the speed in a random direction. */
		private function randomDirection(): void
		{
			var direction: Number = Math.random() * Math.PI * 2;
			velocity = new Point(Math.cos(direction) * speed, Math.sin(direction) * speed);
			
			moveTimer = Math.random() * 2 + 2;
		}
	}
	
}
