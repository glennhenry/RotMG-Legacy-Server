package kabam.rotmg.game.view.components
{
   import com.company.ui.BaseSimpleText;
   import com.company.util.AssetLibrary;
   import flash.display.Bitmap;
   import flash.display.Sprite;
   import flash.geom.ColorTransform;
   
   public class TabTextView extends TabView
   {
      
      private var background:Sprite;
      
      private var text:BaseSimpleText;
      
      private var badgeBG:Bitmap;
      
      private var badgeIcon:Bitmap;
      
      public function TabTextView(param1:int, param2:Sprite, param3:BaseSimpleText)
      {
         super(param1);
         this.initBackground(param2);
         if(param3)
         {
            this.initTabText(param3);
         }
      }
      
      public function setBadge(param1:int) : void
      {
         if(this.badgeIcon == null)
         {
            this.badgeIcon = new Bitmap();
            this.badgeIcon.bitmapData = AssetLibrary.getImageFromSet("lofiInterface",110);
            this.badgeIcon.x = this.x - 10;
            this.badgeIcon.y = 5;
            this.badgeIcon.scaleX = this.badgeIcon.scaleY = 1.5;
            addChild(this.badgeIcon);
            this.badgeBG = new Bitmap();
            this.badgeBG.bitmapData = AssetLibrary.getImageFromSet("lofiInterface",110);
            this.badgeBG.x = this.x - 12;
            this.badgeBG.y = 3;
            this.badgeBG.scaleX = this.badgeBG.scaleY = 2;
            addChild(this.badgeBG);
         }
         this.badgeIcon.visible = this.badgeBG.visible = param1 > 0;
      }
      
      private function initBackground(param1:Sprite) : void
      {
         this.background = param1;
         addChild(param1);
      }
      
      private function initTabText(param1:BaseSimpleText) : void
      {
         this.text = param1;
         param1.x = 5;
         addChild(param1);
      }
      
      override public function setSelected(param1:Boolean) : void
      {
         var _loc2_:ColorTransform = this.background.transform.colorTransform;
         _loc2_.color = param1 ? TabConstants.BACKGROUND_COLOR : TabConstants.TAB_COLOR;
         this.background.transform.colorTransform = _loc2_;
      }
   }
}

