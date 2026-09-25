package kabam.rotmg.text.model
{
   import flash.text.Font;
   import flash.text.TextField;
   import flash.text.TextFormat;
   
   public class FontModel
   {
      
      public static const MyriadPro:Class = FontModel_MyriadPro;
      
      public static const MyriadPro_Bold:Class = FontModel_MyriadPro_Bold;
      
      private var fontInfo:FontInfo;
      
      public function FontModel()
      {
         super();
         Font.registerFont(MyriadPro);
         Font.registerFont(MyriadPro_Bold);
         var _loc1_:Font = new MyriadPro();
         this.fontInfo = new FontInfo();
         this.fontInfo.setName(_loc1_.fontName);
      }
      
      public function getFont() : FontInfo
      {
         return this.fontInfo;
      }
      
      public function apply(param1:TextField, param2:int, param3:uint, param4:Boolean, param5:Boolean = false) : TextFormat
      {
         var _loc6_:TextFormat = param1.defaultTextFormat;
         _loc6_.size = param2;
         _loc6_.color = param3;
         _loc6_.font = this.getFont().getName();
         _loc6_.bold = param4;
         if(param5)
         {
            _loc6_.align = "center";
         }
         param1.defaultTextFormat = _loc6_;
         param1.setTextFormat(_loc6_);
         return _loc6_;
      }
      
      public function getFormat(param1:TextField, param2:int, param3:uint, param4:Boolean) : TextFormat
      {
         var _loc5_:TextFormat = param1.defaultTextFormat;
         _loc5_.size = param2;
         _loc5_.color = param3;
         _loc5_.font = this.getFont().getName();
         _loc5_.bold = param4;
         return _loc5_;
      }
   }
}

