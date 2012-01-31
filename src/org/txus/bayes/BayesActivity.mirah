package org.txus.bayes

import java.util.ArrayList

import android.app.Activity
import android.content.Context
import android.os.Bundle
import android.util.Log

class BayesActivity < Activity
  def generator
    @generator
  end

  def nodes
    @nodes
  end

  def add_node(node:NodeView)
    @nodes.add node
    addContentView(node, DefaultLayoutParams.params)
  end

  def onCreate(state)
    @state = state
    @nodes = ArrayList.new
    super(state)

    @generator = GeneratorView.new(self)

    addContentView(@generator, DefaultLayoutParams.params)
  end
end
