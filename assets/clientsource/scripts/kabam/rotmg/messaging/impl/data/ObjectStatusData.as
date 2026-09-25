package kabam.rotmg.messaging.impl.data
{
   import com.company.assembleegameclient.util.FreeList;
   import flash.utils.IDataInput;
   import flash.utils.IDataOutput;
   
   public class ObjectStatusData
   {
      
      public var objectId_:int;
      
      public var pos_:WorldPosData = new WorldPosData();
      
      public var stats_:Vector.<StatData> = new Vector.<StatData>();
      
      public function ObjectStatusData()
      {
         super();
      }
      
      public function parseFromInput(param1:IDataInput) : void
      {
         var _loc3_:int = 0;
         this.objectId_ = param1.readInt();
         this.pos_.parseFromInput(param1);
         var _loc2_:int = param1.readShort();
         _loc3_ = _loc2_;
         while(_loc3_ < this.stats_.length)
         {
            FreeList.deleteObject(this.stats_[_loc3_]);
            _loc3_++;
         }
         this.stats_.length = Math.min(_loc2_,this.stats_.length);
         while(this.stats_.length < _loc2_)
         {
            this.stats_.push(FreeList.newObject(StatData) as StatData);
         }
         _loc3_ = 0;
         while(_loc3_ < _loc2_)
         {
            this.stats_[_loc3_].parseFromInput(param1);
            _loc3_++;
         }
      }
      
      public function writeToOutput(param1:IDataOutput) : void
      {
         param1.writeInt(this.objectId_);
         this.pos_.writeToOutput(param1);
         param1.writeShort(this.stats_.length);
         var _loc2_:int = 0;
         while(_loc2_ < this.stats_.length)
         {
            this.stats_[_loc2_].writeToOutput(param1);
            _loc2_++;
         }
      }
      
      public function toString() : String
      {
         return "objectId_: " + this.objectId_ + " pos_: " + this.pos_ + " stats_: " + this.stats_;
      }
   }
}

