package com.company.assembleegameclient.editor
{
   public class CommandList
   {
      
      private var list_:Vector.<Command> = new Vector.<Command>();
      
      public function CommandList()
      {
         super();
      }
      
      public function empty() : Boolean
      {
         return this.list_.length == 0;
      }
      
      public function addCommand(param1:Command) : void
      {
         this.list_.push(param1);
      }
      
      public function execute() : void
      {
         var _loc1_:Command = null;
         for each(_loc1_ in this.list_)
         {
            _loc1_.execute();
         }
      }
      
      public function unexecute() : void
      {
         var _loc1_:Command = null;
         for each(_loc1_ in this.list_)
         {
            _loc1_.unexecute();
         }
      }
   }
}

