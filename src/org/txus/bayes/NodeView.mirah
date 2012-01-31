package org.txus.bayes

import android.content.Context
import android.util.Log
import android.os.SystemClock

import android.view.ViewManager

import android.view.View
import android.view.MotionEvent
import android.view.View.OnLongClickListener
import android.view.GestureDetector

import android.graphics.Canvas
import android.graphics.Paint

class NodeView < View
  def self.short_tap_threshold
    300
  end

  def self.active_pointer_id
    @active_pointer_id
  end
  def self.active_pointer_id=(value:int)
    @active_pointer_id = value
  end

  def name; @name; end
  def name=(name:string); @name = name; end

  def x; @x; end
  def x=(value:float); @x = value; end
  def y; @y; end
  def y=(value:float); @y = value; end

  def down; @down; end

  def context
    Context(@activity)
  end

  def initialize(context:Context, radius:float)
    super(context)
    @paint = Paint.new
    @paint.setARGB(250, 50, 50, 200)
    @paint.setAntiAlias(true);
    @text_paint = Paint.new
    @text_paint.setARGB(250, 250, 250, 250)
    @activity = BayesActivity(context)
    @generator = @activity.generator

    @name = "(node)"

    @down = false
    @gestureStartTime = long(0.0)

    @y = @x = @radius = radius
  end

  def on_node(x:float, y:float)
    Math.abs(x - @x) <= @radius and Math.abs(y - @y) <= @radius
  end

  def onTouchEvent(event:MotionEvent)
    action = event.getAction
    masked_action = action & MotionEvent.ACTION_MASK
    if masked_action == MotionEvent.ACTION_DOWN
      Log.v("HEY", "Down at #{@gestureStartTime}!")

      if on_node(event.getX, event.getY)
        @gestureStartTime = SystemClock.uptimeMillis();
        @down = true
        return true
      end

      NodeView.active_pointer_id = event.getPointerId(0)
    elsif masked_action == MotionEvent.ACTION_MOVE
      if @down
        @x = event.getX
        @y = event.getY
        invalidate
        return true
      end
    elsif masked_action == MotionEvent.ACTION_UP

      # Calculate short tap
      now = SystemClock.uptimeMillis()
      elapsed = now - @gestureStartTime
      if on_node(event.getX, event.getY) &&
        (@gestureStartTime > 0.0 && elapsed < NodeView.short_tap_threshold)

        # Short tap
        show_menu
      end
      @gestureStartTime = long(0.0)


      if @generator.on_me(event.getX, event.getY)
        # Destroy node
        view = View(self)
        ViewManager(view.getParent()).removeView(view)
      end
      # NodeView.active_pointer_id = -1
      @down = false
      return true
    elsif masked_action == MotionEvent.ACTION_CANCEL
      @gestureStartTime = long(0.0)
      @down = false
      NodeView.active_pointer_id = -1
      return true
    elsif masked_action == MotionEvent.ACTION_POINTER_UP
      @gestureStartTime = long(0.0)
      pointerIndex = (action & MotionEvent.ACTION_POINTER_INDEX_MASK) >> MotionEvent.ACTION_POINTER_INDEX_SHIFT

      pointerId = event.getPointerId(pointerIndex)
      if pointerId != NodeView.active_pointer_id
        newPointerIndex = pointerIndex

        secondX = event.getX(newPointerIndex);
        secondY = event.getY(newPointerIndex);

        NodeView.active_pointer_id = -1

        if node = NodeView(pinching_other_node_at(secondX, secondY))
          Log.v "BAYES", "Relating #{@name} -> #{node.name}"
        end
      end

      @down = false
      if @generator.on_me(event.getX, event.getY)
        # Destroy node
        view = View(self)
        ViewManager(view.getParent()).removeView(view)
      end
      return true
    end
    return false
  end

  def onDraw(canvas:Canvas)
    canvas.drawCircle(@x, @y, @radius, @paint)
    canvas.drawText(@name, @x , @y, @text_paint)
  end

  def pinching_other_node_at(x:float, y:float)
    @activity.nodes.each do |_node|
      node = NodeView(_node)
      if node.on_node(x, y)
        return node
      end
    end
    nil
  end

  def show_menu
    listener = OnDialogReadyListener.new(self)
    dialog = NodeDialog.new(self, @name, "fooo", "baaaar", listener);
    dialog.show();
  end
end

NodeView.active_pointer_id = -1

