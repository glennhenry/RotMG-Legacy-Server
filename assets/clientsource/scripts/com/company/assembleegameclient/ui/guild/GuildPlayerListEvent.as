package com.company.assembleegameclient.ui.guild
{
   import flash.events.Event;
   
   public class GuildPlayerListEvent extends Event
   {
      
      public static const SET_RANK:String = "SET_RANK";
      
      public static const REMOVE_MEMBER:String = "REMOVE_MEMBER";
      
      public var name_:String;
      
      public var rank_:int;
      
      public function GuildPlayerListEvent(param1:String, param2:String, param3:int = -1)
      {
         super(param1,true);
         this.name_ = param2;
         this.rank_ = param3;
      }
   }
}

