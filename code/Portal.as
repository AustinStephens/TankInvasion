package code {
	
	import flash.display.MovieClip;
	
	
	public class Portal extends GameObject {
		
		/** Time between each enemy spawn. */
		public static var maxTimer: Number = 3;
		/** Time left until next enemy spawn. */
		private var spawnTimer: Number = maxTimer;
		/** Reference to the healthbar. */
		public var healthBar: HealthBar = new HealthBar();
		
		public function Portal(newx: Number, newy: Number) {
			x = newx;
			y = newy;
			super(200, 80, 30);
		}
		/** Called every frame. Updates healthbar and timers. */
		override public function update(): void
		{
			super.update();
			
			spawnTimer -= Game.deltaTime;
			if(spawnTimer <= 0)
			{
				spawnTimer = maxTimer;
				Camera(parent).spawnEnemy(x,y);
			}
			
			healthBar.update(health/200);
		}
		
		override public function onCollision(otherObj: GameObject): void {}
		
		/** Loses health when a bullet collides with it. */
		override public function loseHealth(num: Number): void
		{
			health -= num;
			if(health <= 0)
			{
				var amount: int = int(Math.random() * 10 + 15);
				for(var i: int = 0; i < amount; ++i)
				{
					Camera(parent).spawnParticle(new ParticlePortal(x,y));
				}
				Camera(parent).score += int(200 * Player.pointsScalar);
				isDead = true;
			}
		}
	}
	
}
