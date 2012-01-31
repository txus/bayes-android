package org.txus.test

import java.util.ArrayList

import android.app.Activity
import android.content.Context
import android.os.Bundle
import android.util.Log

import android.widget.RelativeLayout
import android.widget.RelativeLayout.LayoutParams

import android.view.View
import android.view.MotionEvent
import android.view.Display

import android.graphics.Canvas
import android.graphics.Paint

class GeneratorView < View
  def initialize(context:Context)
    super(context)
    @context = context
    @activity = TestActivity(context)

    @paint = Paint.new
    @paint.setARGB(50, 250, 50, 200)
    @paint.setAntiAlias(true);
    width = float(@activity.getWindowManager.getDefaultDisplay.getWidth)
    @x = width / 2
    @y = float(10.0)
    @radius = float(30.0)
  end

  def add(radius:float, text:string)
    view = NodeView.new(@context, radius)
    view.text = text
    @activity.addContentView(view, DefaultLayoutParams.params)
  end

  def onDraw(canvas:Canvas)
    canvas.drawCircle(@x, @y, @radius, @paint)
    invalidate
  end
end

class NodeView < View
  def text
    @text
  end

  def text=(text:string)
    @text = text
  end

  def initialize(context:Context, radius:float)
    super(context)
    @paint = Paint.new
    @paint.setARGB(250, 50, 50, 200)
    @paint.setAntiAlias(true);
    @text_paint = Paint.new
    @text_paint.setARGB(250, 250, 250, 250)

    @text = "(node)"

    @y = @x = @radius = radius
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
    invalidate
  end
end

class DefaultLayoutParams
  def self.params
    RelativeLayout.LayoutParams.new(
      -2, -2 # Wrap content
    )
  end
end

class TestActivity < Activity
  def onCreate(state)
    @state = state
    @nodes = ArrayList.new
    super(state)

    @nodes.add NodeView.new(self, float(50.0))
    @nodes.add NodeView.new(self, float(20.0))

    generator_view = GeneratorView.new(self)

    @nodes.each do |node|
      addContentView(NodeView(node), DefaultLayoutParams.params)
    end

    addContentView(generator_view, DefaultLayoutParams.params)

    # generator_view.add(float(70.0), "hello")
  end
end
