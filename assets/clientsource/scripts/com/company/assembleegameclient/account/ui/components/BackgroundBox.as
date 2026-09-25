package com.company.assembleegameclient.account.ui.components
{
   import flash.display.Shape;
   
   public class BackgroundBox extends Shape
   {
      
      private var _width:int;
      
      private var _height:int;
      
      private var _color:int;
      
      public function BackgroundBox()
      {
         super();
      }
      
      public function setSize(param1:int, param2:int) : void
      {
         this._width = param1;
         this._height = param2;
         this.drawFill();
      }
      
      public function setColor(param1:int) : void
      {
         this._color = param1;
         this.drawFill();
      }
      
      private function drawFill() : void
      {
         graphics.clear();
         graphics.beginFill(this._color);
         graphics.drawRect(0,0,this._width,this._height);
         graphics.endFill();
      }
   }
}

