package com.company.assembleegameclient.mapeditor
{
   import com.company.assembleegameclient.map.RegionLibrary;
   import com.company.assembleegameclient.ui.tooltip.ToolTip;
   import flash.display.Shape;
   
   public class RegionElement extends Element
   {
      
      public var regionXML_:XML;
      
      public function RegionElement(param1:XML)
      {
         super(int(param1.@type));
         this.regionXML_ = param1;
         var _loc2_:Shape = new Shape();
         _loc2_.graphics.beginFill(RegionLibrary.getColor(type_),0.5);
         _loc2_.graphics.drawRect(0,0,WIDTH - 8,HEIGHT - 8);
         _loc2_.graphics.endFill();
         _loc2_.x = WIDTH / 2 - _loc2_.width / 2;
         _loc2_.y = HEIGHT / 2 - _loc2_.height / 2;
         addChild(_loc2_);
      }
      
      override protected function getToolTip() : ToolTip
      {
         return new RegionTypeToolTip(this.regionXML_);
      }
   }
}

