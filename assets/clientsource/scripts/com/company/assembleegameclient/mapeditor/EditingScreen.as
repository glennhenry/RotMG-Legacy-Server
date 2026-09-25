package com.company.assembleegameclient.mapeditor
{
   import com.company.assembleegameclient.editor.CommandEvent;
   import com.company.assembleegameclient.editor.CommandList;
   import com.company.assembleegameclient.editor.CommandQueue;
   import com.company.assembleegameclient.map.GroundLibrary;
   import com.company.assembleegameclient.map.RegionLibrary;
   import com.company.assembleegameclient.objects.ObjectLibrary;
   import com.company.assembleegameclient.screens.AccountScreen;
   import com.company.assembleegameclient.ui.dropdown.DropDown;
   import com.company.util.IntPoint;
   import com.company.util.SpriteUtil;
   import com.hurlant.util.Base64;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.IOErrorEvent;
   import flash.geom.Rectangle;
   import flash.net.FileFilter;
   import flash.net.FileReference;
   import flash.utils.ByteArray;
   import kabam.lib.json.JsonParser;
   import kabam.rotmg.core.StaticInjectorContext;
   import kabam.rotmg.ui.view.components.ScreenBase;
   import net.hires.debug.Stats;
   
   public class EditingScreen extends Sprite
   {
      
      private static const MAP_Y:int = 600 - MEMap.SIZE - 10;
      
      public static const stats_:Stats = new Stats();
      
      public var commandMenu_:MECommandMenu;
      
      private var commandQueue_:CommandQueue;
      
      public var meMap_:MEMap;
      
      public var infoPane_:InfoPane;
      
      public var chooserDrowDown_:DropDown;
      
      public var groundChooser_:GroundChooser;
      
      public var objChooser_:ObjectChooser;
      
      public var regionChooser_:RegionChooser;
      
      public var chooser_:Chooser;
      
      public var filename_:String = null;
      
      private var json:JsonParser;
      
      private var tilesBackup:Vector.<METile>;
      
      private var loadedFile_:FileReference = null;
      
      public function EditingScreen()
      {
         super();
         addChild(new ScreenBase());
         addChild(new AccountScreen());
         this.json = StaticInjectorContext.getInjector().getInstance(JsonParser);
         this.commandMenu_ = new MECommandMenu();
         this.commandMenu_.x = 15;
         this.commandMenu_.y = MAP_Y - 30;
         this.commandMenu_.addEventListener(CommandEvent.UNDO_COMMAND_EVENT,this.onUndo);
         this.commandMenu_.addEventListener(CommandEvent.REDO_COMMAND_EVENT,this.onRedo);
         this.commandMenu_.addEventListener(CommandEvent.CLEAR_COMMAND_EVENT,this.onClear);
         this.commandMenu_.addEventListener(CommandEvent.LOAD_COMMAND_EVENT,this.onLoad);
         this.commandMenu_.addEventListener(CommandEvent.SAVE_COMMAND_EVENT,this.onSave);
         this.commandMenu_.addEventListener(CommandEvent.TEST_COMMAND_EVENT,this.onTest);
         this.commandMenu_.addEventListener(CommandEvent.SELECT_COMMAND_EVENT,this.onMenuSelect);
         addChild(this.commandMenu_);
         this.commandQueue_ = new CommandQueue();
         this.meMap_ = new MEMap();
         this.meMap_.addEventListener(TilesEvent.TILES_EVENT,this.onTilesEvent);
         this.meMap_.x = 800 / 2 - MEMap.SIZE / 2;
         this.meMap_.y = MAP_Y;
         addChild(this.meMap_);
         this.infoPane_ = new InfoPane(this.meMap_);
         this.infoPane_.x = 4;
         this.infoPane_.y = 600 - InfoPane.HEIGHT - 10;
         addChild(this.infoPane_);
         this.chooserDrowDown_ = new DropDown(new <String>["Ground","Objects","Regions"],Chooser.WIDTH,26);
         this.chooserDrowDown_.x = this.meMap_.x + MEMap.SIZE + 4;
         this.chooserDrowDown_.y = MAP_Y;
         this.chooserDrowDown_.addEventListener(Event.CHANGE,this.onDropDownChange);
         addChild(this.chooserDrowDown_);
         this.groundChooser_ = new GroundChooser();
         this.groundChooser_.x = this.chooserDrowDown_.x;
         this.groundChooser_.y = this.chooserDrowDown_.y + this.chooserDrowDown_.height + 4;
         this.chooser_ = this.groundChooser_;
         addChild(this.groundChooser_);
         this.objChooser_ = new ObjectChooser();
         this.objChooser_.x = this.chooserDrowDown_.x;
         this.objChooser_.y = this.chooserDrowDown_.y + this.chooserDrowDown_.height + 4;
         this.regionChooser_ = new RegionChooser();
         this.regionChooser_.x = this.chooserDrowDown_.x;
         this.regionChooser_.y = this.chooserDrowDown_.y + this.chooserDrowDown_.height + 4;
      }
      
      private function onTilesEvent(param1:TilesEvent) : void
      {
         var _loc2_:IntPoint = null;
         var _loc3_:METile = null;
         var _loc4_:int = 0;
         var _loc5_:String = null;
         var _loc6_:EditTileProperties = null;
         var _loc7_:Vector.<METile> = null;
         _loc2_ = param1.tiles_[0];
         switch(this.commandMenu_.getCommand())
         {
            case MECommandMenu.DRAW_COMMAND:
               this.addModifyCommandList(param1.tiles_,this.chooser_.layer_,this.chooser_.selectedType());
               break;
            case MECommandMenu.ERASE_COMMAND:
               this.addModifyCommandList(param1.tiles_,this.chooser_.layer_,-1);
               break;
            case MECommandMenu.SAMPLE_COMMAND:
               _loc4_ = this.meMap_.getType(_loc2_.x_,_loc2_.y_,this.chooser_.layer_);
               if(_loc4_ == -1)
               {
                  return;
               }
               this.chooser_.setSelectedType(_loc4_);
               this.commandMenu_.setCommand(MECommandMenu.DRAW_COMMAND);
               break;
            case MECommandMenu.EDIT_COMMAND:
               _loc5_ = this.meMap_.getObjectName(_loc2_.x_,_loc2_.y_);
               _loc6_ = new EditTileProperties(param1.tiles_,_loc5_);
               _loc6_.addEventListener(Event.COMPLETE,this.onEditComplete);
               addChild(_loc6_);
               break;
            case MECommandMenu.CUT_COMMAND:
               this.tilesBackup = new Vector.<METile>();
               _loc7_ = new Vector.<METile>();
               for each(_loc2_ in param1.tiles_)
               {
                  _loc3_ = this.meMap_.getTile(_loc2_.x_,_loc2_.y_);
                  if(_loc3_ != null)
                  {
                     _loc3_ = _loc3_.clone();
                  }
                  this.tilesBackup.push(_loc3_);
                  _loc7_.push(null);
               }
               this.addPasteCommandList(param1.tiles_,_loc7_);
               this.meMap_.freezeSelect();
               this.commandMenu_.setCommand(MECommandMenu.PASTE_COMMAND);
               break;
            case MECommandMenu.COPY_COMMAND:
               this.tilesBackup = new Vector.<METile>();
               for each(_loc2_ in param1.tiles_)
               {
                  _loc3_ = this.meMap_.getTile(_loc2_.x_,_loc2_.y_);
                  if(_loc3_ != null)
                  {
                     _loc3_ = _loc3_.clone();
                  }
                  this.tilesBackup.push(_loc3_);
               }
               this.meMap_.freezeSelect();
               this.commandMenu_.setCommand(MECommandMenu.PASTE_COMMAND);
               break;
            case MECommandMenu.PASTE_COMMAND:
               this.addPasteCommandList(param1.tiles_,this.tilesBackup);
         }
         this.meMap_.draw();
      }
      
      private function onEditComplete(param1:Event) : void
      {
         var _loc2_:EditTileProperties = param1.currentTarget as EditTileProperties;
         this.addObjectNameCommandList(_loc2_.tiles_,_loc2_.getObjectName());
      }
      
      private function addModifyCommandList(param1:Vector.<IntPoint>, param2:int, param3:int) : void
      {
         var _loc5_:IntPoint = null;
         var _loc6_:int = 0;
         var _loc4_:CommandList = new CommandList();
         for each(_loc5_ in param1)
         {
            _loc6_ = this.meMap_.getType(_loc5_.x_,_loc5_.y_,param2);
            if(_loc6_ != param3)
            {
               _loc4_.addCommand(new MEModifyCommand(this.meMap_,_loc5_.x_,_loc5_.y_,param2,_loc6_,param3));
            }
         }
         if(_loc4_.empty())
         {
            return;
         }
         this.commandQueue_.addCommandList(_loc4_);
      }
      
      private function addPasteCommandList(param1:Vector.<IntPoint>, param2:Vector.<METile>) : void
      {
         var _loc5_:IntPoint = null;
         var _loc6_:METile = null;
         var _loc3_:CommandList = new CommandList();
         var _loc4_:int = 0;
         for each(_loc5_ in param1)
         {
            if(_loc4_ >= param2.length)
            {
               break;
            }
            _loc6_ = this.meMap_.getTile(_loc5_.x_,_loc5_.y_);
            _loc3_.addCommand(new MEReplaceCommand(this.meMap_,_loc5_.x_,_loc5_.y_,_loc6_,param2[_loc4_]));
            _loc4_++;
         }
         if(_loc3_.empty())
         {
            return;
         }
         this.commandQueue_.addCommandList(_loc3_);
      }
      
      private function addObjectNameCommandList(param1:Vector.<IntPoint>, param2:String) : void
      {
         var _loc4_:IntPoint = null;
         var _loc5_:String = null;
         var _loc3_:CommandList = new CommandList();
         for each(_loc4_ in param1)
         {
            _loc5_ = this.meMap_.getObjectName(_loc4_.x_,_loc4_.y_);
            if(_loc5_ != param2)
            {
               _loc3_.addCommand(new MEObjectNameCommand(this.meMap_,_loc4_.x_,_loc4_.y_,_loc5_,param2));
            }
         }
         if(_loc3_.empty())
         {
            return;
         }
         this.commandQueue_.addCommandList(_loc3_);
      }
      
      private function onDropDownChange(param1:Event) : void
      {
         switch(this.chooserDrowDown_.getValue())
         {
            case "Ground":
               SpriteUtil.safeAddChild(this,this.groundChooser_);
               SpriteUtil.safeRemoveChild(this,this.objChooser_);
               SpriteUtil.safeRemoveChild(this,this.regionChooser_);
               this.chooser_ = this.groundChooser_;
               break;
            case "Objects":
               SpriteUtil.safeRemoveChild(this,this.groundChooser_);
               SpriteUtil.safeAddChild(this,this.objChooser_);
               SpriteUtil.safeRemoveChild(this,this.regionChooser_);
               this.chooser_ = this.objChooser_;
               break;
            case "Regions":
               SpriteUtil.safeRemoveChild(this,this.groundChooser_);
               SpriteUtil.safeRemoveChild(this,this.objChooser_);
               SpriteUtil.safeAddChild(this,this.regionChooser_);
               this.chooser_ = this.regionChooser_;
         }
      }
      
      private function onUndo(param1:CommandEvent) : void
      {
         this.commandQueue_.undo();
         this.meMap_.draw();
      }
      
      private function onRedo(param1:CommandEvent) : void
      {
         this.commandQueue_.redo();
         this.meMap_.draw();
      }
      
      private function onClear(param1:CommandEvent) : void
      {
         var _loc4_:IntPoint = null;
         var _loc5_:METile = null;
         var _loc2_:Vector.<IntPoint> = this.meMap_.getAllTiles();
         var _loc3_:CommandList = new CommandList();
         for each(_loc4_ in _loc2_)
         {
            _loc5_ = this.meMap_.getTile(_loc4_.x_,_loc4_.y_);
            if(_loc5_ != null)
            {
               _loc3_.addCommand(new MEClearCommand(this.meMap_,_loc4_.x_,_loc4_.y_,_loc5_));
            }
         }
         if(_loc3_.empty())
         {
            return;
         }
         this.commandQueue_.addCommandList(_loc3_);
         this.meMap_.draw();
         this.filename_ = null;
      }
      
      private function createMapJSON() : String
      {
         var _loc7_:int = 0;
         var _loc8_:METile = null;
         var _loc9_:Object = null;
         var _loc10_:String = null;
         var _loc11_:int = 0;
         var _loc1_:Rectangle = this.meMap_.getTileBounds();
         if(_loc1_ == null)
         {
            return null;
         }
         var _loc2_:Object = {};
         _loc2_["width"] = int(_loc1_.width);
         _loc2_["height"] = int(_loc1_.height);
         var _loc3_:Object = {};
         var _loc4_:Array = [];
         var _loc5_:ByteArray = new ByteArray();
         var _loc6_:int = _loc1_.y;
         while(_loc6_ < _loc1_.bottom)
         {
            _loc7_ = _loc1_.x;
            while(_loc7_ < _loc1_.right)
            {
               _loc8_ = this.meMap_.getTile(_loc7_,_loc6_);
               _loc9_ = this.getEntry(_loc8_);
               _loc10_ = this.json.stringify(_loc9_);
               if(!_loc3_.hasOwnProperty(_loc10_))
               {
                  _loc11_ = int(_loc4_.length);
                  _loc3_[_loc10_] = _loc11_;
                  _loc4_.push(_loc9_);
               }
               else
               {
                  _loc11_ = int(_loc3_[_loc10_]);
               }
               _loc5_.writeShort(_loc11_);
               _loc7_++;
            }
            _loc6_++;
         }
         _loc2_["dict"] = _loc4_;
         _loc5_.compress();
         _loc2_["data"] = Base64.encodeByteArray(_loc5_);
         return this.json.stringify(_loc2_);
      }
      
      private function onSave(param1:CommandEvent) : void
      {
         var _loc2_:String = this.createMapJSON();
         if(_loc2_ == null)
         {
            return;
         }
         new FileReference().save(_loc2_,this.filename_ == null ? "map.jm" : this.filename_);
      }
      
      private function getEntry(param1:METile) : Object
      {
         var _loc3_:Vector.<int> = null;
         var _loc4_:String = null;
         var _loc5_:Object = null;
         var _loc2_:Object = {};
         if(param1 != null)
         {
            _loc3_ = param1.types_;
            if(_loc3_[Layer.GROUND] != -1)
            {
               _loc4_ = GroundLibrary.getIdFromType(_loc3_[Layer.GROUND]);
               _loc2_["ground"] = _loc4_;
            }
            if(_loc3_[Layer.OBJECT] != -1)
            {
               _loc4_ = ObjectLibrary.getIdFromType(_loc3_[Layer.OBJECT]);
               _loc5_ = {"id":_loc4_};
               if(param1.objName_ != null)
               {
                  _loc5_["name"] = param1.objName_;
               }
               _loc2_["objs"] = [_loc5_];
            }
            if(_loc3_[Layer.REGION] != -1)
            {
               _loc4_ = RegionLibrary.getIdFromType(_loc3_[Layer.REGION]);
               _loc2_["regions"] = [{"id":_loc4_}];
            }
         }
         return _loc2_;
      }
      
      private function onLoad(param1:CommandEvent) : void
      {
         this.loadedFile_ = new FileReference();
         this.loadedFile_.addEventListener(Event.SELECT,this.onFileBrowseSelect);
         this.loadedFile_.browse([new FileFilter("JSON Map (*.jm)","*.jm")]);
      }
      
      private function onFileBrowseSelect(param1:Event) : void
      {
         var event:Event = param1;
         var loadedFile:FileReference = event.target as FileReference;
         loadedFile.addEventListener(Event.COMPLETE,this.onFileLoadComplete);
         loadedFile.addEventListener(IOErrorEvent.IO_ERROR,this.onFileLoadIOError);
         try
         {
            loadedFile.load();
         }
         catch(e:Error)
         {
         }
      }
      
      private function onFileLoadComplete(param1:Event) : void
      {
         var _loc9_:int = 0;
         var _loc11_:int = 0;
         var _loc12_:Object = null;
         var _loc13_:Array = null;
         var _loc14_:Array = null;
         var _loc15_:Object = null;
         var _loc16_:Object = null;
         var _loc2_:FileReference = param1.target as FileReference;
         this.filename_ = _loc2_.name;
         var _loc3_:Object = this.json.parse(_loc2_.data.toString());
         var _loc4_:int = int(_loc3_["width"]);
         var _loc5_:int = int(_loc3_["height"]);
         var _loc6_:Rectangle = new Rectangle(int(MEMap.NUM_SQUARES / 2 - _loc4_ / 2),int(MEMap.NUM_SQUARES / 2 - _loc5_ / 2),_loc4_,_loc5_);
         this.meMap_.clear();
         this.commandQueue_.clear();
         var _loc7_:Array = _loc3_["dict"];
         var _loc8_:ByteArray = Base64.decodeToByteArray(_loc3_["data"]);
         _loc8_.uncompress();
         var _loc10_:int = _loc6_.y;
         while(_loc10_ < _loc6_.bottom)
         {
            _loc11_ = _loc6_.x;
            while(_loc11_ < _loc6_.right)
            {
               _loc12_ = _loc7_[_loc8_.readShort()];
               if(_loc12_.hasOwnProperty("ground"))
               {
                  _loc9_ = int(GroundLibrary.idToType_[_loc12_["ground"]]);
                  this.meMap_.modifyTile(_loc11_,_loc10_,Layer.GROUND,_loc9_);
               }
               _loc13_ = _loc12_["objs"];
               if(_loc13_ != null)
               {
                  for each(_loc15_ in _loc13_)
                  {
                     if(ObjectLibrary.idToType_.hasOwnProperty(_loc15_["id"]))
                     {
                        _loc9_ = int(ObjectLibrary.idToType_[_loc15_["id"]]);
                        this.meMap_.modifyTile(_loc11_,_loc10_,Layer.OBJECT,_loc9_);
                        if(_loc15_.hasOwnProperty("name"))
                        {
                           this.meMap_.modifyObjectName(_loc11_,_loc10_,_loc15_["name"]);
                        }
                     }
                  }
               }
               _loc14_ = _loc12_["regions"];
               if(_loc14_ != null)
               {
                  for each(_loc16_ in _loc14_)
                  {
                     _loc9_ = int(RegionLibrary.idToType_[_loc16_["id"]]);
                     this.meMap_.modifyTile(_loc11_,_loc10_,Layer.REGION,_loc9_);
                  }
               }
               _loc11_++;
            }
            _loc10_++;
         }
         this.meMap_.draw();
      }
      
      private function onFileLoadIOError(param1:Event) : void
      {
      }
      
      private function onTest(param1:Event) : void
      {
         dispatchEvent(new MapTestEvent(this.createMapJSON()));
      }
      
      private function onMenuSelect(param1:Event) : void
      {
         if(this.meMap_ != null)
         {
            this.meMap_.clearSelect();
         }
      }
   }
}

