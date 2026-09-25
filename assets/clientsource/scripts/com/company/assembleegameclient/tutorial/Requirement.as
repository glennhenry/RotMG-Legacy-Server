package com.company.assembleegameclient.tutorial
{
   import com.company.assembleegameclient.objects.ObjectLibrary;
   
   public class Requirement
   {
      
      public var type_:String;
      
      public var slot_:int = -1;
      
      public var objectType_:int = -1;
      
      public var objectName_:String = "";
      
      public var radius_:Number = 1;
      
      public function Requirement(param1:XML)
      {
         super();
         this.type_ = String(param1);
         var _loc2_:String = String(param1.@objectId);
         if(_loc2_ != null && _loc2_ != "")
         {
            this.objectType_ = ObjectLibrary.idToType_[_loc2_];
         }
         this.objectName_ = String(param1.@objectName).replace("tutorial_script","tutorial");
         if(this.objectName_ == null)
         {
            this.objectName_ = "";
         }
         this.slot_ = int(param1.@slot);
         this.radius_ = Number(param1.@radius);
      }
   }
}

