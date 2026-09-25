package com.company.assembleegameclient.objects
{
   import com.company.assembleegameclient.game.GameSprite;
   import com.company.assembleegameclient.map.Camera;
   import com.company.assembleegameclient.ui.panels.ArenaPortalPanel;
   import com.company.assembleegameclient.ui.panels.Panel;
   import flash.display.BitmapData;
   import flash.display.IGraphicsData;
   import kabam.rotmg.core.StaticInjectorContext;
   import kabam.rotmg.text.view.BitmapTextFactory;
   import kabam.rotmg.text.view.stringBuilder.StaticStringBuilder;
   import kabam.rotmg.text.view.stringBuilder.StringBuilder;
   
   public class ArenaPortal extends Portal implements IInteractiveObject
   {
      
      public function ArenaPortal(param1:XML)
      {
         super(param1);
         isInteractive_ = true;
         name_ = "";
      }
      
      override public function getPanel(param1:GameSprite) : Panel
      {
         return new ArenaPortalPanel(param1,this);
      }
      
      override public function draw(param1:Vector.<IGraphicsData>, param2:Camera, param3:int) : void
      {
         super.draw(param1,param2,param3);
         drawName(param1,param2);
      }
      
      override protected function makeNameBitmapData() : BitmapData
      {
         var _loc1_:StringBuilder = new StaticStringBuilder(name_);
         var _loc2_:BitmapTextFactory = StaticInjectorContext.getInjector().getInstance(BitmapTextFactory);
         return _loc2_.make(_loc1_,16,16777215,true,IDENTITY_MATRIX,true);
      }
   }
}

