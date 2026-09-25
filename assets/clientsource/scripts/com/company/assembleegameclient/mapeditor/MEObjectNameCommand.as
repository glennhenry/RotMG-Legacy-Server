package com.company.assembleegameclient.mapeditor
{
   import com.company.assembleegameclient.editor.Command;
   
   public class MEObjectNameCommand extends Command
   {
      
      private var map_:MEMap;
      
      private var x_:int;
      
      private var y_:int;
      
      private var oldName_:String;
      
      private var newName_:String;
      
      public function MEObjectNameCommand(param1:MEMap, param2:int, param3:int, param4:String, param5:String)
      {
         super();
         this.map_ = param1;
         this.x_ = param2;
         this.y_ = param3;
         this.oldName_ = param4;
         this.newName_ = param5;
      }
      
      override public function execute() : void
      {
         this.map_.modifyObjectName(this.x_,this.y_,this.newName_);
      }
      
      override public function unexecute() : void
      {
         this.map_.modifyObjectName(this.x_,this.y_,this.oldName_);
      }
   }
}

