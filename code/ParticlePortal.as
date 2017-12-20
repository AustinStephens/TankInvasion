package code {
	
	import flash.display.MovieClip;
	
	
	public class ParticlePortal extends Particle {
		
		/** Spawns a particle with random attributes. */
		public function ParticlePortal(spawnx: Number, spawny: Number) {
			super(spawnx, spawny);
			//trace("child");
			velocity.x = Math.random() * 800 - 400;
			velocity.y = Math.random() * 800 - 400;
			
			scaleX = scaleY = Math.random() * 1 + 1.5;
			
			scaleVelocity = Math.random() * .5;
			
			fadeOutVelocity = Math.random() * 1 + .5;
			
			lifeSpan = Math.random() * .75 + .5;
		}
	}
	
}
