package com.company.assembleegameclient.appengine
{
   import com.company.assembleegameclient.util.TextureRedrawer;
   import com.company.util.AssetLibrary;
   import flash.display.BitmapData;
   
   public class SavedNewsItem
   {
      
      private static const FAME:String = "fame";
      
      private var iconName:String;
      
      public var title_:String;
      
      public var tagline_:String;
      
      public var link_:String;
      
      public var date_:int;
      
      public function SavedNewsItem(param1:String, param2:String, param3:String, param4:String, param5:int)
      {
         super();
         this.iconName = param1;
         this.title_ = param2;
         this.tagline_ = param3;
         this.link_ = param4;
         this.date_ = param5;
      }
      
      private static function forumIcon() : BitmapData
      {
         var _loc1_:BitmapData = AssetLibrary.getImageFromSet("lofiInterface2",4);
         return TextureRedrawer.redraw(_loc1_,80,true,0);
      }
      
      private static function fameIcon() : BitmapData
      {
         var _loc1_:BitmapData = AssetLibrary.getImageFromSet("lofiObj3",224);
         return TextureRedrawer.redraw(_loc1_,80,true,0);
      }
      
      public function getIcon() : BitmapData
      {
         return this.iconName == FAME ? fameIcon() : forumIcon();
      }
      
      public function isCharDeath() : Boolean
      {
         return this.iconName == FAME;
      }
   }
}

