package code {
	
	import flash.display.MovieClip;
	
	
	public class EnemyBullet extends Bullet {
		
		/** Speed Scalar of the bullet, gets faster as game progresses */
		public static var enemySpeedScalar: Number = 1;
		
		/** Timer for invulnerability, so it doesn't hit the enemy shooting it immediately. */
		private var invulnerable: Number = .5;
		
		/** Picks a type of shot randomly and sets the velocity. */
		public function EnemyBullet(player: Player, enemy: Enemy) {
			super(500, 20);
			
			var typeOfShot: int = int(Math.random() * 3);
			
			var dx: Number = 0;
			var dy: Number = 0;
			switch (typeOfShot)
			{
				case 0: // shoots directly at player.
					dx = player.x - enemy.x;
					dy = player.y - enemy.y;
					break;
				case 1: // shoots at where the player should be in 3 seconds if they kept moving at the rate they were.
					dx = player.x + (player.input.x * 3/*2=time*/) - enemy.x;
					dy = player.y + (player.input.y * 3) - enemy.y;
					break;
				case 2: // shoots halfway to where they should be in 3 seconds if they kept moving at the rate they were.
					dx = (player.x + (player.input.x * 3) - enemy.x) / 2;
					dy = (player.y + (player.input.y * 3) - enemy.y) / 2;
					break;
				default:
					break;
			}
			
			var h: Number = Math.sqrt((dx*dx) + (dy*dy));
			x = enemy.x + (dx / h * 20);
			y = enemy.y + (dy / h * 20);
			
			velocity.x = dx / h * speed * enemySpeedScalar;
			velocity.y = dy / h * speed * enemySpeedScalar;
		}
		
		/** Called every frame. Just updates the invulnerable timer. */
		override public function update(): void
		{
			super.update();
			
			if(invulnerable > 0) invulnerable -= Game.deltaTime;
		}
		
		/** Only does something if invulnerable is <= 0, if it's a player or another enemy, it damages them. */
		override public function onCollision(otherObj: GameObject): void
		{
			if(invulnerable <=0) isDead = true;
			if((otherObj is Player) || (otherObj is Enemy && invulnerable <= 0))
			{
				isDead = true;
				otherObj.loseHealth(damage * Enemy.enemyDamageScalar); // walls wont do anything when this is called
			}
		}
	}
	
}
