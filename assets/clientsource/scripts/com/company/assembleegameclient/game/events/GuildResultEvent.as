package com.company.assembleegameclient.game.events
{
   import flash.events.Event;
   
   public class GuildResultEvent extends Event
   {
      
      public static const EVENT:String = "GUILDRESULTEVENT";
      
      public var success_:Boolean;
      
      public var errorKey:String;
      
      public var errorTokens:Object;
      
      public function GuildResultEvent(param1:Boolean, param2:String, param3:Object)
      {
         super(EVENT);
         this.success_ = param1;
         this.errorKey = param2;
         this.errorTokens = param3;
      }
   }
}

