package com.company.assembleegameclient.ui
{
   import com.company.util.GraphicsUtil;
   import flash.display.GraphicsPath;
   import flash.display.GraphicsSolidFill;
   import flash.display.IGraphicsData;
   import flash.display.Sprite;
   import flash.text.TextFieldAutoSize;
   import kabam.rotmg.text.view.TextFieldDisplayConcrete;
   
   public class BackgroundFilledText extends Sprite
   {
      
      protected static const MARGIN:int = 4;
      
      public var bWidth:int = 0;
      
      protected var text_:TextFieldDisplayConcrete;
      
      protected var w_:int;
      
      protected var enabledFill_:GraphicsSolidFill = new GraphicsSolidFill(16777215,1);
      
      protected var disabledFill_:GraphicsSolidFill = new GraphicsSolidFill(8355711,1);
      
      protected var path_:GraphicsPath = new GraphicsPath(new Vector.<int>(),new Vector.<Number>());
      
      protected const graphicsData_:Vector.<IGraphicsData> = new <IGraphicsData>[this.enabledFill_,this.path_,GraphicsUtil.END_FILL];
      
      public function BackgroundFilledText(param1:int)
      {
         super();
         this.bWidth = param1;
      }
      
      protected function centerTextAndDrawButton() : void
      {
         this.w_ = this.bWidth != 0 ? this.bWidth : int(this.text_.width + 12);
         this.text_.x = this.w_ / 2;
         GraphicsUtil.clearPath(this.path_);
         GraphicsUtil.drawCutEdgeRect(0,0,this.w_,this.text_.height + MARGIN * 2,4,[1,1,1,1],this.path_);
      }
      
      public function addText(param1:int) : void
      {
         this.text_ = this.makeText().setSize(param1).setColor(3552822);
         this.text_.setBold(true);
         this.text_.setAutoSize(TextFieldAutoSize.CENTER);
         this.text_.y = MARGIN;
         addChild(this.text_);
      }
      
      protected function makeText() : TextFieldDisplayConcrete
      {
         return new TextFieldDisplayConcrete();
      }
   }
}

