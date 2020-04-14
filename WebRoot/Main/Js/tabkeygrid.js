Ext.override(Ext.grid.RowSelectionModel, {
	   onEditorKey : function(field, e){
	
	 var theSelectionModel = grid.getSelectionModel();
	    theSelectionModel.onEditorKey = function(field, e)
	    {
	      var k = e.getKey(), newCell, g = theSelectionModel.grid, ed = g.activeEditor;
	      if(k == e.ENTER && !e.ctrlKey){
	            e.stopEvent();
	            ed.completeEdit();
	      }
	    };
    var k = e.getKey(), newCell, g = this.grid, ed = g.activeEditor;
    if(k == e.TAB){
    	//alert("11 "+ ed.completeEdit());
        e.stopEvent();
        ed.completeEdit();
        if(e.shiftKey){
            newCell = g.walkCells(ed.row, ed.col-1, -1, this.acceptsNav, this);
        }else{
            newCell = g.walkCells(ed.row, ed.col+1, 1, this.acceptsNav, this);
        }
    }else if(k == e.ENTER && !e.ctrlKey){
        e.stopEvent();
        ed.completeEdit();
        if(e.shiftKey){
            newCell = g.walkCells(ed.row-1, ed.col, -1, this.acceptsNav, this);
        }else{
            newCell = g.walkCells(ed.row+1, ed.col, 1, this.acceptsNav, this);
        }
    }else if(k == e.ESC){
        ed.cancelEdit();
    }
    if(newCell){
        g.startEditing(newCell[0], newCell[1]);
    }
}
    });
   Ext.override(Ext.grid.RowSelectionModel, {
    acceptsNav : function(row, col, cm){
      var rec = false;
      if(cm.getCellEditor(col, row))
      {
      rec=true;
      }
        return !cm.isHidden(col) && rec;
    }
    });
    
      Ext.override(Ext.grid.GridPanel, {   
    walkCells : function(row, col, step, fn, scope){
        var cm = this.colModel, clen = cm.getColumnCount();
        var ds = this.store, rlen = ds.getCount(), first = true;
        if(step < 0){
            if(col < 0){
                row--;
                first = false;
            }
            while(row >= 0){
                if(!first){
                    col = clen-1;
                }
                first = false;
                while(col >= 0){
                    if(fn.call(scope || this, row, col, cm) === true){
                        return [row, col];
                    }
                    col--;
                }
                row--;
            }
        } else {
            if(col >= clen){
                row++;
                first = false;
            }
            while(row < rlen){
                if(!first){
                    col = 0;
                }
                first = false;
                while(col < clen){
                if(this.getColumnModel().config[col].editor)
                {
                   onCellClick(this, row, col);
                 }  
                    if(fn.call(scope || this, row, col, cm) === true){
                        return [row, col];
                    }
                    col++;
                }
                row++;
            }
        }
        return null;
    }
    });