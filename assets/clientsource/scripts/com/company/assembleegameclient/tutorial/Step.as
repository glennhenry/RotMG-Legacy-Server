package com.company.assembleegameclient.tutorial
{
   public class Step
   {
      
      public var text_:String;
      
      public var action_:String;
      
      public var uiDrawBoxes_:Vector.<UIDrawBox>;
      
      public var uiDrawArrows_:Vector.<UIDrawArrow>;
      
      public var reqs_:Vector.<Requirement>;
      
      public var satisfiedSince_:int = 0;
      
      public function Step(param1:XML)
      {
         var _loc2_:XML = null;
         var _loc3_:XML = null;
         var _loc4_:XML = null;
         this.uiDrawBoxes_ = new Vector.<UIDrawBox>();
         this.uiDrawArrows_ = new Vector.<UIDrawArrow>();
         this.reqs_ = new Vector.<Requirement>();
         super();
         for each(_loc2_ in param1.UIDrawBox)
         {
            this.uiDrawBoxes_.push(new UIDrawBox(_loc2_));
         }
         for each(_loc3_ in param1.UIDrawArrow)
         {
            this.uiDrawArrows_.push(new UIDrawArrow(_loc3_));
         }
         for each(_loc4_ in param1.Requirement)
         {
            this.reqs_.push(new Requirement(_loc4_));
         }
      }
      
      public function toString() : String
      {
         return "[" + this.text_ + "]";
      }
   }
}

