package com.company.assembleegameclient.objects
{
   import com.company.assembleegameclient.game.GameSprite;
   import com.company.assembleegameclient.map.Camera;
   import com.company.assembleegameclient.ui.panels.Panel;
   import com.company.assembleegameclient.ui.panels.PortalPanel;
   import flash.display.BitmapData;
   import flash.display.IGraphicsData;
   import kabam.rotmg.core.StaticInjectorContext;
   import kabam.rotmg.text.view.BitmapTextFactory;
   import kabam.rotmg.text.view.stringBuilder.StringBuilder;
   
   public class Portal extends GameObject implements IInteractiveObject
   {
      
      private static const NAME_PARSER:RegExp = /(^\s+)\s\(([0-9]+)\/[0-9]+\)/;
      
      public var nexusPortal_:Boolean;
      
      public var lockedPortal_:Boolean;
      
      public var active_:Boolean = true;
      
      public function Portal(param1:XML)
      {
         super(param1);
         isInteractive_ = true;
         this.nexusPortal_ = param1.hasOwnProperty("NexusPortal");
         this.lockedPortal_ = param1.hasOwnProperty("LockedPortal");
      }
      
      override protected function makeNameBitmapData() : BitmapData
      {
         var _loc1_:Array = name_.match(NAME_PARSER);
         var _loc2_:StringBuilder = new PortalNameParser().makeBuilder(name_);
         var _loc3_:BitmapTextFactory = StaticInjectorContext.getInjector().getInstance(BitmapTextFactory);
         return _loc3_.make(_loc2_,16,16777215,true,IDENTITY_MATRIX,true);
      }
      
      override public function draw(param1:Vector.<IGraphicsData>, param2:Camera, param3:int) : void
      {
         super.draw(param1,param2,param3);
         if(this.nexusPortal_)
         {
            drawName(param1,param2);
         }
      }
      
      public function getPanel(param1:GameSprite) : Panel
      {
         return new PortalPanel(param1,this);
      }
   }
}

