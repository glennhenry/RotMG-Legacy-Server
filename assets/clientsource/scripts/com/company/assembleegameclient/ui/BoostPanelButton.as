package com.company.assembleegameclient.ui
{
   import com.company.assembleegameclient.objects.Player;
   import com.company.assembleegameclient.util.TextureRedrawer;
   import com.company.util.AssetLibrary;
   import flash.display.Bitmap;
   import flash.display.BitmapData;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.MouseEvent;
   
   public class BoostPanelButton extends Sprite
   {
      
      public static const IMAGE_SET_NAME:String = "lofiInterfaceBig";
      
      public static const IMAGE_ID:int = 22;
      
      private var boostPanel:BoostPanel;
      
      private var player:Player;
      
      public function BoostPanelButton(param1:Player)
      {
         var _loc4_:Bitmap = null;
         super();
         this.player = param1;
         var _loc2_:BitmapData = AssetLibrary.getImageFromSet(IMAGE_SET_NAME,IMAGE_ID);
         var _loc3_:BitmapData = TextureRedrawer.redraw(_loc2_,20,true,0);
         _loc4_ = new Bitmap(_loc3_);
         _loc4_.x = -7;
         _loc4_.y = -10;
         addChild(_loc4_);
         addEventListener(MouseEvent.MOUSE_OVER,this.onButtonOver);
         addEventListener(MouseEvent.MOUSE_OUT,this.onButtonOut);
      }
      
      private function onButtonOver(param1:Event) : void
      {
         addChild(this.boostPanel = new BoostPanel(this.player));
         this.boostPanel.resized.add(this.positionBoostPanel);
         this.positionBoostPanel();
      }
      
      private function positionBoostPanel() : void
      {
         this.boostPanel.x = -this.boostPanel.width;
         this.boostPanel.y = -this.boostPanel.height;
      }
      
      private function onButtonOut(param1:Event) : void
      {
         if(this.boostPanel)
         {
            removeChild(this.boostPanel);
         }
      }
   }
}

