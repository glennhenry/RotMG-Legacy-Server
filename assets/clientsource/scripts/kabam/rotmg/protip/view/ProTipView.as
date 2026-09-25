package kabam.rotmg.protip.view
{
   import com.gskinner.motion.GTween;
   import flash.display.Sprite;
   import flash.filters.GlowFilter;
   
   public class ProTipView extends Sprite
   {
      
      private var text:ProTipText;
      
      public function ProTipView()
      {
         super();
         this.text = new ProTipText();
         this.text.x = 300;
         this.text.y = 125;
         addChild(this.text);
         filters = [new GlowFilter(0,1,3,3,2,1)];
         mouseEnabled = false;
         mouseChildren = false;
      }
      
      public function setTip(param1:String) : void
      {
         this.text.setTip(param1);
         var _loc2_:GTween = new GTween(this,5,{"alpha":0});
         _loc2_.delay = 5;
         _loc2_.onComplete = this.removeSelf;
      }
      
      private function removeSelf(param1:GTween) : void
      {
         parent && parent.removeChild(this);
      }
   }
}

