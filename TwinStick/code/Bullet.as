package code {
	import flash.geom.Point;
	
	public class Bullet extends GameObject {

		/** Speed of the bullet. */
		protected var speed: Number = 0;
		/** Damage done by the bullet. */
		protected var damage: Number = 0;
		/** Velocity. Should be in GameObject. */
		protected var velocity: Point = new Point();
		
		public function Bullet(sp: Number, dmg: Number) {
			speed = sp;
			damage = dmg;
		}
		/** Called every frame. Updates position. */
		override public function update(): void
		{
			super.update();
			
			x += velocity.x * Game.deltaTime;
			y += velocity.y * Game.deltaTime;
			
		}
		/** Damages the object if it's not the player of a healthpack. */
		override public function onCollision(otherObj: GameObject): void
		{
			if(!(otherObj is Player) && !(otherObj is HealthPack))
			{
				isDead = true;
				otherObj.loseHealth(damage); // walls wont do anything when this is called
			}
		}
		/** Shoots in the player's direction. */
		protected function angle(player: Player): void
		{
			rotation = player.rotation;
			
			var cos: Number = Math.cos(rotation * Game.TO_RAD);
			var sin: Number = Math.sin(rotation * Game.TO_RAD)
			y = player.y + (cos * width / 2);
			x = player.x + (sin * height / 2);
			
			velocity.x = cos * speed;
			velocity.y = sin * speed;
		}

	}
	
}
