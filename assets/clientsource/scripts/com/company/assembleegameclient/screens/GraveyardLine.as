package com.company.assembleegameclient.screens
{
   import com.company.ui.BaseSimpleText;
   import flash.display.Bitmap;
   import flash.display.BitmapData;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   import flash.filters.DropShadowFilter;
   import flash.net.URLRequest;
   import flash.net.navigateToURL;
   import org.osflash.signals.Signal;
   
   public class GraveyardLine extends Sprite
   {
      
      public static const WIDTH:int = 415;
      
      public static const HEIGHT:int = 52;
      
      public static const COLOR:uint = 11776947;
      
      public static const OVER_COLOR:uint = 16762880;
      
      public var viewCharacterFame:Signal = new Signal(int);
      
      public var icon_:Bitmap;
      
      public var titleText_:BaseSimpleText;
      
      public var taglineText_:BaseSimpleText;
      
      public var dtText_:BaseSimpleText;
      
      public var link:String;
      
      public var accountId:String;
      
      public function GraveyardLine(param1:BitmapData, param2:String, param3:String, param4:String, param5:int, param6:String)
      {
         super();
         this.link = param4;
         this.accountId = param6;
         buttonMode = true;
         useHandCursor = true;
         tabEnabled = false;
         this.icon_ = new Bitmap();
         this.icon_.bitmapData = param1;
         this.icon_.x = 12;
         this.icon_.y = HEIGHT / 2 - param1.height / 2 - 3;
         addChild(this.icon_);
         this.titleText_ = new BaseSimpleText(18,COLOR,false,0,0);
         this.titleText_.text = param2;
         this.titleText_.updateMetrics();
         this.titleText_.filters = [new DropShadowFilter(0,0,0,1,8,8)];
         this.titleText_.x = 73;
         addChild(this.titleText_);
         this.taglineText_ = new BaseSimpleText(14,COLOR,false,0,0);
         this.taglineText_.text = param3;
         this.taglineText_.updateMetrics();
         this.taglineText_.filters = [new DropShadowFilter(0,0,0,1,8,8)];
         this.taglineText_.x = 73;
         this.taglineText_.y = 24;
         addChild(this.taglineText_);
         this.dtText_ = new BaseSimpleText(16,COLOR,false,0,0);
         this.dtText_.text = this.getTimeDiff(param5);
         this.dtText_.updateMetrics();
         this.dtText_.filters = [new DropShadowFilter(0,0,0,1,8,8)];
         this.dtText_.x = WIDTH - this.dtText_.width;
         addChild(this.dtText_);
         addEventListener(MouseEvent.MOUSE_OVER,this.onMouseOver);
         addEventListener(MouseEvent.ROLL_OUT,this.onRollOut);
         addEventListener(MouseEvent.MOUSE_DOWN,this.onMouseDown);
      }
      
      protected function onMouseOver(param1:MouseEvent) : void
      {
         this.titleText_.setColor(OVER_COLOR);
         this.taglineText_.setColor(OVER_COLOR);
         this.dtText_.setColor(OVER_COLOR);
      }
      
      protected function onRollOut(param1:MouseEvent) : void
      {
         this.titleText_.setColor(COLOR);
         this.taglineText_.setColor(COLOR);
         this.dtText_.setColor(COLOR);
      }
      
      protected function onMouseDown(param1:MouseEvent) : void
      {
         var _loc2_:Array = this.link.split(":",2);
         switch(_loc2_[0])
         {
            case "fame":
               this.viewCharacterFame.dispatch(int(_loc2_[1]));
               break;
            case "http":
            case "https":
            default:
               navigateToURL(new URLRequest(this.link),"_blank");
         }
      }
      
      private function getTimeDiff(param1:int) : String
      {
         var _loc2_:Number = new Date().getTime() / 1000;
         var _loc3_:int = _loc2_ - param1;
         if(_loc3_ <= 0)
         {
            return "now";
         }
         if(_loc3_ < 60)
         {
            return _loc3_ + " secs";
         }
         if(_loc3_ < 60 * 60)
         {
            return int(_loc3_ / 60) + " mins";
         }
         if(_loc3_ < 60 * 60 * 24)
         {
            return int(_loc3_ / (60 * 60)) + " hours";
         }
         return int(_loc3_ / (60 * 60 * 24)) + " days";
      }
   }
}

