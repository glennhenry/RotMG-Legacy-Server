package kabam.rotmg.messaging.impl.incoming
{
   import com.company.assembleegameclient.util.FreeList;
   import flash.utils.IDataInput;
   import kabam.rotmg.messaging.impl.data.ObjectStatusData;
   
   public class NewTick extends IncomingMessage
   {
      
      public var tickId_:int;
      
      public var tickTime_:int;
      
      public var statuses_:Vector.<ObjectStatusData> = new Vector.<ObjectStatusData>();
      
      public function NewTick(param1:uint, param2:Function)
      {
         super(param1,param2);
      }
      
      override public function parseFromInput(param1:IDataInput) : void
      {
         var _loc3_:int = 0;
         this.tickId_ = param1.readInt();
         this.tickTime_ = param1.readInt();
         var _loc2_:int = param1.readShort();
         _loc3_ = _loc2_;
         while(_loc3_ < this.statuses_.length)
         {
            FreeList.deleteObject(this.statuses_[_loc3_]);
            _loc3_++;
         }
         this.statuses_.length = Math.min(_loc2_,this.statuses_.length);
         while(this.statuses_.length < _loc2_)
         {
            this.statuses_.push(FreeList.newObject(ObjectStatusData) as ObjectStatusData);
         }
         _loc3_ = 0;
         while(_loc3_ < _loc2_)
         {
            this.statuses_[_loc3_].parseFromInput(param1);
            _loc3_++;
         }
      }
      
      override public function toString() : String
      {
         return formatToString("NEW_TICK","tickId_","tickTime_","statuses_");
      }
   }
}

