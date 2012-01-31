package org.txus.bayes

import android.app.Activity
import android.content.Context
import android.util.Log

import android.view.View
import android.view.MotionEvent
import android.view.Display
import android.view.ViewManager

import android.graphics.Canvas
import android.graphics.Paint

class GeneratorView < View
  def initialize(context:Context)
    super(context)
    @context = context
    @activity = BayesActivity(context)

    @paint = Paint.new
    @paint.setARGB(50, 250, 50, 200)
    @paint.setAntiAlias(true);
    width = float(@activity.getWindowManager.getDefaultDisplay.getWidth)
    @x = width / 2
    @y = float(50.0)
    @radius = float(50.0)
    @current_node = nil
  end

  def on_me(x:float, y:float)
    Math.abs(x - @x) <= @radius and Math.abs(y - @y) <= @radius
  end

  def onTouchEvent(event:MotionEvent)
    if event.getAction == MotionEvent.ACTION_DOWN
      if on_me(event.getX, event.getY)
        @down = true
        @current_node = add(float(25.0), "(new)")
        node = NodeView(@current_node)
        node.x = @x
        node.y = @y
        return true
      end
    elsif event.getAction == MotionEvent.ACTION_MOVE
      if @down && @current_node
        node = NodeView(@current_node)
        node.x = event.getX
        node.y = event.getY
        return true
      end
    elsif event.getAction == MotionEvent.ACTION_UP
      @down = false
      if on_me(event.getX, event.getY)
        # Destroy node
        view = View(@current_node)
        ViewManager(view.getParent()).removeView(view)
      end
      @current_node = nil
      return true
    end
    return false
  end

  def onDraw(canvas:Canvas)
    canvas.drawCircle(@x, @y, @radius, @paint)
    invalidate
  end

  def add(radius:float, name:string)
    view = NodeView.new(@context, radius)
    view.name = name
    @activity.add_node view
    view
  end

  def onDraw(canvas:Canvas)
    canvas.drawCircle(@x, @y, @radius, @paint)
    invalidate
  end
end
