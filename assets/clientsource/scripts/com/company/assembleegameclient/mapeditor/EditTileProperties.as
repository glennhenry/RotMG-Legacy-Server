package com.company.assembleegameclient.mapeditor
{
   import com.company.util.IntPoint;
   import flash.display.Graphics;
   import flash.display.Shape;
   import flash.display.Sprite;
   import flash.events.Event;
   
   public class EditTileProperties extends Sprite
   {
      
      public var tiles_:Vector.<IntPoint>;
      
      private var darkBox_:Shape;
      
      private var frame_:EditTilePropertiesFrame;
      
      public function EditTileProperties(param1:Vector.<IntPoint>, param2:String)
      {
         super();
         this.tiles_ = param1;
         this.darkBox_ = new Shape();
         var _loc3_:Graphics = this.darkBox_.graphics;
         _loc3_.clear();
         _loc3_.beginFill(0,0.8);
         _loc3_.drawRect(0,0,800,600);
         _loc3_.endFill();
         addChild(this.darkBox_);
         this.frame_ = new EditTilePropertiesFrame(param2);
         this.frame_.addEventListener(Event.COMPLETE,this.onComplete);
         this.frame_.addEventListener(Event.CANCEL,this.onCancel);
         addChild(this.frame_);
      }
      
      public function getObjectName() : String
      {
         if(this.frame_.objectName_.text() == "")
         {
            return null;
         }
         return this.frame_.objectName_.text();
      }
      
      public function onComplete(param1:Event) : void
      {
         dispatchEvent(new Event(Event.COMPLETE));
         parent.removeChild(this);
      }
      
      public function onCancel(param1:Event) : void
      {
         parent.removeChild(this);
      }
   }
}

