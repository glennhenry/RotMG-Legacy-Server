package com.company.assembleegameclient.map.mapoverlay
{
   import com.company.assembleegameclient.map.Camera;
   import flash.display.Sprite;
   import kabam.rotmg.game.view.components.QueuedStatusText;
   import kabam.rotmg.game.view.components.QueuedStatusTextList;
   
   public class MapOverlay extends Sprite
   {
      
      private const speechBalloons:Object = {};
      
      private const queuedText:Object = {};
      
      public function MapOverlay()
      {
         super();
         mouseEnabled = true;
         mouseChildren = true;
      }
      
      public function addSpeechBalloon(param1:SpeechBalloon) : void
      {
         var _loc2_:int = param1.go_.objectId_;
         var _loc3_:SpeechBalloon = this.speechBalloons[_loc2_];
         if(Boolean(_loc3_) && contains(_loc3_))
         {
            removeChild(_loc3_);
         }
         this.speechBalloons[_loc2_] = param1;
         addChild(param1);
      }
      
      public function addStatusText(param1:CharacterStatusText) : void
      {
         addChild(param1);
      }
      
      public function addQueuedText(param1:QueuedStatusText) : void
      {
         var _loc2_:int = param1.go_.objectId_;
         var _loc3_:QueuedStatusTextList = this.queuedText[_loc2_] = this.queuedText[_loc2_] || this.makeQueuedStatusTextList();
         _loc3_.append(param1);
      }
      
      private function makeQueuedStatusTextList() : QueuedStatusTextList
      {
         var _loc1_:QueuedStatusTextList = new QueuedStatusTextList();
         _loc1_.target = this;
         return _loc1_;
      }
      
      public function draw(param1:Camera, param2:int) : void
      {
         var _loc4_:IMapOverlayElement = null;
         var _loc3_:int = 0;
         while(_loc3_ < numChildren)
         {
            _loc4_ = getChildAt(_loc3_) as IMapOverlayElement;
            if(!_loc4_ || _loc4_.draw(param1,param2))
            {
               _loc3_++;
            }
            else
            {
               _loc4_.dispose();
            }
         }
      }
   }
}

