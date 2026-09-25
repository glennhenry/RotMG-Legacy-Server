package com.company.assembleegameclient.ui.board
{
   import com.company.assembleegameclient.ui.dialogs.Dialog;
   import com.company.util.MoreObjectUtil;
   import flash.display.Graphics;
   import flash.display.Shape;
   import flash.display.Sprite;
   import flash.events.Event;
   import kabam.rotmg.account.core.Account;
   import kabam.rotmg.appengine.api.AppEngineClient;
   import kabam.rotmg.core.StaticInjectorContext;
   
   public class GuildBoardWindow extends Sprite
   {
      
      private var canEdit_:Boolean;
      
      private var darkBox_:Shape;
      
      private var dialog_:Dialog;
      
      private var text_:String;
      
      private var viewBoard_:ViewBoard;
      
      private var editBoard_:EditBoard;
      
      private var client:AppEngineClient;
      
      public function GuildBoardWindow(param1:Boolean)
      {
         super();
         this.canEdit_ = param1;
         this.darkBox_ = new Shape();
         var _loc2_:Graphics = this.darkBox_.graphics;
         _loc2_.clear();
         _loc2_.beginFill(0,0.8);
         _loc2_.drawRect(0,0,800,600);
         _loc2_.endFill();
         addChild(this.darkBox_);
         this.load();
      }
      
      private function load() : void
      {
         var _loc1_:Account = StaticInjectorContext.getInjector().getInstance(Account);
         this.client = StaticInjectorContext.getInjector().getInstance(AppEngineClient);
         this.client.complete.addOnce(this.onGetBoardComplete);
         this.client.sendRequest("/guild/getBoard",_loc1_.getCredentials());
         this.dialog_ = new Dialog(null,"Loading...",null,null,null);
         addChild(this.dialog_);
         this.darkBox_.visible = false;
      }
      
      private function onGetBoardComplete(param1:Boolean, param2:*) : void
      {
         if(param1)
         {
            this.showGuildBoard(param2);
         }
         else
         {
            this.reportError(param2);
         }
      }
      
      private function showGuildBoard(param1:String) : void
      {
         this.darkBox_.visible = true;
         removeChild(this.dialog_);
         this.dialog_ = null;
         this.text_ = param1;
         this.show();
      }
      
      private function show() : void
      {
         this.viewBoard_ = new ViewBoard(this.text_,this.canEdit_);
         this.viewBoard_.addEventListener(Event.COMPLETE,this.onViewComplete);
         this.viewBoard_.addEventListener(Event.CHANGE,this.onViewChange);
         addChild(this.viewBoard_);
      }
      
      private function reportError(param1:String) : void
      {
      }
      
      private function onViewComplete(param1:Event) : void
      {
         parent.removeChild(this);
      }
      
      private function onViewChange(param1:Event) : void
      {
         removeChild(this.viewBoard_);
         this.viewBoard_ = null;
         this.editBoard_ = new EditBoard(this.text_);
         this.editBoard_.addEventListener(Event.CANCEL,this.onEditCancel);
         this.editBoard_.addEventListener(Event.COMPLETE,this.onEditComplete);
         addChild(this.editBoard_);
      }
      
      private function onEditCancel(param1:Event) : void
      {
         removeChild(this.editBoard_);
         this.editBoard_ = null;
         this.show();
      }
      
      private function onEditComplete(param1:Event) : void
      {
         var _loc2_:Account = StaticInjectorContext.getInjector().getInstance(Account);
         var _loc3_:Object = {"board":this.editBoard_.getText()};
         MoreObjectUtil.addToObject(_loc3_,_loc2_.getCredentials());
         this.client = StaticInjectorContext.getInjector().getInstance(AppEngineClient);
         this.client.complete.addOnce(this.onSetBoardComplete);
         this.client.sendRequest("/guild/setBoard",_loc3_);
         removeChild(this.editBoard_);
         this.editBoard_ = null;
         this.dialog_ = new Dialog(null,"Saving...",null,null,null);
         addChild(this.dialog_);
         this.darkBox_.visible = false;
      }
      
      private function onSetBoardComplete(param1:Boolean, param2:*) : void
      {
         if(param1)
         {
            this.onSaveDone(param2);
         }
         else
         {
            this.onSaveError(param2);
         }
      }
      
      private function onSaveDone(param1:String) : void
      {
         this.darkBox_.visible = true;
         removeChild(this.dialog_);
         this.dialog_ = null;
         this.text_ = param1;
         this.show();
      }
      
      private function onSaveError(param1:String) : void
      {
      }
   }
}

