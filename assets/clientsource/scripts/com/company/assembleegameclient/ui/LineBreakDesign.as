package com.company.assembleegameclient.ui
{
   import com.company.util.GraphicsUtil;
   import flash.display.GraphicsPath;
   import flash.display.GraphicsPathWinding;
   import flash.display.GraphicsSolidFill;
   import flash.display.IGraphicsData;
   import flash.display.Shape;
   
   public class LineBreakDesign extends Shape
   {
      
      private var designFill_:GraphicsSolidFill = new GraphicsSolidFill(16777215,1);
      
      private var designPath_:GraphicsPath = new GraphicsPath(new Vector.<int>(),new Vector.<Number>(),GraphicsPathWinding.NON_ZERO);
      
      private const designGraphicsData_:Vector.<IGraphicsData> = new <IGraphicsData>[this.designFill_,this.designPath_,GraphicsUtil.END_FILL];
      
      public function LineBreakDesign(param1:int, param2:uint)
      {
         super();
         this.setWidthColor(param1,param2);
      }
      
      public function setWidthColor(param1:int, param2:uint) : void
      {
         graphics.clear();
         this.designFill_.color = param2;
         GraphicsUtil.clearPath(this.designPath_);
         GraphicsUtil.drawDiamond(0,0,4,this.designPath_);
         GraphicsUtil.drawDiamond(param1,0,4,this.designPath_);
         GraphicsUtil.drawRect(0,-1,param1,2,this.designPath_);
         graphics.drawGraphicsData(this.designGraphicsData_);
      }
   }
}

