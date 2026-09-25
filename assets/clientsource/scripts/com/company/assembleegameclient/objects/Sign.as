package com.company.assembleegameclient.objects
{
   import com.company.assembleegameclient.map.Camera;
   import com.company.assembleegameclient.util.TextureRedrawer;
   import flash.display.BitmapData;
   import flash.text.TextField;
   import flash.text.TextFieldAutoSize;
   import flash.text.TextFormat;
   import flash.text.TextFormatAlign;
   import kabam.rotmg.core.StaticInjectorContext;
   import kabam.rotmg.language.model.StringMap;
   import kabam.rotmg.text.model.FontModel;
   
   public class Sign extends GameObject
   {
      
      private var stringMap:StringMap;
      
      private var fontModel:FontModel;
      
      public function Sign(param1:XML)
      {
         super(param1);
         texture_ = null;
         this.stringMap = StaticInjectorContext.getInjector().getInstance(StringMap);
         this.fontModel = StaticInjectorContext.getInjector().getInstance(FontModel);
      }
      
      override protected function getTexture(param1:Camera, param2:int) : BitmapData
      {
         if(texture_ != null)
         {
            return texture_;
         }
         var _loc3_:TextField = new TextField();
         _loc3_.multiline = true;
         _loc3_.wordWrap = false;
         _loc3_.autoSize = TextFieldAutoSize.LEFT;
         _loc3_.textColor = 16777215;
         _loc3_.embedFonts = true;
         var _loc4_:TextFormat = new TextFormat();
         _loc4_.align = TextFormatAlign.CENTER;
         _loc4_.font = this.fontModel.getFont().getName();
         _loc4_.size = 24;
         _loc4_.color = 16777215;
         _loc4_.bold = true;
         _loc3_.defaultTextFormat = _loc4_;
         var _loc5_:String = this.stringMap.getValue(this.stripCurlyBrackets(name_));
         _loc3_.text = _loc5_.split("|").join("\n");
         var _loc6_:BitmapData = new BitmapDataSpy(_loc3_.width,_loc3_.height,true,0);
         _loc6_.draw(_loc3_);
         texture_ = TextureRedrawer.redraw(_loc6_,size_,false,0);
         return texture_;
      }
      
      private function stripCurlyBrackets(param1:String) : String
      {
         var _loc2_:Boolean = param1 != null && param1.charAt(0) == "{" && param1.charAt(param1.length - 1) == "}";
         return _loc2_ ? param1.substr(1,param1.length - 2) : param1;
      }
   }
}

