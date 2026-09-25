package kabam.rotmg.messaging.impl.incoming
{
   import flash.utils.IDataInput;
   
   public class MapInfo extends IncomingMessage
   {
      
      public var width_:int;
      
      public var height_:int;
      
      public var name_:String;
      
      public var displayName_:String;
      
      public var difficulty_:int;
      
      public var fp_:uint;
      
      public var background_:int;
      
      public var allowPlayerTeleport_:Boolean;
      
      public var showDisplays_:Boolean;
      
      public var clientXML_:Vector.<String> = new Vector.<String>();
      
      public var extraXML_:Vector.<String> = new Vector.<String>();
      
      public function MapInfo(param1:uint, param2:Function)
      {
         super(param1,param2);
      }
      
      override public function parseFromInput(param1:IDataInput) : void
      {
         this.parseProperties(param1);
         this.parseXML(param1);
      }
      
      private function parseProperties(param1:IDataInput) : void
      {
         this.width_ = param1.readInt();
         this.height_ = param1.readInt();
         this.name_ = param1.readUTF();
         this.displayName_ = param1.readUTF();
         this.fp_ = param1.readUnsignedInt();
         this.background_ = param1.readInt();
         this.difficulty_ = param1.readInt();
         this.allowPlayerTeleport_ = param1.readBoolean();
         this.showDisplays_ = param1.readBoolean();
      }
      
      private function parseXML(param1:IDataInput) : void
      {
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         _loc2_ = param1.readShort();
         this.clientXML_.length = 0;
         _loc3_ = 0;
         while(_loc3_ < _loc2_)
         {
            _loc4_ = param1.readInt();
            this.clientXML_.push(param1.readUTFBytes(_loc4_));
            _loc3_++;
         }
         _loc2_ = param1.readShort();
         this.extraXML_.length = 0;
         _loc3_ = 0;
         while(_loc3_ < _loc2_)
         {
            _loc4_ = param1.readInt();
            this.extraXML_.push(param1.readUTFBytes(_loc4_));
            _loc3_++;
         }
      }
      
      override public function toString() : String
      {
         return formatToString("MAPINFO","width_","height_","name_","fp_","background_","allowPlayerTeleport_","showDisplays_","clientXML_","extraXML_");
      }
   }
}

