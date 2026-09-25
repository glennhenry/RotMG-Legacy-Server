package kabam.rotmg.ui.view.components
{
   import com.company.assembleegameclient.ui.SoundIcon;
   import flash.display.Sprite;
   
   public class ScreenBase extends Sprite
   {
      
      public function ScreenBase()
      {
         super();
         addChild(new MapBackground());
         addChild(new DarkLayer());
         addChild(new SoundIcon());
      }
   }
}

