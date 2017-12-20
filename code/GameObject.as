package code {
	import flash.display.MovieClip;
	import code.GameScenes.GameScenePlay;
	import flash.geom.Point;

	/* Choosing to do inheritence over implementation for now, might change it */
	public class GameObject extends MovieClip{

		/** Determines when the object should be removed from the scene. */
		public var isDead: Boolean = false;
		
		public var health: Number;
		
		//public var tag: String; // was going to do this like unity but i can just use the is operator to tell what object
		
		/** ObjectAABB's, in case I want more than one. */
		public var aabb: ObjectAABB;
		
		public function GameObject(hp: Number = 0, w: Number = NaN, h: Number = NaN) {
			if(isNaN(w)) w = width;
			if(isNaN(h)) h = height;
			setCollisionBoxes(w, h);
			health = hp;
		}
		
		/** Called every function, calls the move and check function. */
		public function update(): void 
		{
			aabb.calcAABB(x,y);
		}
		/** Adds a objectAABB to the array of collision boxes. */
		protected function setCollisionBoxes(w: Number, h: Number): void
		{
			aabb = new ObjectAABB()
			aabb.setSize(w, h);
			aabb.calcAABB(x,y);
		}
		/** 
		 * Called when this object collides with the player.
		 * @param player Reference to the play variable to called its on collision function.
		 * @param gameScene Regerence to the game scene to call some of its functions.
		 */
		public function onCollision(otherObject: GameObject): void
		{
			var fix: Point = aabb.findBestFix(otherObject.aabb)
			otherObject.applyFix(fix);
		}
		
		/** Applies a fix the move the object to the edge of whatever it's coliding with. */
		public function applyFix(fix: Point): void
		{
			// empty, only enemy and player will use this
		}
		/** Loses health, only Players, Portals, and Enemies use this. */
		public function loseHealth(num: Number): void
		{
			
		}
		
		

	}
	
}
