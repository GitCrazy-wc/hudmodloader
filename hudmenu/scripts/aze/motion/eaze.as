package aze.motion
{
   public function eaze(param1:Object) : EazeTween
   {
      return new EazeTween(param1);
   }
}

import aze.motion.specials.PropertyBezier;
import aze.motion.specials.PropertyColorMatrix;
import aze.motion.specials.PropertyFilter;
import aze.motion.specials.PropertyFrame;
import aze.motion.specials.PropertyRect;
import aze.motion.specials.PropertyShortRotation;
import aze.motion.specials.PropertyTint;
import aze.motion.specials.PropertyVolume;

PropertyTint.register();
PropertyFrame.register();
PropertyFilter.register();
PropertyVolume.register();
PropertyColorMatrix.register();
PropertyBezier.register();
PropertyShortRotation.register();
PropertyRect.register();

