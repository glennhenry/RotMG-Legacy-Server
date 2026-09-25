package com.company.assembleegameclient.objects
{
   import com.company.assembleegameclient.constants.InventoryOwnerTypes;
   import com.company.assembleegameclient.map.Camera;
   import com.company.assembleegameclient.map.Map;
   import com.company.assembleegameclient.ui.tooltip.EquipmentToolTip;
   import com.company.assembleegameclient.ui.tooltip.ToolTip;
   import com.company.ui.BaseSimpleText;
   import com.company.util.IntPoint;
   import com.gskinner.motion.GTween;
   import com.gskinner.motion.easing.Sine;
   import flash.display.BitmapData;
   import flash.geom.ColorTransform;
   import flash.geom.Matrix;
   import kabam.rotmg.core.StaticInjectorContext;
   import kabam.rotmg.game.model.AddSpeechBalloonVO;
   import kabam.rotmg.game.signals.AddSpeechBalloonSignal;
   import kabam.rotmg.language.model.StringMap;
   import kabam.rotmg.text.view.stringBuilder.LineBuilder;
   
   public class Merchant extends SellableObject implements IInteractiveObject
   {
      
      private static const NONE_MESSAGE:int = 0;
      
      private static const NEW_MESSAGE:int = 1;
      
      private static const MINS_LEFT_MESSAGE:int = 2;
      
      private static const ITEMS_LEFT_MESSAGE:int = 3;
      
      private static const DISCOUNT_MESSAGE:int = 4;
      
      private static const T:Number = 1;
      
      private static const DOSE_MATRIX:Matrix = (function():Matrix
      {
         var _loc1_:* = new Matrix();
         _loc1_.translate(10,5);
         return _loc1_;
      })();
      
      public var merchandiseType_:int = -1;
      
      public var count_:int = -1;
      
      public var minsLeft_:int = -1;
      
      public var discount_:int = 0;
      
      public var merchandiseTexture_:BitmapData = null;
      
      public var untilNextMessage_:int = 0;
      
      public var alpha_:Number = 1;
      
      private var addSpeechBalloon:AddSpeechBalloonSignal = StaticInjectorContext.getInjector().getInstance(AddSpeechBalloonSignal);
      
      private var stringMap:StringMap = StaticInjectorContext.getInjector().getInstance(StringMap);
      
      private var firstUpdate_:Boolean = true;
      
      private var messageIndex_:int = 0;
      
      private var ct_:ColorTransform = new ColorTransform(1,1,1,1);
      
      public function Merchant(param1:XML)
      {
         super(param1);
         isInteractive_ = true;
      }
      
      override public function setPrice(param1:int) : void
      {
         super.setPrice(param1);
         this.untilNextMessage_ = 0;
      }
      
      override public function setRankReq(param1:int) : void
      {
         super.setRankReq(param1);
         this.untilNextMessage_ = 0;
      }
      
      override public function addTo(param1:Map, param2:Number, param3:Number) : Boolean
      {
         if(!super.addTo(param1,param2,param3))
         {
            return false;
         }
         param1.merchLookup_[new IntPoint(x_,y_)] = this;
         return true;
      }
      
      override public function removeFromMap() : void
      {
         var _loc1_:IntPoint = new IntPoint(x_,y_);
         if(map_.merchLookup_[_loc1_] == this)
         {
            map_.merchLookup_[_loc1_] = null;
         }
         super.removeFromMap();
      }
      
      public function getSpeechBalloon(param1:int) : AddSpeechBalloonVO
      {
         var _loc2_:LineBuilder = null;
         var _loc3_:uint = 0;
         var _loc4_:uint = 0;
         var _loc5_:uint = 0;
         switch(param1)
         {
            case NEW_MESSAGE:
               _loc2_ = new LineBuilder().setParams("Merchant.new");
               _loc3_ = 15132390;
               _loc4_ = 16777215;
               _loc5_ = 5931045;
               break;
            case MINS_LEFT_MESSAGE:
               if(this.minsLeft_ == 0)
               {
                  _loc2_ = new LineBuilder().setParams("Merchant.goingSoon");
               }
               else if(this.minsLeft_ == 1)
               {
                  _loc2_ = new LineBuilder().setParams("Merchant.goingInOneMinute");
               }
               else
               {
                  _loc2_ = new LineBuilder().setParams("Merchant.goingInNMinutes",{"minutes":this.minsLeft_});
               }
               _loc3_ = 5973542;
               _loc4_ = 16549442;
               _loc5_ = 16549442;
               break;
            case ITEMS_LEFT_MESSAGE:
               _loc2_ = new LineBuilder().setParams("Merchant.limitedStock",{"count":this.count_});
               _loc3_ = 5973542;
               _loc4_ = 16549442;
               _loc5_ = 16549442;
               break;
            case DISCOUNT_MESSAGE:
               _loc2_ = new LineBuilder().setParams("Merchant.discount",{"discount":this.discount_});
               _loc3_ = 6324275;
               _loc4_ = 16777103;
               _loc5_ = 16777103;
               break;
            default:
               return null;
         }
         _loc2_.setStringMap(this.stringMap);
         return new AddSpeechBalloonVO(this,_loc2_.getString(),"",false,false,_loc3_,1,_loc4_,1,_loc5_,6,true,false);
      }
      
      override public function update(param1:int, param2:int) : Boolean
      {
         var _loc5_:GTween = null;
         super.update(param1,param2);
         if(this.firstUpdate_)
         {
            if(this.minsLeft_ == 2147483647)
            {
               _loc5_ = new GTween(this,0.5 * T,{"size_":150},{"ease":Sine.easeOut});
               _loc5_.nextTween = new GTween(this,0.5 * T,{"size_":100},{"ease":Sine.easeIn});
               _loc5_.nextTween.paused = true;
            }
            this.firstUpdate_ = false;
         }
         this.untilNextMessage_ -= param2;
         if(this.untilNextMessage_ > 0)
         {
            return true;
         }
         this.untilNextMessage_ = 5000;
         var _loc3_:Vector.<int> = new Vector.<int>();
         if(this.minsLeft_ == 2147483647)
         {
            _loc3_.push(NEW_MESSAGE);
         }
         else if(this.minsLeft_ >= 0 && this.minsLeft_ <= 5)
         {
            _loc3_.push(MINS_LEFT_MESSAGE);
         }
         if(this.count_ >= 1 && this.count_ <= 2)
         {
            _loc3_.push(ITEMS_LEFT_MESSAGE);
         }
         if(this.discount_ > 0)
         {
            _loc3_.push(DISCOUNT_MESSAGE);
         }
         if(_loc3_.length == 0)
         {
            return true;
         }
         this.messageIndex_ = ++this.messageIndex_ % _loc3_.length;
         var _loc4_:int = _loc3_[this.messageIndex_];
         this.addSpeechBalloon.dispatch(this.getSpeechBalloon(_loc4_));
         return true;
      }
      
      override public function soldObjectName() : String
      {
         return ObjectLibrary.typeToDisplayId_[this.merchandiseType_];
      }
      
      override public function soldObjectInternalName() : String
      {
         var _loc1_:XML = ObjectLibrary.xmlLibrary_[this.merchandiseType_];
         return _loc1_.@id.toString();
      }
      
      override public function getTooltip() : ToolTip
      {
         return new EquipmentToolTip(this.merchandiseType_,map_.player_,-1,InventoryOwnerTypes.NPC);
      }
      
      override public function getSellableType() : int
      {
         return this.merchandiseType_;
      }
      
      override public function getIcon() : BitmapData
      {
         var _loc3_:BaseSimpleText = null;
         var _loc1_:BitmapData = ObjectLibrary.getRedrawnTextureFromType(this.merchandiseType_,80,true);
         var _loc2_:XML = ObjectLibrary.xmlLibrary_[this.merchandiseType_];
         if(_loc2_.hasOwnProperty("Doses"))
         {
            _loc1_ = _loc1_.clone();
            _loc3_ = new BaseSimpleText(12,16777215,false,0,0);
            _loc3_.text = String(_loc2_.Doses);
            _loc3_.updateMetrics();
            _loc1_.draw(_loc3_,DOSE_MATRIX);
         }
         return _loc1_;
      }
      
      public function getTex1Id(param1:int) : int
      {
         var _loc2_:XML = ObjectLibrary.xmlLibrary_[this.merchandiseType_];
         if(_loc2_ == null)
         {
            return param1;
         }
         if(_loc2_.Activate == "Dye" && _loc2_.hasOwnProperty("Tex1"))
         {
            return int(_loc2_.Tex1);
         }
         return param1;
      }
      
      public function getTex2Id(param1:int) : int
      {
         var _loc2_:XML = ObjectLibrary.xmlLibrary_[this.merchandiseType_];
         if(_loc2_ == null)
         {
            return param1;
         }
         if(_loc2_.Activate == "Dye" && _loc2_.hasOwnProperty("Tex2"))
         {
            return int(_loc2_.Tex2);
         }
         return param1;
      }
      
      override protected function getTexture(param1:Camera, param2:int) : BitmapData
      {
         if(this.alpha_ == 1 && size_ == 100)
         {
            return this.merchandiseTexture_;
         }
         var _loc3_:BitmapData = ObjectLibrary.getRedrawnTextureFromType(this.merchandiseType_,size_,false,false);
         if(this.alpha_ != 1)
         {
            this.ct_.alphaMultiplier = this.alpha_;
            _loc3_.colorTransform(_loc3_.rect,this.ct_);
         }
         return _loc3_;
      }
      
      public function setMerchandiseType(param1:int) : void
      {
         this.merchandiseType_ = param1;
         this.merchandiseTexture_ = ObjectLibrary.getRedrawnTextureFromType(this.merchandiseType_,100,false);
      }
   }
}

