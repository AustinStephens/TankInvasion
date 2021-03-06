﻿package code {
	import flash.display.MovieClip;
	/** Made this a class to keep all the elements of a room in one object, but I didn't want it to have it's own aabb. */
	public class Room extends MovieClip {

		/** Walls. */
		public var walls: Array = new Array(new WallVertical(-750, 450), new WallVertical(-750, -450), new WallHorizontal(-400, -750), new WallHorizontal(400, -750),
											new WallVertical(750, -450), new WallVertical(750, 450), new WallHorizontal(400, 750),  new WallHorizontal(-400, 750));
		/** Doors. */
		public var doors: Array = new Array(new DoorVertical(-750, 0), new DoorHorizontal(0, -750), new DoorVertical(750, 0), new DoorHorizontal(0, 750));
		
		/** Adds all the doors and walls as Children. */
		public function Room() {
			var i: int = 0;
			for (i; i < doors.length; i++) {
				addChild(doors[i]);
			}
			for (i = 0; i < walls.length; i++) {
				addChild(walls[i]);
			}
		}
		
		/** Called every frame. */
		public function update(): void
		{
			collisions();
		}
		
		/** Checks for collisions. */
		private function collisions(): void
		{
			var i: int;
			var k: int;
			for(i = walls.length - 1; i >= 0; --i)
			{
				for(k = 0; k < Camera(parent).gameScene.length; ++k)
				{
					if(walls[i].aabb.checkOverlap(Camera(parent).gameScene[k].aabb))
					{
						Camera(parent).gameScene[k].onCollision(walls[i]);
						walls[i].onCollision(Camera(parent).gameScene[k]);
					}
				}
			}

			for(i = doors.length - 1; i >= 0; --i) 
			{
				for(k = 0; k < Camera(parent).gameScene.length; ++k)
				{
					if(doors[i].aabb.checkOverlap(Camera(parent).gameScene[k].aabb))
					{
						Camera(parent).gameScene[k].onCollision(doors[i]);
						doors[i].onCollision(Camera(parent).gameScene[k]);
					}
				}
			}
		}

	}
	
}
