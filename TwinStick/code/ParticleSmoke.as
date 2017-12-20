package code {
	
	import flash.display.MovieClip;
	
	
	public class ParticleSmoke extends Particle {
		
		/** Spawns a particle with random attributes. */
		public function ParticleSmoke(spawnx: Number, spawny: Number) {
			super(spawnx,spawny);
			
			velocity.y = Math.random() * 200 - 300;
			velocity.x = Math.random() * 400 - 200;
			
			scaleVelocity = Math.random() * 1.5 + 1.5;
			fadeOutVelocity = Math.random() * 1 + 1.5;
			
			lifeSpan = Math.random() * 1 + 1.5;
		}
	}
	
}
