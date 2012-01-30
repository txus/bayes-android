package org.txus.test

import android.app.Activity
import android.content.Context
import android.os.Bundle
import android.util.Log

import android.view.View
import android.view.MotionEvent
# import android.view.View.OnClickListener

import android.graphics.Canvas
import android.graphics.Paint

class NodeView < View

  def initialize(context:Context)
    super(context)
    @paint = Paint.new
    @paint.setARGB(250, 50, 50, 200)
    @text_paint = Paint.new
    @text_paint.setARGB(250, 250, 250, 250)

    @text = "(node)"

    @y = @x = @radius = float(50.0)
    @vx = @vy = float(1.0)
  end

  def on_node(x:float, y:float)
    Math.abs(x - @x) <= @radius and Math.abs(y - @y) <= @radius
  end

  def onTouchEvent(event:MotionEvent)
    if event.getAction == MotionEvent.ACTION_DOWN
      if on_node(event.getX, event.getY)
        @down = true
        return true
      end
    elsif event.getAction == MotionEvent.ACTION_MOVE
      if @down
        @x = event.getX
        @y = event.getY
        return true
      end
    elsif event.getAction == MotionEvent.ACTION_UP
      @down = true
      return true
    end
    return false
  end

  def onDraw(canvas:Canvas)
    canvas.drawCircle(@x, @y, @radius, @paint)
    canvas.drawText(@text, @x , @y, @text_paint)
    Thread.sleep(10)
    invalidate
  end
end

class TestActivity < Activity
  def onCreate(state)
    @state = state
    super(state)
    @view = NodeView.new(self)
    setContentView(@view)
  end
end
