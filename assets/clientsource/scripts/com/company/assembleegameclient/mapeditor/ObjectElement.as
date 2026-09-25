package com.company.assembleegameclient.mapeditor
{
   import com.company.assembleegameclient.objects.ObjectLibrary;
   import com.company.assembleegameclient.ui.tooltip.ToolTip;
   import flash.display.Bitmap;
   import flash.display.BitmapData;
   
   internal class ObjectElement extends Element
   {
      
      public var objXML_:XML;
      
      public function ObjectElement(param1:XML)
      {
         var _loc3_:Bitmap = null;
         super(int(param1.@type));
         this.objXML_ = param1;
         var _loc2_:BitmapData = ObjectLibrary.getRedrawnTextureFromType(type_,100,true,false);
         _loc3_ = new Bitmap(_loc2_);
         var _loc4_:Number = (WIDTH - 4) / Math.max(_loc3_.width,_loc3_.height);
         _loc3_.scaleX = _loc3_.scaleY = _loc4_;
         _loc3_.x = WIDTH / 2 - _loc3_.width / 2;
         _loc3_.y = HEIGHT / 2 - _loc3_.height / 2;
         addChild(_loc3_);
      }
      
      override protected function getToolTip() : ToolTip
      {
         return new ObjectTypeToolTip(this.objXML_);
      }
   }
}

