package com.company.assembleegameclient.map
{
   import com.company.assembleegameclient.objects.BasicObject;
   import com.company.assembleegameclient.objects.GameObject;
   import com.company.assembleegameclient.objects.particles.ConfettiEffect;
   import com.company.assembleegameclient.objects.particles.LightningEffect;
   import com.company.assembleegameclient.objects.particles.NovaEffect;
   import flash.display.IGraphicsData;
   import flash.events.Event;
   import flash.utils.Dictionary;
   import flash.utils.getTimer;
   import kabam.rotmg.messaging.impl.data.WorldPosData;
   
   public class ParticleModalMap extends Map
   {
      
      public static const MODE_SNOW:int = 1;
      
      public static const MODE_AUTO_UPDATE:int = 2;
      
      public static const PSCALE:Number = 16;
      
      private var inUpdate_:Boolean = false;
      
      private var objsToAdd_:Vector.<BasicObject> = new Vector.<BasicObject>();
      
      private var idsToRemove_:Vector.<int> = new Vector.<int>();
      
      private var dt:uint = 0;
      
      private var dtBuildup:uint = 0;
      
      private var time:uint = 0;
      
      private var graphicsData_:Vector.<IGraphicsData> = new Vector.<IGraphicsData>();
      
      public function ParticleModalMap(param1:int = -1)
      {
         super(null);
         if(param1 == MODE_SNOW)
         {
            addEventListener(Event.ENTER_FRAME,this.activateModeSnow);
         }
         if(param1 == MODE_AUTO_UPDATE)
         {
            addEventListener(Event.ENTER_FRAME,this.updater);
         }
      }
      
      public static function getLocalPos(param1:Number) : Number
      {
         return param1 / PSCALE;
      }
      
      override public function addObj(param1:BasicObject, param2:Number, param3:Number) : void
      {
         param1.x_ = param2;
         param1.y_ = param3;
         if(this.inUpdate_)
         {
            this.objsToAdd_.push(param1);
         }
         else
         {
            this.internalAddObj(param1);
         }
      }
      
      override public function internalAddObj(param1:BasicObject) : void
      {
         var _loc2_:Dictionary = boDict_;
         if(_loc2_[param1.objectId_] != null)
         {
            return;
         }
         param1.map_ = this;
         _loc2_[param1.objectId_] = param1;
      }
      
      override public function internalRemoveObj(param1:int) : void
      {
         var _loc2_:Dictionary = boDict_;
         var _loc3_:BasicObject = _loc2_[param1];
         if(_loc3_ == null)
         {
            return;
         }
         _loc3_.removeFromMap();
         delete _loc2_[param1];
      }
      
      override public function update(param1:int, param2:int) : void
      {
         var _loc3_:BasicObject = null;
         var _loc4_:int = 0;
         this.inUpdate_ = true;
         for each(_loc3_ in boDict_)
         {
            if(!_loc3_.update(param1,param2))
            {
               this.idsToRemove_.push(_loc3_.objectId_);
            }
         }
         this.inUpdate_ = false;
         for each(_loc3_ in this.objsToAdd_)
         {
            this.internalAddObj(_loc3_);
         }
         this.objsToAdd_.length = 0;
         for each(_loc4_ in this.idsToRemove_)
         {
            this.internalRemoveObj(_loc4_);
         }
         this.idsToRemove_.length = 0;
      }
      
      override public function draw(param1:Camera, param2:int) : void
      {
         var _loc3_:BasicObject = null;
         this.graphicsData_.length = 0;
         var _loc4_:int = 0;
         for each(_loc3_ in boDict_)
         {
            _loc4_++;
            _loc3_.computeSortValNoCamera(PSCALE);
            _loc3_.draw(this.graphicsData_,param1,param2);
         }
         graphics.clear();
         if(this.graphicsData_.length > 0)
         {
            graphics.drawGraphicsData(this.graphicsData_);
         }
      }
      
      private function activateModeSnow(param1:Event) : void
      {
         if(this.time != 0)
         {
            this.dt = getTimer() - this.time;
         }
         this.dtBuildup += this.dt;
         this.time = getTimer();
         if(this.dtBuildup > 500)
         {
            this.dtBuildup = 0;
            this.doSnow(Math.random() * 600,-100);
         }
         this.update(this.time,this.dt);
         this.draw(null,this.time);
      }
      
      private function updater(param1:Event) : void
      {
         if(this.time != 0)
         {
            this.dt = getTimer() - this.time;
         }
         this.time = getTimer();
         this.update(this.time,this.dt);
         this.draw(null,this.time);
      }
      
      public function doNova(param1:Number, param2:Number, param3:int = 20, param4:int = 12447231) : void
      {
         var _loc5_:GameObject = new GameObject(null);
         _loc5_.x_ = getLocalPos(param1);
         _loc5_.y_ = getLocalPos(param2);
         var _loc6_:NovaEffect = new NovaEffect(_loc5_,param3,param4);
         this.addObj(_loc6_,_loc5_.x_,_loc5_.y_);
      }
      
      private function doSnow(param1:Number, param2:Number, param3:int = 20, param4:int = 12447231) : void
      {
         var _loc5_:WorldPosData = new WorldPosData();
         var _loc6_:WorldPosData = new WorldPosData();
         _loc5_.x_ = getLocalPos(param1);
         _loc5_.y_ = getLocalPos(param2);
         _loc6_.x_ = getLocalPos(param1);
         _loc6_.y_ = getLocalPos(600);
         var _loc7_:ConfettiEffect = new ConfettiEffect(_loc5_,_loc6_,param4,param3,true);
         this.addObj(_loc7_,_loc5_.x_,_loc5_.y_);
      }
      
      public function doLightning(param1:Number, param2:Number, param3:Number, param4:Number, param5:int = 200, param6:int = 12447231, param7:Number = 1) : void
      {
         var _loc8_:GameObject = new GameObject(null);
         _loc8_.x_ = getLocalPos(param1);
         _loc8_.y_ = getLocalPos(param2);
         var _loc9_:WorldPosData = new WorldPosData();
         _loc9_.x_ = getLocalPos(param3);
         _loc9_.y_ = getLocalPos(param4);
         var _loc10_:LightningEffect = new LightningEffect(_loc8_,_loc9_,param6,param5,param7);
         this.addObj(_loc10_,_loc8_.x_,_loc8_.y_);
      }
   }
}

