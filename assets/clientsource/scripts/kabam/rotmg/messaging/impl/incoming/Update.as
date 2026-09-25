package kabam.rotmg.messaging.impl.incoming
{
   import com.company.assembleegameclient.util.FreeList;
   import flash.utils.IDataInput;
   import kabam.rotmg.messaging.impl.data.GroundTileData;
   import kabam.rotmg.messaging.impl.data.ObjectData;
   
   public class Update extends IncomingMessage
   {
      
      public var tiles_:Vector.<GroundTileData> = new Vector.<GroundTileData>();
      
      public var newObjs_:Vector.<ObjectData> = new Vector.<ObjectData>();
      
      public var drops_:Vector.<int> = new Vector.<int>();
      
      public function Update(param1:uint, param2:Function)
      {
         super(param1,param2);
      }
      
      override public function parseFromInput(param1:IDataInput) : void
      {
         var _loc2_:int = 0;
         var _loc3_:int = param1.readShort();
         _loc2_ = _loc3_;
         while(_loc2_ < this.tiles_.length)
         {
            FreeList.deleteObject(this.tiles_[_loc2_]);
            _loc2_++;
         }
         this.tiles_.length = Math.min(_loc3_,this.tiles_.length);
         while(this.tiles_.length < _loc3_)
         {
            this.tiles_.push(FreeList.newObject(GroundTileData) as GroundTileData);
         }
         _loc2_ = 0;
         while(_loc2_ < _loc3_)
         {
            this.tiles_[_loc2_].parseFromInput(param1);
            _loc2_++;
         }
         this.newObjs_.length = 0;
         _loc3_ = param1.readShort();
         _loc2_ = _loc3_;
         while(_loc2_ < this.newObjs_.length)
         {
            FreeList.deleteObject(this.newObjs_[_loc2_]);
            _loc2_++;
         }
         this.newObjs_.length = Math.min(_loc3_,this.newObjs_.length);
         while(this.newObjs_.length < _loc3_)
         {
            this.newObjs_.push(FreeList.newObject(ObjectData) as ObjectData);
         }
         _loc2_ = 0;
         while(_loc2_ < _loc3_)
         {
            this.newObjs_[_loc2_].parseFromInput(param1);
            _loc2_++;
         }
         this.drops_.length = 0;
         var _loc4_:int = param1.readShort();
         _loc2_ = 0;
         while(_loc2_ < _loc4_)
         {
            this.drops_.push(param1.readInt());
            _loc2_++;
         }
      }
      
      override public function toString() : String
      {
         return formatToString("UPDATE","tiles_","newObjs_","drops_");
      }
   }
}

