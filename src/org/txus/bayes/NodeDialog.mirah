package org.txus.bayes

import android.app.Dialog;
import android.content.Context;
import android.os.Bundle;
import android.view.View;
import android.widget.Button;
import android.widget.CheckBox;
import android.widget.EditText

import android.util.Log

interface NodeReadyListener do
  def ready(name:string, foo:string, bar:string)
    returns boolean
  end
end

class NodeDialog < Dialog
  def initialize(node:NodeView, name:string, foo:string, bar:string, listener:NodeReadyListener)
    super(node.context)
    @name = name
    @foo = foo
    @bar = bar
    @listener = listener
  end

  def listener
    @listener
  end

  def onCreate(state:Bundle)
    super(state)

    setContentView(R.layout.node_dialog);
    setTitle("Node preferences")

    etName = EditText(findViewById(R.id.name))
    etName.setText(@name)

    etFoo = EditText(findViewById(R.id.foo))
    etFoo.setText(@foo)

    etBar = EditText(findViewById(R.id.bar))
    etBar.setText(@bar)

    buttonOK = Button(findViewById(R.id.buttonOK))

    this = self
    buttonOK.setOnClickListener do |view|
      etName = EditText(this.findViewById(R.id.name))
      etFoo  = EditText(this.findViewById(R.id.foo))
      etBar  = EditText(this.findViewById(R.id.bar))

      this.listener.ready(
        etName.getText.toString,
        etFoo.getText.toString,
        etBar.getText.toString
      )

      this.dismiss
    end
  end
end

class OnDialogReadyListener
  implements NodeReadyListener

  def initialize(node:NodeView)
    @node = node
  end

  def ready(name:string, foo:string, bar:string)
    @node.name = name
    true
  end
end
