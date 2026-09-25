package kabam.rotmg.game.model
{
   import com.company.assembleegameclient.objects.GameObject;
   
   public class AddSpeechBalloonVO
   {
      
      public var go:GameObject;
      
      public var text:String;
      
      public var name:String;
      
      public var isTrade:Boolean;
      
      public var isGuild:Boolean;
      
      public var background:uint;
      
      public var backgroundAlpha:Number;
      
      public var outline:uint;
      
      public var outlineAlpha:uint;
      
      public var textColor:uint;
      
      public var lifetime:int;
      
      public var bold:Boolean;
      
      public var hideable:Boolean;
      
      public function AddSpeechBalloonVO(param1:GameObject, param2:String, param3:String, param4:Boolean, param5:Boolean, param6:uint, param7:Number, param8:uint, param9:Number, param10:uint, param11:int, param12:Boolean, param13:Boolean)
      {
         super();
         this.go = param1;
         this.text = param2;
         this.name = param3;
         this.isTrade = param4;
         this.isGuild = param5;
         this.background = param6;
         this.backgroundAlpha = param7;
         this.outline = param8;
         this.outlineAlpha = param9;
         this.textColor = param10;
         this.lifetime = param11;
         this.bold = param12;
         this.hideable = param13;
      }
   }
}

