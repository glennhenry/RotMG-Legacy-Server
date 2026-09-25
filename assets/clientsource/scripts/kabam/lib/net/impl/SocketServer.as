package kabam.lib.net.impl
{
   import com.hurlant.crypto.symmetric.ICipher;
   import flash.events.Event;
   import flash.events.IOErrorEvent;
   import flash.events.ProgressEvent;
   import flash.events.SecurityErrorEvent;
   import flash.events.TimerEvent;
   import flash.net.Socket;
   import flash.utils.ByteArray;
   import flash.utils.Timer;
   import kabam.lib.net.api.MessageProvider;
   import org.osflash.signals.Signal;
   
   public class SocketServer
   {
      
      public static const MESSAGE_LENGTH_SIZE_IN_BYTES:int = 4;
      
      [Inject]
      public var messages:MessageProvider;
      
      [Inject]
      public var socket:Socket;
      
      [Inject]
      public var socketServerModel:SocketServerModel;
      
      public const connected:Signal = new Signal();
      
      public const closed:Signal = new Signal();
      
      public const error:Signal = new Signal(String);
      
      public var delayTimer:Timer;
      
      private const unsentPlaceholder:Message = new Message(0);
      
      private const data:ByteArray = new ByteArray();
      
      private var head:Message = this.unsentPlaceholder;
      
      private var tail:Message = this.unsentPlaceholder;
      
      private var messageLen:int = -1;
      
      private var outgoingCipher:ICipher;
      
      private var incomingCipher:ICipher;
      
      private var server:String;
      
      private var port:int;
      
      public function SocketServer()
      {
         super();
      }
      
      public function setOutgoingCipher(param1:ICipher) : SocketServer
      {
         this.outgoingCipher = param1;
         return this;
      }
      
      public function setIncomingCipher(param1:ICipher) : SocketServer
      {
         this.incomingCipher = param1;
         return this;
      }
      
      public function connect(param1:String, param2:int) : void
      {
         this.server = param1;
         this.port = param2;
         this.addListeners();
         this.messageLen = -1;
         if(this.socketServerModel.connectDelayMS)
         {
            this.connectWithDelay();
         }
         else
         {
            this.socket.connect(param1,param2);
         }
      }
      
      private function addListeners() : void
      {
         this.socket.addEventListener(Event.CONNECT,this.onConnect);
         this.socket.addEventListener(Event.CLOSE,this.onClose);
         this.socket.addEventListener(ProgressEvent.SOCKET_DATA,this.onSocketData);
         this.socket.addEventListener(IOErrorEvent.IO_ERROR,this.onIOError);
         this.socket.addEventListener(SecurityErrorEvent.SECURITY_ERROR,this.onSecurityError);
      }
      
      private function connectWithDelay() : void
      {
         this.delayTimer = new Timer(this.socketServerModel.connectDelayMS,1);
         this.delayTimer.addEventListener(TimerEvent.TIMER_COMPLETE,this.onTimerComplete);
         this.delayTimer.start();
      }
      
      private function onTimerComplete(param1:TimerEvent) : void
      {
         this.delayTimer.removeEventListener(TimerEvent.TIMER_COMPLETE,this.onTimerComplete);
         this.socket.connect(this.server,this.port);
      }
      
      public function disconnect() : void
      {
         this.socket.close();
         this.removeListeners();
         this.closed.dispatch();
      }
      
      private function removeListeners() : void
      {
         this.socket.removeEventListener(Event.CONNECT,this.onConnect);
         this.socket.removeEventListener(Event.CLOSE,this.onClose);
         this.socket.removeEventListener(ProgressEvent.SOCKET_DATA,this.onSocketData);
         this.socket.removeEventListener(IOErrorEvent.IO_ERROR,this.onIOError);
         this.socket.removeEventListener(SecurityErrorEvent.SECURITY_ERROR,this.onSecurityError);
      }
      
      public function sendMessage(param1:Message) : void
      {
         this.tail.next = param1;
         this.tail = param1;
         this.socket.connected && this.sendPendingMessages();
      }
      
      private function sendPendingMessages() : void
      {
         var _loc1_:Message = this.head.next;
         var _loc2_:Message = _loc1_;
         while(_loc2_)
         {
            this.data.clear();
            _loc2_.writeToOutput(this.data);
            this.data.position = 0;
            if(this.outgoingCipher != null)
            {
               this.outgoingCipher.encrypt(this.data);
               this.data.position = 0;
            }
            this.socket.writeInt(this.data.bytesAvailable + 5);
            this.socket.writeByte(_loc2_.id);
            this.socket.writeBytes(this.data);
            _loc2_.consume();
            _loc2_ = _loc2_.next;
         }
         this.socket.flush();
         this.unsentPlaceholder.next = null;
         this.unsentPlaceholder.prev = null;
         this.head = this.tail = this.unsentPlaceholder;
      }
      
      private function onConnect(param1:Event) : void
      {
         this.sendPendingMessages();
         this.connected.dispatch();
      }
      
      private function onClose(param1:Event) : void
      {
         this.closed.dispatch();
      }
      
      private function onIOError(param1:IOErrorEvent) : void
      {
         var _loc2_:String = this.parseString("Socket-Server IO Error: {0}",[param1.text]);
         this.error.dispatch(_loc2_);
         this.closed.dispatch();
      }
      
      private function onSecurityError(param1:SecurityErrorEvent) : void
      {
         var _loc2_:String = this.parseString("Socket-Server Security Error: {0}",[param1.text]);
         this.error.dispatch(_loc2_);
         this.closed.dispatch();
      }
      
      private function onSocketData(param1:ProgressEvent = null) : void
      {
         var messageId:uint = 0;
         var message:Message = null;
         var data:ByteArray = null;
         var errorMessage:String = null;
         var _:ProgressEvent = param1;
         while(!(this.socket == null || !this.socket.connected))
         {
            if(this.messageLen == -1)
            {
               if(this.socket.bytesAvailable < 4)
               {
                  break;
               }
               try
               {
                  this.messageLen = this.socket.readInt();
               }
               catch(e:Error)
               {
                  errorMessage = parseString("Socket-Server Data Error: {0}: {1}",[e.name,e.message]);
                  error.dispatch(errorMessage);
                  messageLen = -1;
                  break;
               }
            }
            if(this.socket.bytesAvailable < this.messageLen - MESSAGE_LENGTH_SIZE_IN_BYTES)
            {
               break;
            }
            messageId = this.socket.readUnsignedByte();
            message = this.messages.require(messageId);
            data = new ByteArray();
            if(this.messageLen - 5 > 0)
            {
               this.socket.readBytes(data,0,this.messageLen - 5);
            }
            data.position = 0;
            if(this.incomingCipher != null)
            {
               this.incomingCipher.decrypt(data);
               data.position = 0;
            }
            this.messageLen = -1;
            if(message == null)
            {
               this.logErrorAndClose("Socket-Server Protocol Error: Unknown message");
               break;
            }
            message.parseFromInput(data);
            message.consume();
         }
      }
      
      private function logErrorAndClose(param1:String, param2:Array = null) : void
      {
         this.error.dispatch(this.parseString(param1,param2));
         this.disconnect();
      }
      
      private function parseString(param1:String, param2:Array) : String
      {
         var _loc3_:int = int(param2.length);
         var _loc4_:int = 0;
         while(_loc4_ < _loc3_)
         {
            param1 = param1.replace("{" + _loc4_ + "}",param2[_loc4_]);
            _loc4_++;
         }
         return param1;
      }
      
      public function isConnected() : Boolean
      {
         return this.socket.connected;
      }
   }
}

