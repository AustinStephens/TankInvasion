package code {
	import flash.geom.Point;
	import flash.display.MovieClip;
	
	public class Particle extends MovieClip {

		/** Velocity. */
		protected var velocity: Point = new Point();
		/** Acceleration. */
		protected var acceleration: Point = new Point();
		
		/** How fast the scale/size changes. */
		protected var scaleVelocity: Number = 0; // could be 2d but were scaling proportionally.
		/** How fast it rotates. */
		protected var rotationVelocity: Number = 0;
		/** How fast it fades out. */
		protected var fadeOutVelocity: Number = 0;
		/** How long the particle should live for. */
		protected var lifeSpan: Number;
		/** Current age of the particle. */
		protected var age: Number = 0;
		
		/** Whether the particle should fade out once it's dead or fade out until it's dead. */
		protected var shouldFadeWhenDead: Boolean = false;
		/** If the particle is dead. */
		public var isDead: Boolean = false;
		
		public function Particle(spawnx: Number, spawny: Number) {
			//trace("parent");
			x = spawnx;
			y = spawny;
		}
		
		/** Called every frame. Updates position, velocity, scale, rotation, age, and alpha. */
		public function update(): void
		{
			//velocity.add(acceleration * Game.deltaTime);
			velocity.x += acceleration.x * Game.deltaTime;
			velocity.y += acceleration.y * Game.deltaTime;
			x += velocity.x * Game.deltaTime;
			y += velocity.y * Game.deltaTime;
			
			scaleY += scaleVelocity * Game.deltaTime;
			scaleX = scaleY;
			
			rotation += rotationVelocity * Game.deltaTime;
			
			age += Game.deltaTime;
			if(age > lifeSpan)
			{
				if(shouldFadeWhenDead)
					alpha -= fadeOutVelocity * Game.deltaTime;
				else
					isDead = true;
			}
			
			if(!shouldFadeWhenDead)
				alpha -= fadeOutVelocity * Game.deltaTime;
		}

	}
	
}
