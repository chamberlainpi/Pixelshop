package pixelshop.managers {
	import com.bigp.utils.undo.IUndoCommand;
	import com.bigp.utils.undo.UndoUtils;

	/**
	 * ...
	 * @author Pierre Chamberlain
	 */
	public class MngUndo extends Manager_Base {
		
		private var _undoUtils:UndoUtils;
		
		private var _queuedCommands:Vector.<IUndoCommand>;
		
		public function MngUndo() {
			super();
			
			_undoUtils =				new UndoUtils();
			_queuedCommands =	new Vector.<IUndoCommand>();
		}
		
		public override function init():void {
			super.init();
			
			Registry.whenDrawEnd.add( onDrawEnd );
		}
		
		protected override function onNewDocument():void {
			super.onNewDocument();
			_undoUtils.clear();
			while(_queuedCommands.length>0) {
				_queuedCommands.pop().destroy();
			}
		}
		
		private function onDrawEnd():void {
			executeQueuedCommands();
		}
		
		private function executeQueuedCommands():void {
			if (!_queuedCommands || _queuedCommands.length == 0) {
				return;
			}
			
			for (var e:int=0, eLen:int=_queuedCommands.length; e<eLen; e++) {
				_undoUtils.add( _queuedCommands[e] );
			}
			
			_queuedCommands.length = 0;
		}
		
		public function add( pCommand:IUndoCommand ):void {
			_queuedCommands.push( pCommand );
		}
		
		public function undo():void {
			_undoUtils.undoIndex--;
		}
		
		public function redo():void {
			_undoUtils.undoIndex++;
		}
		
		public function get undoUtils():UndoUtils { return _undoUtils; }
	}
}