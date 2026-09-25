package com.company.assembleegameclient.mapeditor
{
   import com.company.assembleegameclient.editor.Command;
   
   public class MEModifyCommand extends Command
   {
      
      private var map_:MEMap;
      
      private var x_:int;
      
      private var y_:int;
      
      private var layer_:int;
      
      private var oldType_:int;
      
      private var newType_:int;
      
      public function MEModifyCommand(param1:MEMap, param2:int, param3:int, param4:int, param5:int, param6:int)
      {
         super();
         this.map_ = param1;
         this.x_ = param2;
         this.y_ = param3;
         this.layer_ = param4;
         this.oldType_ = param5;
         this.newType_ = param6;
      }
      
      override public function execute() : void
      {
         this.map_.modifyTile(this.x_,this.y_,this.layer_,this.newType_);
      }
      
      override public function unexecute() : void
      {
         this.map_.modifyTile(this.x_,this.y_,this.layer_,this.oldType_);
      }
   }
}

