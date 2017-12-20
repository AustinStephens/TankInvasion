package code {
	
	import flash.display.MovieClip;
	
	
	public class ParticleEnemy extends Particle {
		
		/** Spawns a particle with random attributes. */
		public function ParticleEnemy(spawnx: Number, spawny: Number) {
			super(spawnx, spawny);

			velocity.x = Math.random() * 800 - 400;
			velocity.y = Math.random() * 800 - 400;
			
			scaleX = scaleY = Math.random() * 1 + .75;
			
			scaleVelocity = Math.random() * .5;
			
			fadeOutVelocity = Math.random() * 1 + .5;
			
			lifeSpan = Math.random() * .5 + .5;
		}
	}
	
}
