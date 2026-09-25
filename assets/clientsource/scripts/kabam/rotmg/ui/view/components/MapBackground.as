package kabam.rotmg.ui.view.components
{
   import com.company.assembleegameclient.background.Background;
   import com.company.assembleegameclient.map.Camera;
   import com.company.assembleegameclient.map.Map;
   import com.company.assembleegameclient.map.serialization.MapDecoder;
   import com.company.util.IntPoint;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.geom.Rectangle;
   import flash.utils.ByteArray;
   import flash.utils.getTimer;
   
   public class MapBackground extends Sprite
   {
      
      private static var backgroundMap:Map;
      
      private static var mapSize:IntPoint;
      
      private static var xVal:Number;
      
      private static var yVal:Number;
      
      private static var camera:Camera;
      
      private static const BORDER:int = 10;
      
      private static const RECTANGLE:Rectangle = new Rectangle(-400,-300,800,600);
      
      private static const ANGLE:Number = 7 * Math.PI / 4;
      
      private static const TO_MILLISECONDS:Number = 1 / 1000;
      
      private static const EMBEDDED_BACKGROUNDMAP:Class = MapBackground_EMBEDDED_BACKGROUNDMAP;
      
      private var lastUpdate:int;
      
      private var time:Number;
      
      public function MapBackground()
      {
         super();
         addEventListener(Event.ADDED_TO_STAGE,this.onAddedToStage);
         addEventListener(Event.REMOVED_FROM_STAGE,this.onRemovedFromStage);
      }
      
      private function onAddedToStage(param1:Event) : void
      {
         addChildAt(backgroundMap = backgroundMap || this.makeMap(),0);
         addEventListener(Event.ENTER_FRAME,this.onEnterFrame);
         this.lastUpdate = getTimer();
      }
      
      private function onRemovedFromStage(param1:Event) : void
      {
         removeEventListener(Event.ENTER_FRAME,this.onEnterFrame);
      }
      
      private function onEnterFrame(param1:Event) : void
      {
         this.time = getTimer();
         xVal += (this.time - this.lastUpdate) * TO_MILLISECONDS;
         if(xVal > mapSize.x_ + BORDER)
         {
            xVal -= mapSize.x_;
         }
         camera.configure(xVal,yVal,12,ANGLE,RECTANGLE);
         backgroundMap.draw(camera,this.time);
         this.lastUpdate = this.time;
      }
      
      private function makeMap() : Map
      {
         var _loc1_:ByteArray = new EMBEDDED_BACKGROUNDMAP();
         var _loc2_:String = _loc1_.readUTFBytes(_loc1_.length);
         mapSize = MapDecoder.getSize(_loc2_);
         xVal = BORDER;
         yVal = BORDER + int((mapSize.y_ - 2 * BORDER) * Math.random());
         camera = new Camera();
         var _loc3_:Map = new Map(null);
         _loc3_.setProps(mapSize.x_ + 2 * BORDER,mapSize.y_,"Background Map",Background.NO_BACKGROUND,false,false);
         _loc3_.initialize();
         MapDecoder.writeMap(_loc2_,_loc3_,0,0);
         MapDecoder.writeMap(_loc2_,_loc3_,mapSize.x_,0);
         return _loc3_;
      }
   }
}

