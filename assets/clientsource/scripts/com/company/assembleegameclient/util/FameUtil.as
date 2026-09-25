package com.company.assembleegameclient.util
{
   import com.company.assembleegameclient.objects.ObjectLibrary;
   import com.company.rotmg.graphics.StarGraphic;
   import com.company.util.AssetLibrary;
   import flash.display.BitmapData;
   import flash.display.Sprite;
   import flash.filters.DropShadowFilter;
   import flash.geom.ColorTransform;
   
   public class FameUtil
   {
      
      public static const STARS:Vector.<int> = new <int>[20,150,400,800,2000];
      
      private static const lightBlueCT:ColorTransform = new ColorTransform(138 / 255,152 / 255,222 / 255);
      
      private static const darkBlueCT:ColorTransform = new ColorTransform(49 / 255,77 / 255,219 / 255);
      
      private static const redCT:ColorTransform = new ColorTransform(193 / 255,39 / 255,45 / 255);
      
      private static const orangeCT:ColorTransform = new ColorTransform(247 / 255,147 / 255,30 / 255);
      
      private static const yellowCT:ColorTransform = new ColorTransform(255 / 255,255 / 255,0 / 255);
      
      public static const COLORS:Vector.<ColorTransform> = new <ColorTransform>[lightBlueCT,darkBlueCT,redCT,orangeCT,yellowCT];
      
      public function FameUtil()
      {
         super();
      }
      
      public static function maxStars() : int
      {
         return ObjectLibrary.playerChars_.length * STARS.length;
      }
      
      public static function numStars(param1:int) : int
      {
         var _loc2_:int = 0;
         while(_loc2_ < STARS.length && param1 >= STARS[_loc2_])
         {
            _loc2_++;
         }
         return _loc2_;
      }
      
      public static function nextStarFame(param1:int, param2:int) : int
      {
         var _loc3_:int = Math.max(param1,param2);
         var _loc4_:int = 0;
         while(_loc4_ < STARS.length)
         {
            if(STARS[_loc4_] > _loc3_)
            {
               return STARS[_loc4_];
            }
            _loc4_++;
         }
         return -1;
      }
      
      public static function numAllTimeStars(param1:int, param2:int, param3:XML) : int
      {
         var _loc6_:XML = null;
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         for each(_loc6_ in param3.ClassStats)
         {
            if(param1 == int(_loc6_.@objectType))
            {
               _loc5_ = int(_loc6_.BestFame);
            }
            else
            {
               _loc4_ += FameUtil.numStars(_loc6_.BestFame);
            }
         }
         return int(_loc4_ + FameUtil.numStars(Math.max(_loc5_,param2)));
      }
      
      public static function numStarsToBigImage(param1:int) : Sprite
      {
         var _loc2_:Sprite = numStarsToImage(param1);
         _loc2_.filters = [new DropShadowFilter(0,0,0,1,4,4,2)];
         _loc2_.scaleX = 1.4;
         _loc2_.scaleY = 1.4;
         return _loc2_;
      }
      
      public static function numStarsToImage(param1:int) : Sprite
      {
         var _loc2_:Sprite = new StarGraphic();
         if(param1 < ObjectLibrary.playerChars_.length)
         {
            _loc2_.transform.colorTransform = lightBlueCT;
         }
         else if(param1 < ObjectLibrary.playerChars_.length * 2)
         {
            _loc2_.transform.colorTransform = darkBlueCT;
         }
         else if(param1 < ObjectLibrary.playerChars_.length * 3)
         {
            _loc2_.transform.colorTransform = redCT;
         }
         else if(param1 < ObjectLibrary.playerChars_.length * 4)
         {
            _loc2_.transform.colorTransform = orangeCT;
         }
         else if(param1 < ObjectLibrary.playerChars_.length * 5)
         {
            _loc2_.transform.colorTransform = yellowCT;
         }
         return _loc2_;
      }
      
      public static function numStarsToIcon(param1:int) : Sprite
      {
         var _loc2_:Sprite = null;
         var _loc3_:Sprite = null;
         _loc2_ = numStarsToImage(param1);
         _loc3_ = new Sprite();
         _loc3_.graphics.beginFill(0,0.4);
         var _loc4_:int = _loc2_.width / 2 + 2;
         var _loc5_:int = _loc2_.height / 2 + 2;
         _loc3_.graphics.drawCircle(_loc4_,_loc5_,_loc4_);
         _loc2_.x = 2;
         _loc2_.y = 1;
         _loc3_.addChild(_loc2_);
         _loc3_.filters = [new DropShadowFilter(0,0,0,0.5,6,6,1)];
         return _loc3_;
      }
      
      public static function getFameIcon() : BitmapData
      {
         var _loc1_:BitmapData = AssetLibrary.getImageFromSet("lofiObj3",224);
         return TextureRedrawer.redraw(_loc1_,40,true,0);
      }
   }
}

