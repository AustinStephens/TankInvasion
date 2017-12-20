package code {
	
	import flash.display.MovieClip;
	
	
	public class HealthBar extends MovieClip {
		
		/** The colored part of the bar. */
		public var bar;
		/** Original width, new width is based on the percentage of health. */
		private const originalWidth: Number = 69.45;
		
		public function HealthBar() {
			bar.gotoAndStop(1);
		}
		/** Updates width of bar, and changes color based on health. */
		public function update(percent: Number): void
		{
			bar.width = originalWidth * percent;
			if (percent > .6) bar.gotoAndStop(1);
			else if(percent > .25) bar.gotoAndStop(2);
			else bar.gotoAndStop(3);
		}
	}
	
}
